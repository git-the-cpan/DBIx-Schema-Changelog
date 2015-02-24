package DBIx::Schema::Changelog::File::JSON;

=head1 NAME

DBIx::Schema::Changelog::File::JSON - Module for DBIx::Schema::Changelog::File to load changeset from JSON files.

=head1 VERSION

Version 0.1.0

=cut

our $VERSION = '0.1.0';

use 5.14.0;
use strict;
use warnings FATAL => 'all';
use Moose;
use JSON::Parse qw( json_file_to_perl );

with 'DBIx::Schema::Changelog::File';

has tpl_main => (
	isa => 'Str',
	is => 'ro',
	default => q~{
  "templates": {
    "tpl_std": [
      { "name": "id", "type": "integer", "notnull": 1, "primarykey": 1, "default": "inc" },
      { "name": "name", "type": "varchar", "notnull": 1, "default": "current" },
      { "name": "active", "type": "bool", "default": 1 },
      { "name": "flag", "type": "timestamp", "default": "current", "notnull": 1 }
    ]
  },
  "changelogs": [ "01" ]
}~,
);

has tpl_sub => (
	isa => 'Str',
	is => 'ro',
	default => q~[
  {
    "id": "001.01-maz",
    "author": "Mario Zieschang",
    "entries": [ { "type": "createtable", "name": "client", "columns": [ { "tpl": "tpl_std" } ] } ]
  }
]~,
);

has ending => (
	is => 'ro',
	isa => 'Str',
	default => '.json',
);

sub load{
	my ( $self, $file ) = @_;

	$file = $file.$self->ending();

	open my $rfh, '<', $file or die "can't open config file: $file $!";
	print STDERR __PACKAGE__, ". Read changlog file '$file'. \n";
	
	return json_file_to_perl ($file);
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;    # End of DBIx::Schema::Changelog::File::JSON

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