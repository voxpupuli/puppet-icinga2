# == Class: icinga2::feature::syslog
#
# This module configures the Icinga2 feature syslog.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature syslog, absent disables it. Defaults to present.
#
# [*severity*]
#   You can choose the log severity between information, notice, warning or debug.
#   Defaults to warning.
#
# === Authors
#
# Icinga Development Team <info@icinga.com>
#
class icinga2::feature::syslog(
  $ensure   = present,
  $severity = 'warning',
) {

  $conf_dir  = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_re($severity, ['^information$','^notice$','^warning$','^debug$'])

  # compose attributes
  $attrs = {
    severity => $severity,
  }

  # create object
  icinga2::object { 'icinga2::object::SyslogLogger::syslog':
    object_name => 'syslog',
    object_type => 'SyslogLogger',
    attrs       => $attrs,
    target      => "${conf_dir}/features-available/syslog.conf",
    order       => '10',
    notify      => $ensure ? {
      'present' => Class['::icinga2::service'],
      default   => undef,
    },
  }

  # manage feature
  icinga2::feature { 'syslog':
    ensure => $ensure,
  }
}

