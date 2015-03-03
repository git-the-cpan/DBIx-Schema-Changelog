use Test::More tests => 4;

use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );
use strict;
use warnings;
use File::Path qw(remove_tree);

require_ok( 'FindBin' );
use_ok 'FindBin';

require_ok( 'File::Path' );
use_ok 'File::Path';


my $file = File::Spec->catfile( $FindBin::Bin, '..', '.tmp.sqlite' );
my $path = File::Spec->catfile( $FindBin::Bin, '..', '.tmp' );
unlink $file or warn "Could not unlink $file: $!";
remove_tree $path or warn "Could not unlink $path: $!";
