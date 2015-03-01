use Test::More tests => 6;
use FindBin;
use lib "$FindBin::Bin/../lib";
use strict;
use warnings;

require_ok('DBIx::Schema::Changelog::Action::Constraint');
use_ok 'DBIx::Schema::Changelog::Action::Constraint';

my $object = DBIx::Schema::Changelog::Action::Constraint->new();

can_ok( 'DBIx::Schema::Changelog::Action::Constraint',
    @{ [ 'alter', 'drop' ] } );
isa_ok( $object, 'DBIx::Schema::Changelog::Action::Constraint' );

is( $object->alter(), 1, 'Sub is not used' );
is( $object->drop(),  1, 'Sub is not used' );
