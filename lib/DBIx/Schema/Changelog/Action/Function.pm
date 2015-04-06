package DBIx::Schema::Changelog::Action::Function;

=head1 NAME

DBIx::Schema::Changelog::Action::Function - Action for functions

=head1 VERSION

Version 0.7.2

=cut

our $VERSION = '0.7.2';

use strict;
use warnings;
use Moose;
use Data::Dumper;

with 'DBIx::Schema::Changelog::Action';

=head1 SUBROUTINES/METHODS

=over 4

=item add

    Execute sql statements can lead very likely to incompatibilities.

=cut

sub add {
    my ( $self, $params, $return_sql ) = @_;
    my $functions = $self->driver()->functions;
    die "Used driver does not support functions!" unless $functions;
    die "No function name defined!" unless $params->{name};
    my $insert_params =
      ( defined $params->{params} && ref $params->{params} eq 'ARRAY' )
      ? join( ',', @{ $params->{params} } )
      : '';
    my $cost = ( defined $params->{cost} ) ? $params->{cost} . '' : '100';
    my $lang = ( defined $params->{lang} ) ? $params->{lang}      : 'sql';
    my $sql  = _replace_spare(
        $functions->{add},
        [
            $params->{name}, $insert_params, $params->{return},
            $params->{as},   $lang,          $cost
        ]
    );
    return ($return_sql) ? $sql : $self->_do($sql);
}

=item alter

    Not needed!

=cut

sub alter {
    my ( $self, $params, $return_sql ) = @_;
    my $drop = $self->drop( $params, $return_sql );
    my $add = $self->add( $params, $return_sql );
    return { drop => $drop, add => $add };
}

=item drop

    Not needed!

=cut

sub drop {
    my ( $self, $params, $return_sql ) = @_;
    my $functions = $self->driver()->functions;
    die "Used driver does not support functions!" unless $functions;
    my $insert_params =
      ( defined $params->{params} && ref $params->{params} eq 'ARRAY' )
      ? join( ',', @{ $params->{params} } )
      : '';
    my $sql =
      _replace_spare( $functions->{drop}, [ $params->{name}, $insert_params ],
        1 );
    return ($return_sql) ? $sql : $self->_do($sql);
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
