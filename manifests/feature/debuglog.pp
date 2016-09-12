# == Class: icinga2::feature::debuglog
#
# This module configures the Icinga2 feature mainlog.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature mainlog, absent disables it. Default is present.
#
# [*path*]
#   Absolute path to the log file. Default depends on platform:
#   /var/log/icinga2/debug.log on Linux
#   C:/ProgramData/icinga2/var/log/icinga2/debug.log on Windows
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::debuglog(
  $ensure   = present,
  $path     = "${::icinga2::params::log_dir}/debug.log",
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($path)

  icinga2::feature { 'debuglog':
    ensure => $ensure,
  }
}
