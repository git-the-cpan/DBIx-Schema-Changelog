use Test::More tests => 2;

use FindBin;
use lib "$FindBin::Bin/../lib";
use strict;
use warnings;


require_ok( 'DBIx::Schema::Changelog::Changeset' );
use_ok 'DBIx::Schema::Changelog::Changeset';