use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Requires qw(Test::Spelling);
use Test::Spelling;


plan( skip_all => "Author tests not required for installation" );


plan tests => 30;
add_stopwords(
    @{
        [
            'Zieschang', 'licensable', 'dbh',       'sql',
            'Sql',       'Changeset',  'changeset', 'postfix',
            'AnnoCPAN',  'cpanminus',
        ]
    }
);

pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog.pm', 'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Action.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Changeset.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Command.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Driver.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/File.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Action/Column.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Action/Constraint.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Action/Default.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Action/Index.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Action/Sequence.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Action/Sql.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Action/Table.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Action/View.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Command/Base.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Command/Changeset.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Command/Driver.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Command/File.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Driver/Pg.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Driver/SQLite.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/File/JSON.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/File/Yaml.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Exceptions.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Exceptions/NoDefaultValue.pm',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Cookbook.pod',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Manual.pod',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Tutorial.pod',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Cookbook/Changeset.pod',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Cookbook/Driver.pod',
    'POD file spelling OK' );
pod_file_spelling_ok( 'lib/DBIx/Schema/Changelog/Cookbook/File.pod',
    'POD file spelling OK' );
