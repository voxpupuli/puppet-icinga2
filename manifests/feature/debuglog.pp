# == Class: icinga2::feature::debuglog
#
# This module configures the Icinga2 feature mainlog.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   Set to present enables the feature mainlog, absent disabled it. Default to present.
#
# [*path*]
#   Absolute path to the log file. Default depends on plattform, /var/log/icinga2/debug.log
#   on Linux and C:/ProgramData/icinga2/var/log/icinga2/debug.log on Windows.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::debuglog(
  $ensure   = present,
  $path     = "${log_dir}/debug.log",
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($path)

  icinga2::feature { 'debuglog':
    ensure => $ensure,
  }
}
