use Test::More tests => 9;

use FindBin;
use lib "$FindBin::Bin/../lib";
use strict;
use warnings;
use DBIx::Schema::Changelog::Driver::Pg;

require_ok('DBIx::Schema::Changelog::Driver::Pg');
use_ok 'DBIx::Schema::Changelog::Driver::Pg';

require_ok('DBIx::Schema::Changelog::Action::Sequence');
use_ok 'DBIx::Schema::Changelog::Action::Sequence';

my $driver = DBIx::Schema::Changelog::Driver::Pg->new();
my $object =
  DBIx::Schema::Changelog::Action::Sequence->new( driver => $driver );

can_ok( 'DBIx::Schema::Changelog::Action::Sequence',
    @{ [ 'add', 'alter', 'drop' ] } );
isa_ok( $object, 'DBIx::Schema::Changelog::Action::Sequence' );

is( $object->add( { default => 'inc', table => 'test', name => 'seq_test' } ),
    undef, 'Add sequence is failing!' );
is( $object->alter(), undef, 'Alter sequence is failing' );
is( $object->drop(),  undef, 'Drop sequence is failing' );

