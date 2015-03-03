use strict;
use warnings;
use DBI;

use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );

use Test::Requires qw(DBD::Pg Test::PostgreSQL);
use Test::More;
use Test::PostgreSQL;
use Test::More tests => 5;
use Test::Exception;

use DBIx::Schema::Changelog;

require_ok('DBIx::Schema::Changelog::Driver::Pg');
use_ok 'DBIx::Schema::Changelog::Driver::Pg';

my $driver = DBIx::Schema::Changelog::Driver::Pg->new();
dies_ok { $driver->check_version('9.0') }
'underneath min version expecting to die';
is( $driver->check_version('9.1'), 1, 'min version check' );
is( $driver->check_version('9.4'), 1, 'min version check' );

my $pg = Test::PostgreSQL->new(
    my_cnf => {
        'skip-networking' => '',
    }
) or plan skip_all => $Test::PostgreSQL::errstr;

my $dbh = DBI->connect(
    $pg->dsn( dbname => 'test' ),
    '', '', { AutoCommit => 1, RaiseError => 1, },
) or die $DBI::errstr;
DBIx::Schema::Changelog->new( dbh => $dbh, db_driver => 'Pg' )
  ->read( File::Spec->catfile( $FindBin::Bin, 'data', 'changelog' ) );
$dbh->disconnect();
done_testing;
