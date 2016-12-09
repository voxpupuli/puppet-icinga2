# == Class: icinga2::pki::ca
#
# This class provides multiple ways to create the CA used by Icinga2.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature api, absent disabled it. Defaults to present.
#
# [*source*]
#   This class support multiple sources to create the Icinga CA: 
#    - file: Transfer files from pathes set in 'ca_cert' and 'ca_key'
#    - cli: Generate a CA using the icinga2 CLI command
#    - content: Use the strings set in 'ca_cert' and 'ca_key'
#
# [*ca_cert*]
#   Depending on what the parameter 'source' is set to either a path to a CA certificate
#   or a base64 string.
#
# [*ca_key*]
#   Depending on what the parameter 'source' is set to either a path to a CA key
#   or a base64 string.
#
# === Examples
#
# Create the CA by transfering your own files:
#
# include icinga2
# 
# class { 'icinga2::pki::ca':
#   source => 'file',
#   ca_cert => 'puppet:///modules/icinga2/test_ca.crt',
#   ca_key => 'puppet:///modules/icinga2/test_ca.key',
# }
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::pki::ca(
  $ensure          = present,
  $source          = 'file',
  $ca_cert         = undef,
  $ca_key          = undef,
) {

  include icinga2::params

  $ca_dir = $::icinga2::params::ca_dir
  $user   = $::icinga2::params::user
  $group  = $::icinga2::params::group

  File {
    owner => $user,
    group => $group,
  }

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_re($source, [ '^file$', '^cli$', '^content$' ],
    "${source} isn't supported. Valid values are 'file', 'cli' and 'content'.")

  case $source {
    'file': {
      file { $ca_dir:
        ensure => directory,
        mode   => $::kernel ? {
          'windows' => undef,
          default   => '0700',
        }
      }

      file { "$ca_dir/ca.crt":
        ensure => file,
        source => $ca_cert,
        tag    => 'icinga2::config::file',
      }

      file { "$ca_dir/ca.key":
        ensure => file,
        mode   => $::kernel ? {
          'windows' => undef,
          default   => '0600',
        },
        source => $ca_key,
        tag    => 'icinga2::config::file',
      }
    } # file

    'content': {
      file { $ca_dir:
        ensure => directory,
        mode   => $::kernel ? {
          'windows' => undef,
          default   => '0700',
        }
      }

      file { "$ca_dir/ca.crt":
        ensure => file,
        content  => $::osfamily ? {
          'windows' => regsubst($ca_cert, '\n', "\r\n", 'EMG'),
          default   => $ca_cert,
        },
        tag    => 'icinga2::config::file',
      }

      file { "$ca_dir/ca.key":
        ensure => file,
        mode   => $::kernel ? {
          'windows' => undef,
          default   => '0600',
        },
        content  => $::osfamily ? {
          'windows' => regsubst($ca_key, '\n', "\r\n", 'EMG'),
          default   => $ca_key,
        },
        tag    => 'icinga2::config::file',
      }

    } # content
  } # source

}
