# @summary
#   Manage Icinga 2 IcingaApplication objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param app_name
#   Set the Icinga 2 name of the IcingaApplication object.
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
#   A dictionary containing custom attributes that are specific to this service,
#   a string to do operations on this dictionary or an array for multiple use
#   of custom attributes.
#
# @param environment
#   Specify the Icinga environment. This overrides the Environment constant
#   specified in the configuration or on the CLI with --define.
#
# @param target
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# @param order
#   String or integer to control the position in the target file, sorted alpha numeric.
#
# @param export
#   Export object to destination, collected by class `icinga2::query_objects`.
#
define icinga2::object::icingaapplication (
  Enum['absent', 'present']             $ensure                = present,
  String[1]                             $app_name              = $title,
  Optional[Boolean]                     $enable_notifications  = undef,
  Optional[Boolean]                     $enable_event_handlers = undef,
  Optional[Boolean]                     $enable_flapping       = undef,
  Optional[Boolean]                     $enable_host_checks    = undef,
  Optional[Boolean]                     $enable_service_checks = undef,
  Optional[Boolean]                     $enable_perfdata       = undef,
  Optional[Icinga2::CustomAttributes]   $vars                  = undef,
  Optional[String[1]]                   $environment           = undef,
  Optional[Stdlib::Absolutepath]        $target                = undef,
  Variant[String[1], Integer[0]]        $order                 = 5,
  Variant[Array[String[1]], String[1]]  $export                = [],
) {
  require icinga2::globals
  $conf_dir = $icinga2::globals::conf_dir

  # set defaults
  if $target {
    $_target = $target
  } else {
    $_target = "${conf_dir}/app.conf"
  }

  # compose the attributes
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
  $config = {
    'object_name' => $app_name,
    'object_type' => 'IcingaApplication',
    'attrs'       => delete_undef_values($attrs),
    'attrs_list'  => keys($attrs),
  }

  unless empty($export) {
    @@icinga2::config::fragment { "icinga2::object::IcingaApplication::${title}":
      tag     => prefix(any2array($export), 'icinga2::instance::'),
      content => epp('icinga2/object.conf.epp', $config),
      target  => $_target,
      order   => $order,
    }
  } else {
    icinga2::object { "icinga2::object::IcingaApplication::${title}":
      ensure => $ensure,
      target => $_target,
      order  => $order,
      *      => $config,
    }
  }
}
