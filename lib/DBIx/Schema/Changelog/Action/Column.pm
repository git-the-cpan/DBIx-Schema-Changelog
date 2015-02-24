package DBIx::Schema::Changelog::Action::Column;

=head1 NAME

DBIx::Schema::Changelog::Action::Column - Action handler for table columns

=head1 VERSION

Version 0.1.0

=cut

our $VERSION = '0.1.0';

use strict;
use warnings;
use Data::Dumper;
use Text::Trim;
use Moose;
use Method::Signatures::Simple;
use DBIx::Schema::Changelog::Action::Default;

with 'DBIx::Schema::Changelog::Action';

has default => (
    is      => 'rw',
    lazy    => 1,
    does    => 'DBIx::Schema::Changelog::Action',
    default => method {
        DBIx::Schema::Changelog::Action::Default->new(
            commands => $self->driver()->commands,
            defaults => $self->driver()->defaults,
            driver   => $self->driver(),
            dbh      => $self->dbh()
          )
    },
);

has errors => (
    is      => 'ro',
    isa     => 'DBIx::Schema::Changelog::Core::EceptionMessages',
    lazy    => 1,
    default => sub { DBIx::Schema::Changelog::Core::EceptionMessages->new() }
);

=head1 SUBROUTINES/METHODS

=head2 add

=cut

sub add {
    my ( $self, $table, $col ) = @_;

    my $type     = $self->driver()->type($col);
    my $defaults = $self->driver()->defaults;
    my $commands = $self->driver()->commands;
    #
    die $self->errors()->message( 'no_default_value', [ $col->{name}, $table ] )
      if ( ( $col->{notnull} || defined $col->{primarykey} )
        && ( !defined $col->{default} && !defined $col->{foreign} ) );

    my $not_null   = ( $col->{notnull} )            ? $defaults->{not_null}   : '';
    my $primarykey = ( defined $col->{primarykey} ) ? $defaults->{primarykey} : '';
    $col->{table} = $table;
    my $default = $self->default()->add($col);
    return qq~$col->{name} $type $not_null $primarykey $default~ if ( $col->{create_table} );

    my $sql = _replace_spare( $commands->{alter_table}, [$table] )
      . _replace_spare( $commands->{add_column}, [qq~$col->{name} $type $not_null $primarykey $default~] );
    return $self->_do($sql);
}

=head2 alter

=cut

sub alter {

}

=head2 drop

=cut

sub drop {
    my ( $self, $table, $params ) = @_;
    my $defaults = $self->driver()->defaults();
    foreach ( @{ $params->{dropcolumn} } ) {
        my $sql = _replace_spare( $defaults->{alter_table}, [$table] );
        $sql .= ' ' . _replace_spare( $defaults->{drop_column}, [ $_->{name} ] );
        $self->_do($sql);
    }

}

=head2 run_constraints

=cut

sub run_constraints {
    my ( $self, $table, $constraints ) = @_;
    $self->_do( $self->driver()->add_constraint( $table, $_ ) ) foreach (@$constraints);

}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

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
