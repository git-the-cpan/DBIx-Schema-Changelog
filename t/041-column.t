use Test::More tests => 9;

use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );
use strict;
use warnings;
use DBI;
use DBIx::Schema::Changelog::Driver::SQLite;
my $driver = DBIx::Schema::Changelog::Driver::SQLite->new();

require_ok('DBI');
use_ok 'DBI';

require_ok('DBIx::Schema::Changelog::Action::Column');
use_ok 'DBIx::Schema::Changelog::Action::Column';

my $dbh    = DBI->connect("dbi:SQLite:database=.tmp.sqlite");
my $object = DBIx::Schema::Changelog::Action::Column->new(
    driver => $driver,
    dbh    => $dbh
);

can_ok( 'DBIx::Schema::Changelog::Action::Column',
    @{ [ 'add', 'alter', 'drop' ] } );
isa_ok( $object, 'DBIx::Schema::Changelog::Action::Column' );

is(
    $object->add(
        { table => '"user"', name => 'drop_test', type => 'integer' }
    ),
    'ADD COLUMN drop_test INTEGER   ',
    'Add column test.'
);
is(
    $object->alter(
        {
            table  => '"user"',
            name   => 'drop_test',
            type   => 'varchar',
            lenght => 255
        }
    ),
    undef,
    'Alter column test.'
);
is( $object->drop( { table => '"user"', name => 'drop_test' } ),
    undef, 'Drop column test.' );
$dbh->disconnect();