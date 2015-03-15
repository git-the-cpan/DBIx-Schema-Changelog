use Test::More tests => 8;

use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );
use strict;
use warnings;
use DBIx::Schema::Changelog::Driver::SQLite;
my $driver = DBIx::Schema::Changelog::Driver::SQLite->new();


require_ok( 'DBIx::Schema::Changelog::Action::Index' );
use_ok 'DBIx::Schema::Changelog::Action::Index';

require_ok('DBIx::Schema::Changelog::Action::Index');
use_ok 'DBIx::Schema::Changelog::Action::Index';

my $object = DBIx::Schema::Changelog::Action::Index->new( driver => $driver );

can_ok( 'DBIx::Schema::Changelog::Action::Index',
    @{ [ 'add', 'alter', 'drop' ] } );
isa_ok( $object, 'DBIx::Schema::Changelog::Action::Index' );

is( $object->alter(),  undef, 'Sub is not used' );
is( $object->drop(),  undef, 'Sub is not used' );
