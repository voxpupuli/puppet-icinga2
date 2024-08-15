# @summary
#   Manage Icinga 2 Host objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param host_name
#   Hostname of the Host object.
#
# @param import
#   Sorted List of templates to include.
#
# @param display_name
#   A short description of the host (e.g. displayed by external interfaces instead of the name if set).
#
# @param address
#   The host's address v4.
#
# @param address6
#   The host's address v6.
#
# @param vars
#   A dictionary containing custom attributes that are specific to this service,
#   a string to do operations on this dictionary or an array for multiple use
#   of custom attributes.
#
# @param groups
#   A list of host groups this host belongs to.
#
# @param check_command
#   The name of the check command.
#
# @param max_check_attempts
#   The number of times a host is re-checked before changing into a hard state.
#
# @param check_period
#   The name of a time period which determines when this host should be checked.
#
# @param check_timeout
#    Check command timeout in seconds. Overrides the CheckCommand's timeout attribute.
#
# @param check_interval
#   The check interval (in seconds). This interval is used for checks when the host is in a HARD state.
#
# @param retry_interval
#   The retry interval (in seconds). This interval is used for checks when the host is in a SOFT state.
#
# @param enable_notifications
#   Whether notifications are enabled.
#
# @param enable_active_checks
#   Whether active checks are enabled.
#
# @param enable_passive_checks
#   Whether passive checks are enabled.
#
# @param enable_event_handler
#   Enables event handlers for this host.
#
# @param enable_flapping
#   Whether flap detection is enabled.
#
# @param enable_perfdata
#   Whether performance data processing is enabled.
#
# @param event_command
#   The name of an event command that should be executed every time the host's
#   state changes or the host is in a SOFT state.
#
# @param flapping_threshold_low
#   Flapping lower bound in percent for a host to be considered not flapping.
#
# @param flapping_threshold_high
#   Flapping upper bound in percent for a host to be considered flapping.
#
# @param volatile
#   The volatile setting enables always HARD state types if NOT-OK state changes occur.
#
# @param zone
#   The zone this object is a member of.
#
# @param command_endpoint
#   The endpoint where commands are executed on.
#
# @param notes
#   Notes for the host.
#
# @param notes_url
#   Url for notes for the host (for example, in notification commands).
#
# @param action_url
#   Url for actions for the host (for example, an external graphing tool).
#
# @param icon_image
#   Icon image for the host. Used by external interfaces only.
#
# @param icon_image_alt
#   Icon image description for the host. Used by external interface only.
#
# @param template
#   Set to true creates a template instead of an object.
#
# @param target
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# @param order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
# @param export
#   Export object to destination, collected by class `icinga2::query_objects`.
#
define icinga2::object::host (
  Stdlib::Absolutepath                 $target,
  Enum['absent', 'present']            $ensure                  = present,
  String[1]                            $host_name               = $title,
  Array[String[1]]                     $import                  = [],
  Optional[Stdlib::Host]               $address                 = undef,
  Optional[Stdlib::Host]               $address6                = undef,
  Optional[Icinga2::CustomAttributes]  $vars                    = undef,
  Optional[Array[String[1]]]           $groups                  = undef,
  Optional[String[1]]                  $display_name            = undef,
  Optional[String[1]]                  $check_command           = undef,
  Optional[Integer[1]]                 $max_check_attempts      = undef,
  Optional[String[1]]                  $check_period            = undef,
  Optional[Icinga2::Interval]          $check_timeout           = undef,
  Optional[Icinga2::Interval]          $check_interval          = undef,
  Optional[Icinga2::Interval]          $retry_interval          = undef,
  Optional[Boolean]                    $enable_notifications    = undef,
  Optional[Boolean]                    $enable_active_checks    = undef,
  Optional[Boolean]                    $enable_passive_checks   = undef,
  Optional[Boolean]                    $enable_event_handler    = undef,
  Optional[Boolean]                    $enable_flapping         = undef,
  Optional[Boolean]                    $enable_perfdata         = undef,
  Optional[String[1]]                  $event_command           = undef,
  Optional[Integer[1]]                 $flapping_threshold_low  = undef,
  Optional[Integer[1]]                 $flapping_threshold_high = undef,
  Optional[Boolean]                    $volatile                = undef,
  Optional[String[1]]                  $zone                    = undef,
  Optional[String[1]]                  $command_endpoint        = undef,
  Optional[String[1]]                  $notes                   = undef,
  Optional[String[1]]                  $notes_url               = undef,
  Optional[String[1]]                  $action_url              = undef,
  Optional[String[1]]                  $icon_image              = undef,
  Optional[String[1]]                  $icon_image_alt          = undef,
  Boolean                              $template                = false,
  Variant[String[1], Integer[0]]       $order                   = 50,
  Variant[Array[String[1]], String[1]] $export                  = [],
) {
  require icinga2::globals

  # compose the attributes
  $attrs = {
    'address'                 => $address,
    'address6'                => $address6,
    'groups'                  => $groups,
    'display_name'            => $display_name,
    'check_command'           => $check_command,
    'max_check_attempts'      => $max_check_attempts,
    'check_period'            => $check_period,
    'check_timeout'           => $check_timeout,
    'check_interval'          => $check_interval,
    'retry_interval'          => $retry_interval,
    'enable_notifications'    => $enable_notifications,
    'enable_active_checks'    => $enable_active_checks,
    'enable_passive_checks'   => $enable_passive_checks,
    'enable_event_handler'    => $enable_event_handler,
    'enable_flapping'         => $enable_flapping,
    'enable_perfdata'         => $enable_perfdata,
    'event_command'           => $event_command,
    'flapping_threshold_low'  => $flapping_threshold_low,
    'flapping_threshold_high' => $flapping_threshold_high,
    'volatile'                => $volatile,
    'zone'                    => $zone,
    'command_endpoint'        => $command_endpoint,
    'notes'                   => $notes,
    'notes_url'               => $notes_url,
    'action_url'              => $action_url,
    'icon_image'              => $icon_image,
    'icon_image_alt'          => $icon_image_alt,
    'vars'                    => $vars,
  }

  # create object
  $config = {
    'object_name' => $host_name,
    'object_type' => 'Host',
    'template'    => $template,
    'import'      => $import,
    'attrs'       => delete_undef_values($attrs),
    'attrs_list'  => keys($attrs),
  }

  unless empty($export) {
    @@icinga2::config::fragment { "icinga2::object::Host::${title}":
      tag     => prefix(any2array($export), 'icinga2::instance::'),
      content => epp('icinga2/object.conf.epp', $config),
      target  => $target,
      order   => $order,
    }
  } else {
    icinga2::object { "icinga2::object::Host::${title}":
      ensure => $ensure,
      target => $target,
      order  => $order,
      *      => $config,
    }
  }
}
