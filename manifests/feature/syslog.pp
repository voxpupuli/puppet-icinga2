# @summary
#   Configures the Icinga 2 feature syslog.
#
# @param ensure
#   Set to present enables the feature syslog, absent disables it.
#
# @param severity
#   You can choose the log severity between information, notice, warning or debug.
#
# @param facility
#   Defines the facility to use for syslog entries. This can be a facility constant
#   like FacilityDaemon.
#
class icinga2::feature::syslog(
  Enum['absent', 'present']        $ensure   = present,
  Icinga2::LogSeverity             $severity = 'warning',
  Optional[Icinga2::LogFacility]   $facility = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir  = $::icinga2::globals::conf_dir
  $_notify   = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

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
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'syslog':
    ensure => $ensure,
  }
}

