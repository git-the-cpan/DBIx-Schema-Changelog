package DBIx::Schema::Changelog::Command;

=head1 NAME

DBIx::Schema::Changelog::Command - Command Line module for DBIx::Schema::Changelog

=head1 VERSION

Version 0.6.0

=cut

our $VERSION = '0.6.0';

use strict;
use warnings;
use Data::Dumper;
use DBI;
use Pod::Usage;
use Getopt::Long;
use DBIx::Schema::Changelog;
use DBIx::Schema::Changelog::Command::Driver;
use DBIx::Schema::Changelog::Command::File;
use DBIx::Schema::Changelog::Command::Changeset;

# -----------------------------------------------
# Preloaded methods go here.
# -----------------------------------------------
# Encapsulated class data.
{

    sub _process_command_line {
        my ( $self, %config ) = @_;
        $config{'argv'} = [@ARGV];
        GetOptions(

            # without params
            'md|makedriver' => \$config{makedriver},
            'mf|makefile'   => \$config{makefile},
            'h|help|?'      => \$config{help},
            'c|changeset'   => \$config{changeset},
            'v|version'     => \$config{version},

            # with params
            's|start=s'       => \$config{start},
            'drv|driver=s'    => \$config{driver},
            't|type=s'        => \$config{type},
            'db|database=s'   => \$config{db},
            'dir|directory=s' => \$config{dir},
            'u|user=s'        => \$config{user},
            'p|pass=s'        => \$config{pass},
            'a|author=s'      => \$config{author},
            'e|email|@=s'     => \$config{email},
        );
        return %config;
    }

    sub _start {
        my ( $self, $config ) = @_;
        $config->{driver} =
          ( defined $config->{driver} ) ? $config->{driver} : 'SQLite';
        $config->{dir} = $config->{start};
        my $dbi = "dbi:$config->{driver}:database=$config->{db}";
        my $dbh =
          ( defined $config->{user} )
          ? DBI->connect( $dbi, $config->{user}, $config->{pass} )
          : DBI->connect($dbi);
        my $insert = {
            dbh       => $dbh,
            db_driver => $config->{driver}
        };
        $insert->{file_type} = $config->{type} if ( defined $config->{type} );
        my $creator =
          DBIx::Schema::Changelog->new($insert)->read( $config->{dir} );
        $dbh->disconnect();
    }
}    ############# End of encapsulated class data.      ########################

=head2 run

    Is called from the changelog-run in bin directory

=cut

sub run {
    my $self   = shift;
    my %config = ();
    %config = $self->_process_command_line(%config);
    if ( $config{makedriver} ) {
        DBIx::Schema::Changelog::Command::Driver->new()->make( \%config );
    }
    elsif ( $config{makefile} ) {
        DBIx::Schema::Changelog::Command::File->new()->make( \%config );
    }
    elsif ( $config{changeset} ) {

        my $insert = { dir => $config{dir} || '.' };
        $insert->{file_type} = $config{type} if ( defined $config{type} );
        DBIx::Schema::Changelog::Command::Changeset->new($insert)->make();
    }
    elsif ( defined $config{start} ) { $self->_start( \%config ); }
    elsif ( $config{version} ) { print __PACKAGE__,' Verion: ', $VERSION, $/; }
    elsif ( $config{help} ) { pod2usage( { -verbose => 1 } ); }
    else                    { pod2usage( { -verbose => 1 } ); }
}

no Moose;

1;

__END__

=head1 SYNOPSIS

=over 4

    changelog-run  [commands] [options]
    ...
    # start reading
    changelog-run -db=db.sqlite -s=/path/to/changelog
    ...
    # make new driver module
    changelog-run -md --author='Mario Zieschang' -email='mziescha@cpan.org' -driver=MySQL -dir=/path/to/directory
    ...
    # make new file read module
    changelog-run -mf -a='Mario Zieschang' -@='mziescha@cpan.org' -t=XML -dir=/path/to/directory
    ...
    # create a new changeset project
    changelog-run -c -dir=/path/to/directory

=back

=head1 OPTIONS

=over 4

    Commands:
    -md --makedriver  : Will create a module for a new driver
    -mf --makefile    : Will create a module for a new file parser
    -c, --changeset   : Will create a new changeset project
    -v, --version     : Print the current version of this module
    -h, --help, -?    : print what you are currently reading
    (If no command is set print what you are currently reading.)

    Options:
    -s, --start       : parameter ist changeset directory to read
    -a, --author      : Author of new file or driver
    -dir, --directory : Directory of new file or driver
    -drv, --driver    : Driver to use by running changelog (default SQLite)
    -t, --type        : File type for reading changesets (default Yaml)
    -db, --database   : Database to use by running changelog (default SQLite)
    -u, --user        : User to connect with remote db
    -p, --pass        : Pass for user to connect with remote db
    -e, --email, -@   : Email of author of new file or driver

=back

=head1 SEE ALSO

=over 4

=item L<module::Starter>   The package from which the idea originated.

=back

=head1 AUTHOR

=over 4

Mario Zieschang, C<< <mario.zieschang at combase.de> >>

=back

=head1 LICENSE AND COPYRIGHT

=over 1

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
mark, trade name, or logo of the Copyright Holder.

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
THE IMPLIED WARRANTIES OF MERCHANT ABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=back

=cut
