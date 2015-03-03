use Test::More tests => 9;
use Test::Exception;

use strict;
use warnings;
use File::Spec;

use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );

use DBI;
use DBIx::Schema::Changelog;

require_ok('FindBin');
use_ok 'FindBin';
 
require_ok('DBI');
use_ok 'DBI';

require_ok( 'DBIx::Schema::Changelog::Driver::SQLite' );
use_ok 'DBIx::Schema::Changelog::Driver::SQLite';

my $driver = DBIx::Schema::Changelog::Driver::SQLite->new();
dies_ok { $driver->check_version( '3.0' ) } 'underneath min version expecting to die';
is($driver->check_version( '3.7' ), 1, 'min version check');
is($driver->check_version( '3.9' ), 1, 'min version check');

my $dbh = DBI->connect("dbi:SQLite:database=.tmp.sqlite");
DBIx::Schema::Changelog->new( dbh => $dbh )->read( File::Spec->catfile( $FindBin::Bin, 'data', 'changelog' ) );
$dbh->disconnect();