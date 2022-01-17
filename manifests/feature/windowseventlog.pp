# @summary
#   Configures the Icinga 2 feature windowseventlog.
#
# @param ensure
#   Set to present enables the feature windowseventlog, absent disables it.
#
# @param severity
#   You can choose the log severity between information, notice, warning or debug.
#
class icinga2::feature::windowseventlog(
  Enum['absent', 'present']        $ensure   = present,
  Icinga2::LogSeverity             $severity = 'warning',
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  if $facts['os']['family'] != 'windows' and $ensure != 'absent' {
    fail('The feature windowseventlogs is only supported on Windows platforms!')
  }

  $conf_dir  = $::icinga2::globals::conf_dir
  $_notify   = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  # compose attributes
  $attrs = {
    severity => $severity,
  }

  # create object
  icinga2::object { 'icinga2::object::WindowsEventLogLogger::windowseventlog':
    object_name => 'windowseventlog',
    object_type => 'WindowsEventLogLogger',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/windowseventlog.conf",
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'windowseventlog':
    ensure => $ensure,
  }
}

