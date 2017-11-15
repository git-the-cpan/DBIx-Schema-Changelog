use Test::More tests => 13;

use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );
use strict;
use warnings;
use DBI;

require_ok('DBI');
use_ok 'DBI';

require_ok('SQL::Abstract');
use_ok 'SQL::Abstract';

require_ok('DBIx::Schema::Changelog::Driver::SQLite');
use_ok 'DBIx::Schema::Changelog::Driver::SQLite';

require_ok('DBIx::Schema::Changelog::Action::Entry');
use_ok 'DBIx::Schema::Changelog::Action::Entry';

my $dbh = DBI->connect("dbi:SQLite:database=.tmp.sqlite")
  or plan skip_all => $DBI::errstr;

my $driver = DBIx::Schema::Changelog::Driver::SQLite->new();
my $object =
  DBIx::Schema::Changelog::Action::Entry->new( driver => $driver, dbh => $dbh );

can_ok( 'DBIx::Schema::Changelog::Action::Entry',
    @{ [ 'add', 'alter', 'drop' ] } );
isa_ok( $object, 'DBIx::Schema::Changelog::Action::Entry' );

my $params =
  { name => '"user"', cols => [ 'name', 'client' ], add => [ [ 'test', 1 ] ] };
is(
    $object->add($params),
    'INSERT INTO "user" ( name,client) VALUES (?,?)',
    'Alter entry test'
);

$params = {
    name => '"user"',
    cols => [ 'name', 'client' ],
    add  => [ [ 'test_2', 1 ] ],
    where => { name => 'test' }
};
is(
    $object->alter($params),
    'UPDATE "user" SET client = ?, name = ? WHERE ( name = ? )',
    'Alter entry test'
);

$params = {
    name  => '"user"',
    where => { name => 'test' }
};
is(
    $object->drop($params),
    'DELETE FROM "user" WHERE ( name = ? )',
    'Delete entry test'
);

$dbh->disconnect();
