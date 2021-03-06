use Test::More tests => 2;

use FindBin;
use lib File::Spec->catfile( $FindBin::Bin, '..', 'lib' );
use strict;
use warnings;

require_ok('DBIx::Schema::Changelog::File::Yaml');
use_ok 'DBIx::Schema::Changelog::File::Yaml';

my $obj = DBIx::Schema::Changelog::File::Yaml->new();

my $path =
  File::Spec->catfile( $FindBin::Bin, 'data', 'changelog', 'changelog' );
my $main = $obj->load($path);

#File::Spec->catfile( $folder, "changelog-$_" ) ;

foreach ( @{ $main->{changelogs} } ) {
    my $file = File::Spec->catfile( $FindBin::Bin, 'data', 'changelog',
        'changelog-' . $_ );
    foreach ( @{ $obj->load($file) } ) { 
    	
    }
}
