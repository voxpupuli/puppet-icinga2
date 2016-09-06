# == Class: icinga2
#
# This module installs and configures Icinga2.
#
# === Parameters
#
# [*ensure*]
#   Manages if the service should be stopped or running. Default is running.
#
# [*enable*]
#   If set to true the Icinga2 service will start on boot. Default is true.
#
# [*manage_repo*]
#   Manage the corrolated repository from icinga.org on all supported
#   plattforms. Default to false.
#
# [*manage_service*]
#   When set to true this module will install the packages.icinga.org repository. With this official repo you can get
#   the latest version of Icinga. When set to false the operating systems default will be used. As the Icinga Project
#   does not offer a Chocolatey repository, you will get a warning if you enable this parameter on Windows.
#   Default is false
#
#
# All default parameters are set in the icinga2::params class. To get more technical information have a look into the
# params.pp manifest.
#
# === Examples
#
# Declare icinga2 with all defaults. Keep in mind that your operating system may not have Icinga2 in its package
# repository.
#
#  include icinga2
#
# If you want to use the official Icinga Project repository, enable the manage_repo parameter. Note: On Windows only
# chocolatey is supported as installation source. The Icinga Project does not offer a chocolatey repository, therefore
# you will get a warning if you enable this parameter
# on windows.
#
#  class { 'icinga2':
#    manage_repo => true,
#  }
#
# If you don't want to manage the Icinga2 service with puppet, you can dissable this behaviour with the manage_service
# parameter. When set to false no service refreshes will be triggered.
#
#  class { 'icinga2':
#    manage_service => false,
#  }
#
# Sometimes it's necessary to cover very special configurations that you cannot handle with this module. In this case
# you can use the icinga2::config::file tag on your file ressource. This module collects all file ressource types with
# this tag and triggers a reload of Icinga2 on a file change.
#
#  include icinga2
#  file { '/etc/icinga2/icinga2.conf':
#    ensure => file,
#    owner  => icinga,
#    ...
#    tag    => 'icinga2::config::file',
#    ...
#  }
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2(
  $ensure         = running,
  $enable         = true,
  $manage_repo    = false,
  $manage_service = true,
) inherits icinga2::params {

  validate_re($ensure, [ '^running$', '^stopped$' ],
    "${ensure} isn't supported. Valid values are 'running' and 'stopped'.")
  validate_bool($enable)
  validate_bool($manage_repo)
  validate_bool($manage_service)

  anchor { 'icinga2::begin':
    notify => Class['icinga2::service']
  }
  -> class { 'icinga2::repo': }
  -> class { 'icinga2::install': }
  -> class { 'icinga2::config': notify => Class['icinga2::service'] }
  -> File <| tag == 'icinga2::config::file' |>
  ~> class { 'icinga2::service': }
  -> anchor { 'icinga2::end':
    subscribe => Class['icinga2::config']
  }

}
