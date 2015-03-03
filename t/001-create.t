use Test::More tests => 6;

use FindBin;
use File::Spec;
use lib  File::Spec->catfile( $FindBin::Bin, '..', 'lib' );
use strict;
use warnings;
use DBI;
use DBIx::Schema::Changelog;

require_ok('FindBin');
use_ok 'FindBin';

require_ok('DBI');
use_ok 'DBI';

require_ok('DBIx::Schema::Changelog');
use_ok 'DBIx::Schema::Changelog';

my $dbh = DBI->connect("dbi:SQLite:database=.tmp.sqlite");
DBIx::Schema::Changelog->new( dbh => $dbh )->read( File::Spec->catfile( $FindBin::Bin, 'data', 'changelog' ) );
$dbh->disconnect();