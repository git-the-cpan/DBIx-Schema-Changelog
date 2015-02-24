package DBIx::Schema::Changelog::Command::Changeset;

=head1 NAME

DBIx::Schema::Changelog::Command::Changeset - Create a new changeset project from template for DBIx::Schema::Changelog!

=cut

use 5.14.0;
use strict;
use warnings FATAL => 'all';
use Time::Piece;
use Data::Dumper;
use Moose;
use File::Path qw( mkpath );
use MooseX::Types::Moose qw(Str);
use MooseX::Types::LoadableClass qw(LoadableClass);
use Method::Signatures::Simple;

with 'DBIx::Schema::Changelog::Command::Base';

has dir => (
    isa      => Str,
    is       => 'ro',
    required => 1,
);

has type => (
    isa     => Str,
    is      => 'rw',
    default => 'Yaml'
);

has loader_class => (
    is      => 'ro',
    isa     => LoadableClass,
    lazy    => 1,
    default => method {
        'DBIx::Schema::Changelog::File::' . $self->type()
    }
);

has loader => (
    is      => 'ro',
    does    => 'DBIx::Schema::Changelog::File',
    lazy    => 1,
    default => method { $self->loader_class()->new(); }
);

=head1 SUBROUTINES/METHODS

=head2 make

=cut

sub make {
    my ( $self, $config ) = @_;
    mkpath( File::Spec->catfile( $self->dir(), 'changelog' ), 0755 );
    write_file(
        File::Spec->catfile( $self->dir(), 'changelog', 'changelog' ) . $self->loader()->ending(),
        replace_spare( $self->loader()->tpl_main(), [] ) );
    write_file(
        File::Spec->catfile( $self->dir(), 'changelog', 'changelog-01' )
          . $self->loader()->ending(),
        replace_spare( $self->loader()->tpl_sub(), [] )
    );
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
