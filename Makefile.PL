use 5.10.0;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'DBIx::Schema::Changelog',
    AUTHOR             => q{Mario Zieschang <mziescha@cpan.org>},
    VERSION_FROM       => 'lib/DBIx/Schema/Changelog.pm',
    ABSTRACT_FROM      => 'lib/DBIx/Schema/Changelog.pm',
    LICENSE            => 'artistic_2',
    PL_FILES           => {},
    MIN_PERL_VERSION   => 5.10.0,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'strict'                       => 0,
        'warnings'                     => 0,
        'MooseX::Types::Path::Class'   => 0.06,
        'JSON::Parse'                  => 0.31,
        'Pod::Usage'                   => 0,
        'DBI'                          => 1.632,
'Data::Dumper' => 2.151,
        'Hash::MD5'                    => 0.05,
        'Iterator::Simple'             => 0.06,
        'YAML::XS'                     => 0.55,
        'Moose'                        => 2.1403,
        'Module::Version'              => 0.12,
        'MooseX::HasDefaults::RO'      => 0,
        'YAML'                         => 1.13,
        'Storable'                     => 2.49,
        'Method::Signatures::Simple'   => 1.07,
        'Getopt::Long'                 => 2.42,
        'MooseX::Types::Moose'         => 0.45,
        'Path::Class'                  => 0.3,
        'Text::Trim'                   => 1.02,
        'Time::Piece'                  => 1.27,
        'MooseX::Types::LoadableClass' => 0.013,
        'MooseX::Types::PerlVersion'   => 0.002,
        'DBD::SQLite'                  => 1.4,
        'File::Spec'                   => 0,
    },
    PREREQ_PM => {

        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources   => {
            repository => {
                type => 'git',
                url  => 'https://github.com/mziescha/DBIx-Schema-Changelog.git',
                web  => 'https://github.com/mziescha/DBIx-Schema-Changelog',
            },
        }
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'DBIx-Schema-Changelog-*' },
);
