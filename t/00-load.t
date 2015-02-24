use Test::More tests => 35;

use FindBin;
use lib "$FindBin::Bin/../lib";
use strict;
use warnings;

require_ok( 'DBIx::Schema::Changelog' );
use_ok 'DBIx::Schema::Changelog';

require_ok( 'MooseX::Types::Path::Class' );
use_ok 'MooseX::Types::Path::Class';

require_ok( 'JSON::Parse' );
use_ok 'JSON::Parse';

require_ok( 'DBI' );
use_ok 'DBI';

require_ok( 'Hash::MD5' );
use_ok 'Hash::MD5';

require_ok( 'Iterator::Simple' );
use_ok 'Iterator::Simple';

require_ok( 'DBI' );
use_ok 'DBI';

require_ok( 'YAML::XS' );
use_ok 'YAML::XS';

require_ok( 'Moose' );
use_ok 'Moose';

require_ok( 'Module::Version' );
use_ok 'Module::Version';

require_ok( 'MooseX::HasDefaults::RO' );
use_ok 'MooseX::HasDefaults::RO';

require_ok( 'YAML' );
use_ok 'YAML';

require_ok( 'Storable' );
use_ok 'Storable';

require_ok( 'Method::Signatures::Simple' );
use_ok 'Method::Signatures::Simple';

require_ok( 'Getopt::Long' );
use_ok 'Getopt::Long';

require_ok( 'MooseX::Types::Moose' );
use_ok 'MooseX::Types::Moose';

require_ok( 'Path::Class' );
use_ok 'Path::Class';

use_ok 'DBIx::Schema::Changelog';
