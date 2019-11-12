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

  $package_name   = $::icinga2::globals::package_name
  $manage_package = $::icinga2::manage_package
  $selinux_name   = $::icinga2::globals::selinux_name
  $manage_selinux = $::icinga2::manage_selinux
  $cert_dir       = $::icinga2::globals::cert_dir
  $conf_dir       = $::icinga2::globals::conf_dir
  $user           = $::icinga2::globals::user
  $group          = $::icinga2::globals::group

  if $manage_package {
    if $::osfamily == 'windows' { Package { provider => chocolatey, } }

    package { $package_name:
      ensure => installed,
      before => File[$cert_dir, $conf_dir],
    }

    if $manage_selinux {
      package { $selinux_name:
        ensure => installed,
        after  => [Package[$package_name], File[$cert_dir, $conf_dir]],
      }
    }
  }

  file { [$cert_dir, $conf_dir]:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

}
