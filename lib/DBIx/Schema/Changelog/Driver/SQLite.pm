package DBIx::Schema::Changelog::Driver::SQLite;

=head1 NAME

DBIx::Schema::Changelog::Driver::SQLite - The great new DBIx::Schema::Changelog::Driver::SQLite!

=head1 VERSION

Version 0.1.0

=cut

our $VERSION = '0.1.0';

use 5.14.0;
use strict;
use warnings FATAL => 'all';
use Moose;
use MooseX::Types::PerlVersion qw( PerlVersion );

with 'DBIx::Schema::Changelog::Driver';

has commands => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    default => sub {
        return {
            create_table => 'CREATE TABLE {0} ( {1} )',
            drop_table   => 'DROP TABLE {0}',
            alter_table  => 'ALTER TABLE {0}',
            add_column   => 'ADD COLUMN {0}',
            create_view  => 'CREATE VIEW {0} AS {1}',
            drop_view    => 'DROP VIEW {0}',
        };
    }
);

has defaults => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    default => sub {
        return {
            current    => 'CURRENT_TIMESTAMP',
            not_null   => 'NOT NULL',
            primarykey => 'primary key',
        };
    }
);

has types => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    default => sub {
        return {
            blob      => 'BLOB',
            integer   => 'INTEGER',
            numeric   => 'NUMERIC',
            real      => 'REAL',
            text      => 'TEXT',
            bool      => 'BOOL',
            double    => 'DOUBLE',
            float     => 'FLOAT',
            char      => 'CHAR',
            varchar   => 'VARCHAR',
            timestamp => 'DATETIME',
        };
    }
);

sub _min_version { '3.7' }

=head1 SUBROUTINES/METHODS

=head2 create_changelog_table

=cut

sub create_changelog_table {
    my ( $self, $dbh, $name ) = @_;
    my $sth = $dbh->prepare("SELECT * FROM sqlite_master WHERE type='table';");
    if ( $sth->execute() or die "Some error $!" ) {
        foreach ( $sth->fetchrow_array() ) { return undef if ( $_ =~ /^$name$/ ); }
    }
    return {
        name    => $name,
        columns => $self->changelog_table()
    };
}

=head2 generate_unique

=cut

sub generate_unique {
    my ( $self, $table, $column ) = @_;
    return "CREATE UNIQUE INDEX unique_" . $table . "_" . $column . " on $table ($column)";
}

=head2 generate_foreign_key

=cut

sub generate_foreign_key {
    my ( $self, $basecol, $foreignkeyvalues ) = @_;
    return
"FOREIGN KEY ($basecol) REFERENCES $foreignkeyvalues->{reftable}($foreignkeyvalues->{refcolumn})";
}

=head2 create_index

=cut

sub add_column {
    my ( $self, $name, $column ) = @_;
    return 'ALTER TABLE ' . $name . ' ADD COLUMN ' . $column . ';';
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;    # End of DBIx::Schema::Changelog::Driver::SQLite

=head1 BUGS

Please report any bugs or feature requests to C<bug-dbix-schema-changelog-driver-sqlite at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DBIx-Schema-Changelog-Driver-SQLite>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DBIx::Schema::Changelog::Driver::SQLite


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DBIx-Schema-Changelog-Driver-SQLite>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DBIx-Schema-Changelog-Driver-SQLite>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DBIx-Schema-Changelog-Driver-SQLite>

=item * Search CPAN

L<http://search.cpan.org/dist/DBIx-Schema-Changelog-Driver-SQLite/>

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
