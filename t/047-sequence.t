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

require_ok('DBIx::Schema::Changelog::Action::Sequence');
use_ok 'DBIx::Schema::Changelog::Action::Sequence';

my $driver = DBIx::Schema::Changelog::Driver::Pg->new();
my $object =
  DBIx::Schema::Changelog::Action::Sequence->new( driver => $driver );
is( $object->alter(), undef, 'Alter sequence is failing' );
is( $object->drop(),  undef, 'Drop sequence is failing' );

can_ok( 'DBIx::Schema::Changelog::Action::Sequence',
    @{ [ 'add', 'alter', 'drop' ] } );
isa_ok( $object, 'DBIx::Schema::Changelog::Action::Sequence' );

SKIP: {
	eval { require Test::PostgreSQL };
 
    my $pg  = Test::PostgreSQL->new();
    skip "Test::PostgreSQL not installed", 1 unless $pg;

    my $dbh = DBI->connect(
        $pg->dsn( dbname => 'test' ),
        '', '', { AutoCommit => 1, RaiseError => 1, },
    );
    $object = DBIx::Schema::Changelog::Action::Sequence->new(
        driver => $driver,
        dbh    => $dbh
    );

    is(
        $object->add(
            { default => 'inc', table => 'test', name => 'seq_test' }
        ),
        q~DEFAULT nextval('seq_test_seq_test'::regclass)~,
        'Add sequence is failing!'
    );

    $dbh->disconnect();
    done_testing;
}

