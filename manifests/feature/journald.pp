# @summary
#   Configures the Icinga 2 feature journald.
#
# @param ensure
#   Set to present enables the feature journald, absent disables it.
#
# @param severity
#   You can choose the log severity between information, notice, warning or debug.
#
# @param facility
#   Defines the facility to use for journald entries. This can be a facility constant
#   like FacilityDaemon.
#
# @param identifier
#   Defines the syslog compatible identifier to use for journal entries.
#
class icinga2::feature::journald (
  Enum['absent', 'present']        $ensure     = present,
  Icinga::LogLevel                 $severity   = 'warning',
  Optional[Icinga2::LogFacility]   $facility   = undef,
  Optional[String[1]]              $identifier = undef,
) {
  if ! defined(Class['icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir  = $icinga2::globals::conf_dir
  $_notify   = $ensure ? {
    'present' => Class['icinga2::service'],
    default   => undef,
  }

  # compose attributes
  $attrs = {
    'severity'   => $severity,
    'facility'   => $facility,
    'identifier' => $identifier,
  }

  # create object
  icinga2::object { 'icinga2::object::JournaldLogger::journald':
    object_name => 'journald',
    object_type => 'JournaldLogger',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/journald.conf",
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'journald':
    ensure => $ensure,
  }
}
