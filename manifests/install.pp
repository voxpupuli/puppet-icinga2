# == Class: icinga2::install
#
# This class handles the installation of the Icinga 2 package. On Windows only chocolatey is supported as installation
# source.
#
# === Parameters
#
# This class does not provide any parameters.
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
#
class icinga2::install {

  assert_private()

  $package        = $::icinga2::params::package
  $conf_dir       = $::icinga2::params::conf_dir
  $purge_features = $::icinga2::purge_features
  $manage_package = $::icinga2::manage_package
  $pki_dir        = $::icinga2::params::pki_dir
  $user           = $::icinga2::params::user
  $group          = $::icinga2::params::group

  if $manage_package {
    if $::osfamily == 'windows' { Package { provider => chocolatey, } }

    package { $package:
      ensure => installed,
      before => File["${conf_dir}/features-enabled", $pki_dir, $conf_dir],
    }
  }

  # anchor, i.e. for config directory set by confd parameter
  file { $conf_dir:
    ensure  => directory,
  }
  file { $pki_dir:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    recurse => true,
  }
}
