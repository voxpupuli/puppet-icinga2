# == Class: icinga2::feature::compatlog
#
# This module configures the Icinga2 feature compatlog.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   Set to present enables the feature compatlog, absent disabled it. Default to present.
#
# [*slog_dir*]
#   Absolute path to the log file. Default depends on plattform, /var/log/icinga2/compat
#   on Linux and C:/ProgramData/icinga2/var/log/icinga2/compat on Windows.
#
# [*rotation_method*]
#   How often the log file will be rotated, valid options are HOURLY, DAILY, WEEKLY and MONTHLY.
#   Default to DAILY.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::compatlog(
  $ensure          = present,
  $log_dir         = "${::icinga2::params::log_dir}/compat",
  $rotation_method = 'DAILY',
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($log_dir)
  validate_re($rotation_method, ['^HOURLY$','^DAILY$','^WEEKLY$','^MONTHLY$'])

  icinga2::feature { 'compatlog':
    ensure => $ensure,
  }
}
