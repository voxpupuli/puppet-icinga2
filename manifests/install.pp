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

  if defined($caller_module_name) and $module_name != $caller_module_name {
    fail("icinga2::install is a private class of the module icinga2, you're not permitted to use it.")
  }

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
      before => File["${conf_dir}/features-enabled", $pki_dir],
    }
  }

  file { "${conf_dir}/features-enabled":
    ensure  => directory,
    purge   => $purge_features,
    recurse => $purge_features,
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
