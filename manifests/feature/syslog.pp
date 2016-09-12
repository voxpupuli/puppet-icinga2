# == Class: icinga2::feature::syslog
#
# This module configures the Icinga2 feature syslog.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature syslog, absent disables it. Default is present.
#
# [*severity*]
#   You can choose the log severity between information, notice, warning or debug.
#   Default to warning.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::syslog(
  $ensure   = present,
  $severity = 'warning',
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_re($severity, ['^information$','^notice$','^warning$','^debug$'])

  icinga2::feature { 'syslog':
    ensure => $ensure,
  }
}

