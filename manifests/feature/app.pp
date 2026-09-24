# @summary
#   Configures the Icinga 2 feature app.
#
# @param ensure
#   Set to present enables the feature syslog, absent disables it.
#
# @param enable_notifications
#   Whether notifications are globally enabled.
#
# @param enable_event_handlers
#   Whether event handlers are globally enabled.
#
# @param enable_flapping
#   Whether flap detection is globally enabled.
#
# @param enable_host_checks
#   Whether active host checks are globally enabled.
#
# @param enable_service_checks
#   Whether active service checks are globally enabled.
#
# @param enable_perfdata
#   Whether performance data processing is globally enabled.
#
# @param vars
#   A dictionary containing custom variables that are available globally.
#
# @param environment
#   Specify the Icinga environment. This overrides the Environment constant specified
#   in the configuration or on the CLI with `--define`.
#
class icinga2::feature::app (
  Enum['absent', 'present'] $ensure                = present,
  Optional[Boolean]         $enable_notifications  = undef,
  Optional[Boolean]         $enable_event_handlers = undef,
  Optional[Boolean]         $enable_flapping       = undef,
  Optional[Boolean]         $enable_host_checks    = undef,
  Optional[Boolean]         $enable_service_checks = undef,
  Optional[Boolean]         $enable_perfdata       = undef,
  Optional[Hash]            $vars                  = undef,
  Optional[String[1]]       $environment           = undef,
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
    'enable_notifications'  => $enable_notifications,
    'enable_event_handlers' => $enable_event_handlers,
    'enable_flapping'       => $enable_flapping,
    'enable_host_checks'    => $enable_host_checks,
    'enable_service_checks' => $enable_service_checks,
    'enable_perfdata'       => $enable_perfdata,
    'vars'                  => $vars,
    'environment'           => $environment,
  }

  # create object
  icinga2::object { 'icinga2::object::IcingaApplication::app':
    object_name => 'app',
    object_type => 'IcingaApplication',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/app.conf",
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'app':
    ensure => $ensure,
  }
}
