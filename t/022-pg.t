use strict;
use warnings;

use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );

use Test::Requires qw(DBI DBD::Pg Test::PostgreSQL);
use DBI;
use Test::PostgreSQL;
use Test::More tests => 9;
use Test::Exception;

use DBIx::Schema::Changelog;

my $pg = new_ok(
    'Test::PostgreSQL' => [
        my_cnf => {
            'skip-networking' => '',
        }
    ]
) or plan( skip_all => $Test::PostgreSQL::errstr );

require_ok('DBIx::Schema::Changelog::Driver::Pg');
use_ok 'DBIx::Schema::Changelog::Driver::Pg';

my $driver = new_ok('DBIx::Schema::Changelog::Driver::Pg');

dies_ok { $driver->check_version('9.0') }
'underneath min version expecting to die';
is( $driver->check_version('9.1'), 1, 'min version check' );
is( $driver->check_version('9.4'), 1, 'min version check' );

my $dbh = DBI->connect(
    $pg->dsn( dbname => 'test' ),
    '', '', { AutoCommit => 1, RaiseError => 1, },
) or plan( skip_all => $DBI::errstr );
my $obj =
  new_ok( 'DBIx::Schema::Changelog' => [ dbh => $dbh, db_driver => 'Pg' ] )
  or plan skip_all => "";

#my $object = DBIx::Schema::Changelog->new(  );
is( $obj->read( File::Spec->catfile( $FindBin::Bin, 'data', 'changelog' ) ),
    '', "Running changelogs" )
  or plan( skip_all => "Undefined interupted but not realy necessarry." );
$dbh->disconnect();
done_testing;
