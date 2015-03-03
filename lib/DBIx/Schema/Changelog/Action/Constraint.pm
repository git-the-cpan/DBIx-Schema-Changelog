package DBIx::Schema::Changelog::Action::Constraint;

=head1 NAME

DBIx::Schema::Changelog::Action::Constraint - Action handler for constraint

=head1 VERSION

Version 0.3.2

=cut

our $VERSION = '0.3.2';

use strict;
use warnings;
use Data::Dumper;
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
            driver => $self->driver(),
            dbh    => $self->dbh()
          )
    },
);

=head1 SUBROUTINES/METHODS

=head2 add

=cut

sub add {
    my ( $self, $col, $constr_ref ) = @_;
    my $defaults = $self->driver()->defaults;
    my $consts   = $self->driver()->constraints;
    my $actions  = $self->driver()->actions;

    print __PACKAGE__, __LINE__, Dumper($col);
    die $self->errors()
      ->message( 'no_default_value', [ $col->{name}, $col->{table} ] )
      if ( ( $col->{notnull} || defined $col->{primarykey} )
        && ( !defined $col->{default} && !defined $col->{foreign} ) );

    if ( defined $col->{unique} ) {
        die "Add column is not supported!", $/ unless $actions->{unique};
        my $unique_name = "unique_" . $col->{table} . "_" . $col->{name};
        push(
            @$constr_ref,
            _replace_spare(
                $actions->{unique},
                [
                    "unique_" . $col->{table} . "_" . $col->{name}, $col->{name}
                ]
            )
        );
    }
    if ( defined $col->{foreign} ) {
        die "Foreign key is not supported!", $/ unless $actions->{foreign_key};
        push(
            @$constr_ref,
            _replace_spare(
                $actions->{foreign_key},
                [
                    $col->{name},
                    $col->{foreign}->{reftable},
                    $col->{foreign}->{refcolumn},
                    'fkey_'
                      . $col->{table} . '_'
                      . $col->{foreign}->{refcolumn} . '_'
                      . $col->{name},
                ]
            )
        );
    }

    my $not_null = ( $col->{notnull} ) ? $consts->{not_null} : '';
    my $primarykey =
      ( defined $col->{primarykey} ) ? $consts->{primary_key} : '';
    my $default = $self->default()->add($col);
    return qq~$not_null $primarykey $default~;
}

=head2 alter

=cut

sub alter {
    my ( $self, $table_name, $col, $constr_ref ) = @_;

   #$self->table_action()->add($_)   if (uc $constraint->{type} eq 'NOT_NULL' );
   #$self->table_action()->drop($_)  if (uc $constraint_->{type} eq 'UNIQUE' );
   #$self->table_action()->alter($_) if (uc $constraint_->{type} eq 'PRIMARY' );
   #$self->index_action()->add($_)   if (uc $constraint_->{type} eq 'FOREIGN' );
   #$self->index_action()->alter($_) if (uc $constraint_->{type} eq 'CHECK' );
   #$self->index_action()->drop($_)  if (uc $constraint_->{type} eq 'DEFAULT' );
}

=head2 drop

=cut

sub drop {
    my ( $self, $table_name, $col, $constraints ) = @_;

   #$self->table_action()->add($_)   if (uc $constraint->{type} eq 'NOT_NULL' );
   #$self->table_action()->drop($_)  if (uc $constraint_->{type} eq 'UNIQUE' );
   #$self->table_action()->alter($_) if (uc $constraint_->{type} eq 'PRIMARY' );
   #$self->index_action()->add($_)   if (uc $constraint_->{type} eq 'FOREIGN' );
   #$self->index_action()->alter($_) if (uc $constraint_->{type} eq 'CHECK' );
   #$self->index_action()->drop($_)  if (uc $constraint_->{type} eq 'DEFAULT' );
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
