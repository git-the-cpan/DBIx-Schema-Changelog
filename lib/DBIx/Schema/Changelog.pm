package DBIx::Schema::Changelog;

=head1 NAME

DBIx::Schema::Changelog - Continuous Database Migration

=head1 VERSION

Version 0.4.0

=cut

our $VERSION = '0.4.0';

=head1 DESCRIPTION

C<DBIx::Schema::Changelog> is a pure Perl module.

Continuous Database Migration
A package which allows a continuous development with an application that hold the appropriate database system synchronously.

=cut

use strict;
use warnings;
use DBI;
use File::Spec;
use DBIx::Schema::Changelog::Changeset;
use DBIx::Schema::Changelog::Action::Table;
use DBIx::Schema::Changelog::Action::View;
use DBIx::Schema::Changelog::Action::Index;
use DBIx::Schema::Changelog::Action::Constraint;

use Moose;
use MooseX::HasDefaults::RO;
use MooseX::Types::Moose qw(ArrayRef Str Defined);
use MooseX::Types::LoadableClass qw(LoadableClass);
use Method::Signatures::Simple;

use Hash::MD5 qw(sum_hash);

has db_changelog_table => ( isa => Str, default => 'databasechangelog' );
has db_driver          => ( isa => Str, default => 'SQLite' );
has file_type          => ( isa => Str, default => 'Yaml' );
has dbh => ( isa => 'DBI::db', required => 1, );

has table_action => (
    lazy    => 1,
    does    => 'DBIx::Schema::Changelog::Action',
    default => method {
        DBIx::Schema::Changelog::Action::Table->new(
            driver => $self->driver(),
            dbh    => $self->dbh(),
          )
    },
);

has changeset => (
    lazy    => 1,
    isa     => 'DBIx::Schema::Changelog::Changeset',
    default => method {
        DBIx::Schema::Changelog::Changeset->new(
            driver       => $self->driver(),
            dbh          => $self->dbh(),
            table_action => $self->table_action(),
          )
    },
);

has insert_dblog => (
    isa     => 'DBI::st',
    lazy    => 1,
    default => method {
        $self->dbh()
          ->prepare( "INSERT INTO "
              . $self->db_changelog_table()
              . "(id, author, filename, md5sum, changelog) VALUES (?,?,?,?,?)" )
    },
);

has loader_class => (
    isa     => LoadableClass,
    lazy    => 1,
    default => method {
        'DBIx::Schema::Changelog::File::' . $self->file_type()
    }
);

has loader => (
    does    => 'DBIx::Schema::Changelog::File',
    lazy    => 1,
    default => method { $self->loader_class()->new(); }
);

has driver_class => (
    isa     => LoadableClass,
    lazy    => 1,
    default => method {
        'DBIx::Schema::Changelog::Driver::' . $self->db_driver()
    }
);

has driver => (
    lazy    => 1,
    does    => 'DBIx::Schema::Changelog::Driver',
    default => method { $self->driver_class()->new(); }
);

sub _parse_log {
    my ( $self, $file ) = @_;
    foreach ( @{ $self->loader()->load($file) } ) {
        die "No id for changeset found" unless $_->{id};
        next if ( $self->_check_key( $_->{id}, sum_hash($_) ) );
        print STDOUT __PACKAGE__, " Handle changeset: $_->{id}\n";
        my $handle_time = time();
        $self->changeset()->handle( $_->{entries} )
          if ( defined $_->{entries} );
        $self->insert_dblog()
          ->execute( $_->{id}, $_->{author}, $file, sum_hash($_), $VERSION )
          or die $self->dbh()->errstr;
        print STDOUT __PACKAGE__,
          " Changeset: $_->{id} author: $_->{author}  executed.  "
          . ( time() - $handle_time ) . " \n";
    }
}

sub _check_key {
    my ( $self, $id, $value ) = @_;
    my @resp =
      $self->dbh()
      ->selectrow_array( "select md5sum, changelog from "
          . $self->db_changelog_table()
          . " where id = '$id'" )
      or return 0;
    die "MD5 hash changed for changeset: $id expect $value got $resp[0]"
      if ( $resp[0] ne $value );
    return ( @resp >= 1 );
}

=head1 SUBROUTINES/METHODS

=head2 BUILD

Run to check driver version with installed db driver.

Creates changelog table if it's not existing.

=cut

sub BUILD {
    my $self   = shift;
    my $vendor = uc $self->dbh()->get_info(17);
    print STDOUT __PACKAGE__, ". Db vendor $vendor. \n";

    $self->driver()->check_version( $self->dbh()->get_info(18) );

    $self->table_action()
      ->add( $self->driver()
          ->create_changelog_table( $self->dbh(), $self->db_changelog_table() )
      );
}

=head2 read

Read main changelog file and sub changelog files

=cut

sub read {
    my ( $self, $folder ) = @_;

    my $main =
      $self->loader()->load( File::Spec->catfile( $folder, 'changelog' ) );

    #first load templates
    $self->table_action()->load_templates( $main->{templates} );
    $self->table_action()
      ->prefix( ( defined $main->{prefix} && $main->{prefix} ne '' )
        ? $main->{prefix} . '_'
        : '' );
    $self->table_action()
      ->postfix( ( defined $main->{postfix} && $main->{postfix} ne '' )
        ? '_' . $main->{postfix}
        : '' );

    # now load changelogs
    $self->_parse_log( File::Spec->catfile( $folder, "changelog-$_" ) )
      foreach @{ $main->{changelogs} };
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 Synopsis

    use DBI;
    use DBIx::Schema::Changelog;

    my $dbh = DBI->connect( "dbi:SQLite:database=league.sqlite" );
    DBIx::Schema::Changelog->new( dbh => $dbh )->read( $FindBin::Bin . '/../changelog' );

    ...
    
    my $dbh = DBI->connect( "dbi:Pg:dbname=database;host=127.0.0.1", "user", "password" );
    DBIx::Schema::Changelog->new( dbh => $dbh, db_driver => 'Pg' )->read( $FindBin::Bin . '/../changelog' );

=head1 Motivation

 When working with several people on a large project that is bound to a database.
 If you there and back the databases have different levels of development.

 You can keep in sync with SQL statements, but these are then incompatible with other database systems.

=head1 Constructor and initialization

new(...) returns an object of type C<DBIx::Schema::Changelog>.

This is the class's contructor.

Usage: DBIx::Schema::Changelog -> new().

This method takes a set of parameters. Only the dbh parameter is mandatory.

For each parameter you wish to use, call new as new(param_1 => value_1, ...).

=over 4

=item dbh

This is a database handle, returned from DBI's connect() call.

This parameter is mandatory.

There is no default.

=item verbose

=back

=head1 Method: read()

=over 4

=item path to changelog folder


=back

=head1 SEE ALSO

=head2 L<DBIx::Admin::CreateTable>

=over 4

The package from which the idea originated.

=back

=head1 AUTHOR

Mario Zieschang, C<< <mario.zieschang at combase.de> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Mario Zieschang.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

