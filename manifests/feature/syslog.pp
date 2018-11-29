# == Class: icinga2::feature::syslog
#
# This module configures the Icinga 2 feature syslog.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature syslog, absent disables it. Defaults to present.
#
# [*severity*]
#   You can choose the log severity between information, notice, warning, critical or debug.
#   Defaults to warning.
#
# [*facility*]
#   Defines the facility to use for syslog entries. This can be a facility constant like FacilityDaemon. Defaults to FacilityUser.
#
#
class icinga2::feature::syslog(
  $ensure   = present,
  $severity = 'warning',
  $facility = 'LOG_USER',
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir  = $::icinga2::params::conf_dir
  $_notify   = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_re($severity, ['^information$','^notice$','^warning$','^debug$','^critical$'])
  validate_re($facility, ['^LOG_AUTH$','^LOG_AUTHPRIV$','^LOG_CRON$','^LOG_DAEMON$','^LOG_FTP$','^LOG_KERN$','^LOG_LOCAL0$','^LOG_LOCAL1$','^LOG_LOCAL2$','^LOG_LOCAL3$','^LOG_LOCAL4$','^LOG_LOCAL5$','^LOG_LOCAL6$','^LOG_LOCAL7$','^LOG_LPR$','^LOG_MAIL$','^LOG_NEWS$','^LOG_SYSLOG$','^LOG_USER$','^LOG_UUCP$'])

  # compose attributes
  $attrs = {
    severity => $severity,
    facility => $facility,
  }

  # create object
  icinga2::object { 'icinga2::object::SyslogLogger::syslog':
    object_name => 'syslog',
    object_type => 'SyslogLogger',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/syslog.conf",
    order       => '10',
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'syslog':
    ensure => $ensure,
  }
}

