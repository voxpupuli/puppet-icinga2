# @summary
#   This class handles the installation of the Icinga 2 package.
#   On Windows only chocolatey is supported as installation source.
#
# @api private
#
class icinga2::install {

  assert_private()

  $package_name   = $::icinga2::globals::package_name
  $manage_package = $::icinga2::manage_package
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
  }

  file { [$cert_dir, $conf_dir]:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

}
