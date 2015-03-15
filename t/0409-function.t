use strict;
use warnings;

use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );

use Test::Requires qw(DBI DBD::Pg Test::PostgreSQL);
use DBI;
use Test::PostgreSQL;
use Test::More;
use Test::Exception;

plan tests => 9;

require_ok('DBIx::Schema::Changelog::Driver::Pg');
use_ok 'DBIx::Schema::Changelog::Driver::Pg';

require_ok('DBIx::Schema::Changelog::Action::Function');
use_ok 'DBIx::Schema::Changelog::Action::Function';

my $driver = DBIx::Schema::Changelog::Driver::Pg->new();
my $obj = DBIx::Schema::Changelog::Action::Function->new( driver => $driver );
isa_ok( $obj, 'DBIx::Schema::Changelog::Action::Function' );

SKIP: {
    eval { require Test::PostgreSQL };
    my $pg = Test::PostgreSQL->new();
    skip "Test::PostgreSQL not installed", 4 unless $pg;

    my $dbh = DBI->connect(
        $pg->dsn( dbname => 'test' ),
        '', '', { AutoCommit => 1, RaiseError => 1, },
    );
    $obj = DBIx::Schema::Changelog::Action::Function->new(
        driver => $driver,
        dbh    => $dbh
    );

    is(
        $obj->add(
            {
                as     => 'select name from name;',
                cost   => 100,
                lang   => 'sql',
                name   => 'sector_tax_items',
                params => ['uuid'],
                return => 'uuid',
            },
            1
        ),
qq~CREATE FUNCTION sector_tax_items(uuid) RETURNS uuid AS 'select name from name;' LANGUAGE sql VOLATILE COST 100~,
        'Add function is failing!'
    );
    my $alter = $obj->alter(
        {
            as     => 'select name from name;',
            cost   => 100,
            lang   => 'sql',
            name   => 'sector_tax_items',
            params => ['uuid'],
            return => 'integer',
        },
        1
    );
    is(
        $alter->{drop},
        qq~DROP FUNCTION sector_tax_items (uuid)~,
        'Add function is failing!'
    );
    is(
        $alter->{add},
        qq~CREATE FUNCTION sector_tax_items(uuid) RETURNS integer AS 'select name from name;' LANGUAGE sql VOLATILE COST 100~,
        'Add function is failing!'
    );
    is(
        $obj->drop(
            {
                name   => 'sector_tax_items',
                params => ['uuid'],
            },
            1
        ),
        qq~DROP FUNCTION sector_tax_items (uuid)~,
        'Add function is failing!'
    );

    $dbh->disconnect();
    done_testing;
}

