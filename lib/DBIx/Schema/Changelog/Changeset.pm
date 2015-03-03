package DBIx::Schema::Changelog::Changeset;

=head1 NAME

DBIx::Schema::Changelog::Changeset - Handles action types.

=head1 VERSION

Version 0.4.0

=cut

our $VERSION = '0.4.0';

use strict;
use warnings;
use Moose;
use Method::Signatures::Simple;
use MooseX::HasDefaults::RO;
use DBIx::Schema::Changelog::Action::Sql;

has driver       => ();
has dbh          => ();
has table_action => ( isa => 'DBIx::Schema::Changelog::Action::Table', );

has sql_action => (
    lazy    => 1,
    does    => 'DBIx::Schema::Changelog::Action',
    default => method {
        DBIx::Schema::Changelog::Action::Sql->new(
            driver => $self->driver(),
            dbh    => $self->dbh()
          )
    },
);

has index_action => (
    lazy    => 1,
    does    => 'DBIx::Schema::Changelog::Action',
    default => method {
        DBIx::Schema::Changelog::Action::Index->new(
            driver => $self->driver(),
            dbh    => $self->dbh()
          )
    },
);

has view_action => (
    lazy    => 1,
    does    => 'DBIx::Schema::Changelog::Action',
    default => method {
        DBIx::Schema::Changelog::Action::View->new(
            driver => $self->driver(),
            dbh    => $self->dbh()
          )
    },
);

=head1 SUBROUTINES/METHODS

=over 4

=item handle

    Handles different changeset commands

=cut

sub handle {
    my ( $self, $entries ) = @_;
    foreach (@$entries) {

        # table actions
        $self->table_action()->add($_)   if ( $_->{type} eq 'createtable' );
        $self->table_action()->drop($_)  if ( $_->{type} eq 'droptable' );
        $self->table_action()->alter($_) if ( $_->{type} eq 'altertable' );

        # index actions
        $self->index_action()->add($_)   if ( $_->{type} eq 'createindex' );
        $self->index_action()->alter($_) if ( $_->{type} eq 'alterindex' );
        $self->index_action()->drop($_)  if ( $_->{type} eq 'dropindex' );

        # view actions
        $self->view_action()->add($_)   if ( $_->{type} eq 'createview' );
        $self->view_action()->alter($_) if ( $_->{type} eq 'alterview' );
        $self->view_action()->drop($_)  if ( $_->{type} eq 'dropview' );

        # manualy called sql statement
        $self->sql_action()->add($_) if ( $_->{type} eq 'sql' );
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;    # End of DBIx::Schema::Changelog::Changeset

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
