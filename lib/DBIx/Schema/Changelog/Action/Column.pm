package DBIx::Schema::Changelog::Action::Column;

=head1 NAME

DBIx::Schema::Changelog::Action::Column - Action handler for table columns

=head1 VERSION

Version 0.7.2

=cut

our $VERSION = '0.7.2';

use strict;
use warnings;
use Text::Trim;
use Moose;
use Method::Signatures::Simple;
use DBIx::Schema::Changelog::Action::Constraint;
use Data::Dumper;

with 'DBIx::Schema::Changelog::Action';

=head1 SUBROUTINES/METHODS

=over 4

=item add

    Prepare column string for create table.
    Or add new column into table

=cut

sub add {
    my ( $self, $col, $constraint ) = @_;
    my $actions = $self->driver()->actions;
    my $type    = $self->driver()->type($col);
    return qq~$col->{name} $type $constraint~ if ( $col->{create_table} );
    die "Add column is not supported!" unless ( $actions->{add_column} );

      my $ret = _replace_spare( $actions->{add_column},
        [qq~$col->{name} $type $constraint~] );
    return $ret;

}

=item alter

    Not yet implemented

=cut

sub alter {
    my ( $self, $params ) = @_;
    print STDERR __PACKAGE__, " (", __LINE__,
      ") Alter column is not supported!", $/;
    return undef;
}

=item drop

    If it's supported, it will drop defined column from table.

=cut

sub drop {
    my ( $self, $params ) = @_;
    my $actions = $self->driver()->actions;
    unless ( $actions->{drop_column} ) {
        print STDERR __PACKAGE__, " (", __LINE__,
          ") Drop column is not supported!", $/;
        return;
    }
    foreach ( @{ $params->{dropcolumn} } ) {
        my $s = _replace_spare( $actions->{alter_table}, [ $params->{name} ] );
        $s .= ' ' . _replace_spare( $actions->{drop_column}, [ $_->{name} ] );
        $self->_do($s);
    }

}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

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

=cut
