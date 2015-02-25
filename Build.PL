use Module::Build;

Module::Build->new(
    module_name    => 'DBIx::Schema::Changelog',
    license        => 'artistic_2',
    dist_abstract  => 'Forward database update from different configs',
    dist_author    => 'Mario Zieschang <mziescha@cpan.org>',
    build_requires => {
        Test::More              => 0,
        FindBin                 => 0,
        Test::Pod               => 1.22,
        Test::Pod::Coverage     => 1.08,
        Pod::Coverage::TrustPod => 0.100003,
        Test::CheckManifest     => 0.9,
        DBD::SQLite             => 0,
    },
    configure_requires => {
        Module::Build => 0.3800,
    },
    requires => {
        'strict'                       => 0,
        'warnings'                     => 0,
        'MooseX::Types::Path::Class'   => 0.06,
        'JSON::Parse'                  => 0.31,
        'Pod::Usage'                   => 0,
        'DBI'                          => 1.632,
        'Data::Dumper'                 => 2.151,
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
    meta_merge => {
        resources => {
            repository => 'https://github.com/mziescha/DBIx-Schema-Changelog',
        }
    },
)->create_build_script();
