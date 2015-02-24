use Test::More tests => 2;

use FindBin;
use lib "$FindBin::Bin/../lib";
use strict;
use warnings;

require_ok( 'FindBin' );
use_ok 'FindBin';

my $file = $FindBin::Bin . '/../.tmp.sqlite';
unlink $file or warn "Could not unlink $file: $!";
