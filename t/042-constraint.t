use Test::More tests => 14;
use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );
use strict;
use warnings;
use Data::Dumper;
use Hash::MD5 qw(sum_array);

require_ok('DBIx::Schema::Changelog::Driver::Pg');
use_ok 'DBIx::Schema::Changelog::Driver::Pg';

require_ok('DBIx::Schema::Changelog::Action::Constraint');
use_ok 'DBIx::Schema::Changelog::Action::Constraint';

my $driver = new_ok('DBIx::Schema::Changelog::Driver::Pg');
my $object =
  DBIx::Schema::Changelog::Action::Constraint->new( driver => $driver );

can_ok( 'DBIx::Schema::Changelog::Action::Constraint',
    @{ [ 'alter', 'drop' ] } );
isa_ok( $object, 'DBIx::Schema::Changelog::Action::Constraint' );

is( $object->alter(), 1, 'Sub is not used' );
is( $object->drop(),  1, 'Sub is not used' );
my $constraints = [];

$object->add(
    { name => 'primarykey_test', primarykey => [ 'pk_col1', 'pk_col2' ] },
    $constraints );

is(
    sum_array($constraints),
    sum_array(
        ['CONSTRAINT pkay_multi_primarykey_test PRIMARY KEY (pk_col1,pk_col2)']
    ),
    "Multi primarykeys"
);

$constraints = [];
$object->add( { name => 'unique_test', unique => [ 'un_col1', 'un_col2' ] },
    $constraints );
is( sum_array($constraints),
    sum_array( ['CONSTRAINT unique_unique_test UNIQUE (un_col1,un_col2)'] ),
    "Unique keys" );

$constraints = [];
$object->add(
    {
        table   => 'table',
        name    => 'foreign_test',
        foreign => { reftable => 'player', refcolumn => 'id' }
    },
    $constraints
);
is(
    sum_array($constraints),
    sum_array(
        [
'CONSTRAINT fkey_table_id_foreign_test FOREIGN KEY (foreign_test) REFERENCES player (id) MATCH SIMPLE ON DELETE NO ACTION ON UPDATE NO ACTION'
        ]
    ),
    "Foreign keys"
);

is( $object->add( { not_null => 1 }, $constraints ), '  ', 'Not null' );
is( $object->add( { primary_key => 1 }, $constraints ),
    '  ', 'Primary key for single column' );
