use strict;
use warnings;
use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );
use Test::Requires qw(DBI DBD::Pg Test::PostgreSQL);
use DBI;
use Test::PostgreSQL;
use Test::More;
use Test::Exception;
use DBIx::Schema::Changelog;

plan tests => 9;

require_ok('DBIx::Schema::Changelog::Driver::Pg');
use_ok 'DBIx::Schema::Changelog::Driver::Pg';

my $driver = new_ok('DBIx::Schema::Changelog::Driver::Pg');

dies_ok { $driver->check_version('9.0') }
'underneath min version expecting to die';
is( $driver->check_version('9.1'), 1, 'min version check' );
is( $driver->check_version('9.4'), 1, 'min version check' );

SKIP: {
    eval { require Test::PostgreSQL };

    skip "Test::PostgreSQL not installed", 3 if $@;

    my $pg  = new_ok('Test::PostgreSQL');
    my $dbh = DBI->connect(
        $pg->dsn( dbname => 'test' ),
        '', '', { AutoCommit => 1, RaiseError => 1, },
    );
    my $obj =
      new_ok( 'DBIx::Schema::Changelog' => [ dbh => $dbh, db_driver => 'Pg' ] );

    is(
        $obj->read( File::Spec->catfile( $FindBin::Bin, 'data', 'changelog' ) ),
        '',
        "Running changelogs"
    );
    $dbh->disconnect();
    done_testing;
}
