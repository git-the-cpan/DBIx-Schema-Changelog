use Test::Command tests => 2;

use FindBin;
use lib "$FindBin::Bin/../lib";
use strict;
use warnings;
 
my $cmd = 'changelog-run -?'; 
exit_is_num($cmd, 127);

$cmd = "changelog-run -s=''";
exit_is_num($cmd, 127);

