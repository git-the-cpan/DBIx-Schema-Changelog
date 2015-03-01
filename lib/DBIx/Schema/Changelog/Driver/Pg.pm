package DBIx::Schema::Changelog::Driver::Pg;

=head1 NAME

DBIx::Schema::Changelog::Driver::SQLite - The great new DBIx::Schema::Changelog::Driver::SQLite!

=head1 VERSION

Version 0.3.0

=cut

our $VERSION = '0.3.0';

use strict;
use warnings;
use Moose;
use MooseX::Types::PerlVersion qw( PerlVersion );

with 'DBIx::Schema::Changelog::Driver';

has actions => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    default => sub {
        return {
            create_table => q~CREATE TABLE {0} ( {1} ) WITH ( OIDS=FALSE )~,
            drop_table   => q~DROP TABLE {0}~,
            alter_table  => q~ALTER TABLE {0}~,
            drop_column  => q~DROP COLUMN {0}~,
            add_column   => q~ADD COLUMN {0}~,
            create_view  => 'CREATE VIEW {0} AS {1}',
            drop_view    => 'DROP VIEW {0}',
            create_index => 'CREATE INDEX idx_{0} ON {1} USING {2} ({3})',
            create_sequence =>
q~CREATE SEQUENCE {0} INCREMENT {1} MINVALUE {2} MAXVALUE {3} START {4} CACHE {5}~,
            nextval_sequence => q~nextval('{0}'::regclass)~,
            unique           => q~CONSTRAINT {0} UNIQUE ({1})~,
            foreign_key  => q~CONSTRAINT {3} FOREIGN KEY ({0}) REFERENCES {1} ({2}) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION~,
        };
    }
);

has constraints => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    default => sub {
        return {
            not_null    => 'NOT NULL',
            unique      => 'UNIQUE',
            primary_key => 'PRIMARY KEY',
            foreign_key => 'FOREIGN KEY',
            check       => 'CHECK',
            default     => 'DEFAULT',
        };
    }
);

has defaults => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    default => sub {
        return {
            current     => 'now()',
            inc         => 'sequence',
            not_null    => 'NOT NULL',
            primarykey  => 'primary key',
            boolean_str => 1,
            uuid =>
'(md5(((((current_database())::text || ("current_user"())::text) || now()) || random())))::uuid',
        };
    }
);

has types => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    default => sub {
        return {
            abstime          => 'abstime',
            aclitem          => 'aclitem',
            bigint           => 'bigint',
            bigserial        => 'bigserial',
            bit              => 'bit',
            var_bit          => 'bit varying',
            bool             => 'boolean',
            box              => 'box',
            bytea            => 'bytea',
            char             => '"char"',
            character        => 'character',
            varchar          => 'character varying',
            cid              => 'cid',
            cidr             => 'cidr',
            circle           => 'circle',
            date             => 'date',
            daterange        => 'daterange',
            double_precision => 'double precision',
            gtsvector        => 'gtsvector',
            inet             => 'inet',
            int2vector       => 'int2vector',
            int4range        => 'int4range',
            int8range        => 'int8range',
            integer          => 'integer',
            interval         => 'interval',
            json             => 'json',
            line             => 'line',
            lseg             => 'lseg',
            macaddr          => 'macaddr',
            money            => 'money',
            name             => 'name',
            numeric          => 'numeric',
            numrange         => 'numrange',
            oid              => 'oid',
            oidvector        => 'oidvector',
            path             => 'path',
            pg_node_tree     => 'pg_node_tree',
            point            => 'point',
            polygon          => 'polygon',
            real             => 'real',
            refcursor        => 'refcursor',
            regclass         => 'regclass',
            regconfig        => 'regconfig',
            regdictionary    => 'regdictionary',
            regoper          => 'regoper',
            regoperator      => 'regoperator',
            regproc          => 'regproc',
            regprocedure     => 'regprocedure',
            regtype          => 'regtype',
            reltime          => 'reltime',
            serial           => 'serial',
            smallint         => 'smallint',
            smallserial      => 'smallserial',
            smgr             => 'smgr',
            text             => 'text',
            tid              => 'tid',
            timestamp        => 'timestamp without time zone',
            timestamp_tz     => 'timestamp with time zone',
            time             => 'time without time zone',
            time_tz          => 'time with time zone',
            tinterval        => 'tinterval',
            tsquery          => 'tsquery',
            tsrange          => 'tsrange',
            tstzrange        => 'tstzrange',
            tsvector         => 'tsvector',
            txid_snapshot    => 'txid_snapshot',
            uuid             => 'uuid',
            xid              => 'xid',
            xml              => 'xml',
        };
    }
);

sub _min_version { '9.1' }

=head1 SUBROUTINES/METHODS

=head2 create_changelog_table

=cut

sub create_changelog_table {
    my ( $self, $dbh, $name ) = @_;
    my $sth = $dbh->prepare(
"SELECT table_name FROM information_schema.tables WHERE table_schema='public'"
    );
    if ( $sth->execute() or die "Some error $!" ) {
        foreach ( $sth->fetchrow_array() ) {
            return undef if ( $_ =~ /^$name$/ );
        }
    }
    return {
        name    => $name,
        columns => $self->changelog_table()
    };
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
