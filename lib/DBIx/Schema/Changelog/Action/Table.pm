package DBIx::Schema::Changelog::Action::Table;

=head1 NAME

DBIx::Schema::Changelog::Action::TableAction handler for tables

=head1 VERSION

Version 0.1.0

=cut

our $VERSION = '0.1.0';

use strict;
use warnings;
use Data::Dumper;
use Moose;
use MooseX::Types::Moose qw(HashRef);
use DBIx::Schema::Changelog::Action::Column;
use DBIx::Schema::Changelog::Action::Constraint;
use Method::Signatures::Simple;

with 'DBIx::Schema::Changelog::Action';

has templates => (
    is  => 'rw',
    isa => 'HashRef',
);

has constraint_action => (
    is      => 'ro',
    lazy    => 1,
    does    => 'DBIx::Schema::Changelog::Action',
    default => method {
        DBIx::Schema::Changelog::Action::Constraint->new(
            driver => $self->driver(),
            dbh    => $self->dbh()
          )
    },
);

has column_action => (
    is      => 'ro',
    lazy    => 1,
    does    => 'DBIx::Schema::Changelog::Action',
    default => method {
        DBIx::Schema::Changelog::Action::Column->new(
            driver => $self->driver(),
            dbh    => $self->dbh(),
          ),
    },
);

=head1 SUBROUTINES/METHODS

=head2 add

=cut

sub add {
    my ( $self, $params ) = @_;
    return unless $params->{name};
    my $commands = $self->driver()->commands;
    my $defaults = $self->driver()->defaults;
    my $types    = $self->driver()->types;

    my @columns     = ();
    my $constraints = [];
    foreach my $col ( @{ $params->{columns} } ) {
        unless ( $col->{tpl} ) {
            $col->{create_table} = 1;
            push( @columns, $self->column_action()->add( $params->{name}, $col, $constraints ) );
            $self->constraint_action()->add( $params->{name}, $col, $constraints );
            next;
        }
        foreach ( @{ $self->templates()->{ $col->{tpl} } } ) {
            $_->{create_table} = 1;
            push( @columns, $self->column_action()->add( $params->{name}, $_, $constraints ) );
            $self->constraint_action()->add( $params->{name}, $_, $constraints );
        }
    }
    push( @columns, @$constraints );
    my $sql = _replace_spare( $commands->{create_table}, [ $params->{name}, join( ",\n\t", @columns ) ] );
    $self->_do($sql);

}

=head2 alter

=cut

sub alter {
    my ( $self, $params ) = @_;
    return unless $params->{name};
    if ( defined $params->{addcolumn} ) {
        $self->driver()->add_column( $params->{name}, $self->column_action()->add( $params->{name}, $_ ) )
          foreach @{ $params->{addcolumn} };
    }
    elsif ( defined $params->{altercolumn} )   { $self->column_action()->alter($params); }
    elsif ( defined $params->{dropcolumn} )    { $self->column_action()->drop($params); }
    elsif ( defined $params->{addconstraint} ) { $self->constraint_action()->add($params); }
    else {
        die __PACKAGE__ . " Key to alter table not found or implemented.\n Probaply it is misspelled.";
    }
}

=head2 drop

=cut

sub drop {
    my ( $self, $params ) = @_;
    my $defaults = $self->driver()->defaults();
    print Dumper($params);
    my $sql = _replace_spare( $defaults->{drop_table}, [ $params->{name} ] );
    $self->_do($sql);
}

=head2 load_templates - load pre defined column templates

=cut

sub load_templates {
    my ( $self, $templates ) = @_;
    foreach my $key ( sort { $a cmp $b } keys %$templates ) {
        my $tmpTemplate = [];
        push( @$tmpTemplate, ( ( defined $_->{tpl} ) ? @{ $templates->{ $_->{tpl} } } : $_ ) ) foreach ( @{ $templates->{$key} } );
        $templates->{$key} = $tmpTemplate;
    }
    $self->templates($templates);
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