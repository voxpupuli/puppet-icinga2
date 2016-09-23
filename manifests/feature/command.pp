# == Class: icinga2::feature::command
#
# This module configures the Icinga2 feature command.
#
# === Parameters
#
# [*ensure*]
#   Set to present to enable the feature command, absent to disabled it. Defaults to present.
#
# [*command_path*]
#   Absolute path to the command pipe. Default depends on platform, /var/run/icinga2/cmd/icinga2.cmd on Linux
#   and C:/ProgramData/icinga2/var/run/icinga2/cmd/icinga2.cmd on Windows.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::command(
  $ensure       = present,
  $command_path = "${::icinga2::params::run_dir}/cmd/icinga2.cmd",
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($command_path)

  icinga2::feature { 'command':
    ensure => $ensure,
  }
}
