# == Class: icinga2::install
#
# Private class to used by this module only.
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

  $package  = $icinga2::params::package
  $conf_dir = $icinga2::params::conf_dir

  package { $package:
    ensure => installed,
  }

  # anchor, i.e. for config directory set by confd parameter
  file { $conf_dir:
    ensure  => directory,
    require => Package[$package]
  }
}
