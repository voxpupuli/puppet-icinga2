# == Class: icinga2::feature::mainlog
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
# [*severity*]
#   You can choose the log severity between information, notice, warning or debug.
#   Default to information.
#
# [*path*]
#   Absolute path to the log file. Default depends on plattform, /var/log/icinga2/icinga2.log
#   on Linux and C:/ProgramData/icinga2/var/log/icinga2/icinga2.log on Windows.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::mainlog(
  $ensure   = present,
  $severity = 'information',
  $path     = "${::icinga2::params::log_dir}/icinga2.log",
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_re($severity, ['^information$','^notice$','^warning$','^debug$'])
  validate_absolute_path($path)

  icinga2::feature { 'mainlog':
    ensure => $ensure,
  }
}
