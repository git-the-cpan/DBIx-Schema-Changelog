package DBIx::Schema::Changelog::Action::Constraint;

=head1 NAME

DBIx::Schema::Changelog::Action::Constraint - Action handler for constraint

=head1 VERSION

Version 0.6.1

=cut

our $VERSION = '0.6.1';

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
    my $consts = $self->driver()->constraints;
    if ( defined $col->{primarykey} && ref $col->{primarykey} eq 'ARRAY' ) {
        push( @$constr_ref, $self->_primary($col) );
        return;
    }
    if ( defined $col->{unique} ) {
        push( @$constr_ref, $self->_unique($col) );
        return;
    }

    my $must_nn = ( defined $col->{primarykey} ) ? 1 : 0;
    my $isnt_nn =
      ( !defined $col->{default} && !defined $col->{foreign} ) ? 1 : 0;

    die "No default value set for $col->{name}" if ( $must_nn && $isnt_nn );
    push( @$constr_ref, $self->_foreign($col) ) if ( defined $col->{foreign} );

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

=head1 AUXILIARY SUBROUTINES/METHODS

=head2 _foreign

Private sub to handle foreign keys constraints

=cut

sub _foreign {
    my ( $self, $col, $constr_ref ) = @_;
    my $actions = $self->driver()->actions;
    die "Foreign key is not supported!", $/ unless $actions->{foreign_key};
    my $table     = '' . $col->{table};
    my $ref_table = $col->{foreign}->{reftable};
    my $name      = $col->{name};
    my $refcolumn = $col->{foreign}->{refcolumn};

    $table =~ s/"//g;
    $ref_table =~ s/"//g;
    $name =~ s/"//g;

    return _replace_spare(
        $actions->{foreign_key},
        [
            $col->{name}, $ref_table,
            $col->{foreign}->{refcolumn},
            "fkey_$table" . "_$refcolumn" . "_$name"
        ]
    );
}

=head2 _unique

Private sub to handle unique constraints

=cut

sub _unique {
    my ( $self, $col, $constr_ref ) = @_;
    my $actions = $self->driver()->actions;
    return unless $actions->{unique};
    my $table = '' . $col->{table};
    $table =~ s/"//g;
    my $name = ( defined $col->{name} ) ? $col->{name} : time();
    return _replace_spare( $actions->{unique},
        [ qq~unique_$name~, join( ',', @{ $col->{unique} } ) ] );
}

=head2 _primary

Private sub to to handle primary key with more than one column

=cut

sub _primary {
    my ( $self, $col, $constr_ref ) = @_;
    my $actions = $self->driver()->actions;
    my $name = ( defined $col->{name} ) ? $col->{name} : time() . '_gen';
    return _replace_spare( $actions->{primary},
        [ qq~pkay_multi_$name~, join( ',', @{ $col->{primarykey} } ) ] );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

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
