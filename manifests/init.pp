# == Class: icinga2
#
# This module installs and configures Icinga2.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   Set to stopped declare the service to be stopped. Default to running.
#
# [*enable*]
#   Enables (true) or disables (false) the service to start at boot. Default to true.
#
# [*manage_repo*]
#   Manage the corrolated repository from icinga.org on all supported
#   plattforms. Default to false.
#
# [*manage_service*]
#   If set to true the service is managed otherwise the service also
#   isn't restarted if a config file changed.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#
# === Examples
#
#  class { 'icinga2':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
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
  -> File <| tag == 'icinga2::config::file' |> { notify => Class['icinga2::service'] }
  -> class { 'icinga2::config': }
  ~> class { 'icinga2::service': }
  -> anchor { 'icinga2::end':
    subscribe => Class['icinga2::config']
  }

}
