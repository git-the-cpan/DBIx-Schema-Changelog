package DBIx::Schema::Changelog::Action::Sequence;

=head1 NAME

DBIx::Schema::Changelog::Action::Sequence - Action handler for sequences

=cut

use strict;
use warnings;
use Data::Dumper;
use Moose;

with 'DBIx::Schema::Changelog::Action';

=head1 SUBROUTINES/METHODS

=head2 add

=cut

sub add {
    my ( $self, $params ) = @_;
    return $self->driver()->defaults()->{ $params->{default} } || ''
      if ( !defined $self->driver()->defaults()->{ $params->{default} }
        || $self->driver()->defaults()->{ $params->{default} } ne 'sequence' );

    $params->{table} =~ s/"//g;
    $params->{name} =~ s/"//g;
    my $seq = 'seq_' . $params->{table} . '_' . $params->{name};
    my $sql = _replace_spare( $self->driver()->commands()->{create_sequence},
        [ $seq, 1, 1, 9223372036854775807, 1, 1 ] );
    $self->dbh()->do($sql) or die "Can't create sequence: $sql $!";
    return "DEFAULT nextval('$seq'::regclass)";
}

=head2 alter

=cut

sub alter {
    my ( $self, $params ) = @_;

}

=head2 drop

=cut

sub drop {
    my ( $self, $params ) = @_;

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
