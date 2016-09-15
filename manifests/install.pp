# == Class: icinga2::install
#
# This class handles the installation of the Icinga2 package. On Windows only chocolatey is supported as installation
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
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::install {

  if $module_name != $caller_module_name {
    fail("icinga2::install is a private class of the module icinga2, you're not permitted to use it.")
  }

  if $::osfamily == 'windows' { Package { provider => chocolatey, } }

  $package        = $::icinga2::params::package
  $conf_dir       = $::icinga2::params::conf_dir
  $purge_features = $::icinga2::purge_features
  $pki_dir        = $::icinga2::params::pki_dir

  package { $package:
    ensure => installed,
  }

  file { $pki_dir:
    ensure => directory,
    require => Package[$package],
  }

  file { "${conf_dir}/features-enabled": 
    ensure  => directory,
    purge   => $purge_features,
    recurse => $purge_features,
    require => Package[$package],
  }

  # anchor, i.e. for config directory set by confd parameter
  file { $conf_dir:
    ensure  => directory,
    require => Package[$package]
  }
}
