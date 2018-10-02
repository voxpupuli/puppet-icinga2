# == Define: icinga2::object::host
#
# Manage Icinga 2 Host objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*host_name*]
#   Hostname of the Host object.
#
# [*import*]
#   Sorted List of templates to include. Defaults to an empty list.
#
# [*display_name*]
#   A short description of the host (e.g. displayed by external interfaces instead of the name if set).
#
# [*address*]
#   The host's address v4.
#
# [*address6*]
#   The host's address v6.
#
# [*vars*]
#   A dictionary containing custom attributes that are specific to this host
#   or a string to do operations on this dictionary.
#
# [*groups*]
#   A list of host groups this host belongs to.
#
# [*check_command*]
#   The name of the check command.
#
# [*max_check_attempts*]
#   The number of times a host is re-checked before changing into a hard state. Defaults to 3.
#
# [*check_period*]
#   The name of a time period which determines when this host should be checked. Not set by default.
#
# [*check_timeout*]
#    Check command timeout in seconds. Overrides the CheckCommand's timeout attribute.
#
# [*check_interval*]
#   The check interval (in seconds). This interval is used for checks when the host is in a HARD state. Defaults to 5 minutes.
#
# [*retry_interval*]
#   The retry interval (in seconds). This interval is used for checks when the host is in a SOFT state. Defaults to 1 minute.
#
# [*enable_notifications*]
#   Whether notifications are enabled. Defaults to true.
#
# [*enable_active_checks*]
#   Whether active checks are enabled. Defaults to true.
#
# [*enable_passive_checks*]
#   Whether passive checks are enabled. Defaults to true.
#
# [*enable_event_handler*]
#   Enables event handlers for this host. Defaults to true.
#
# [*enable_flapping*]
#   Whether flap detection is enabled. Defaults to false.
#
# [*enable_perfdata*]
#   Whether performance data processing is enabled. Defaults to true.
#
# [*event_command*]
#   The name of an event command that should be executed every time the host's
#   state changes or the host is in a SOFT state.
#
# [*flapping_threshold*]
#   The flapping threshold in percent when a host is considered to be flapping.
#
# [*volatile*]
#    The volatile setting enables always HARD state types if NOT-OK state changes occur.
#
# [*zone*]
#   The zone this object is a member of.
#
# [*command_endpoint*]
#   The endpoint where commands are executed on.
#
# [*notes*]
#   Notes for the host.
#
# [*notes_url*]
#   Url for notes for the host (for example, in notification commands).
#
# [*action_url*]
#   Url for actions for the host (for example, an external graphing tool).
#
# [*icon_image*]
#   Icon image for the host. Used by external interfaces only.
#
# [*icon_image_alt*]
#   Icon image description for the host. Used by external interface only.
#
# [*template*]
#   Set to true creates a template instead of an object. Defaults to false.
#
# [*target*]
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# [*order*]
#   String or integer to set the position in the target file, sorted alpha numeric. Defaults to 50.
#
#
define icinga2::object::host(
  Stdlib::Absolutepath                       $target,
  Enum['absent', 'present']                  $ensure                = present,
  String                                     $host_name             = $title,
  Array                                      $import                = [],
  Optional[String]                           $address               = undef,
  Optional[String]                           $address6              = undef,
  Optional[Variant[String, Hash]]            $vars                  = undef,
  Optional[Array]                            $groups                = undef,
  Optional[String]                           $display_name          = undef,
  Optional[String]                           $check_command         = undef,
  Optional[Integer[1]]                       $max_check_attempts    = undef,
  Optional[String]                           $check_period          = undef,
  Optional[Pattern[/^\d+\.?\d*[d|h|m|s]?$/]] $check_timeout         = undef,
  Optional[Pattern[/^\d+\.?\d*[d|h|m|s]?$/]] $check_interval        = undef,
  Optional[Pattern[/^\d+\.?\d*[d|h|m|s]?$/]] $retry_interval        = undef,
  Optional[Boolean]                          $enable_notifications  = undef,
  Optional[Boolean]                          $enable_active_checks  = undef,
  Optional[Boolean]                          $enable_passive_checks = undef,
  Optional[Boolean]                          $enable_event_handler  = undef,
  Optional[Boolean]                          $enable_flapping       = undef,
  Optional[Boolean]                          $enable_perfdata       = undef,
  Optional[String]                           $event_command         = undef,
  Optional[Integer[1]]                       $flapping_threshold    = undef,
  Optional[Boolean]                          $volatile              = undef,
  Optional[String]                           $zone                  = undef,
  Optional[String]                           $command_endpoint      = undef,
  Optional[String]                           $notes                 = undef,
  Optional[String]                           $notes_url             = undef,
  Optional[String]                           $action_url            = undef,
  Optional[Stdlib::Absolutepath]             $icon_image            = undef,
  Optional[String]                           $icon_image_alt        = undef,
  Boolean                                    $template              = false,
  Variant[String, Integer]                   $order                 = 50,
) {

  # compose the attributes
  $attrs = {
    address               => $address,
    address6              => $address6,
    groups                => $groups,
    display_name          => $display_name,
    check_command         => $check_command,
    max_check_attempts    => $max_check_attempts,
    check_period          => $check_period,
    check_timeout         => $check_timeout,
    check_interval        => $check_interval,
    retry_interval        => $retry_interval,
    enable_notifications  => $enable_notifications,
    enable_active_checks  => $enable_active_checks,
    enable_passive_checks => $enable_passive_checks,
    enable_event_handler  => $enable_event_handler,
    enable_flapping       => $enable_flapping,
    enable_perfdata       => $enable_perfdata,
    event_command         => $event_command,
    flapping_threshold    => $flapping_threshold,
    volatile              => $volatile,
    zone                  => $zone,
    command_endpoint      => $command_endpoint,
    notes                 => $notes,
    notes_url             => $notes_url,
    action_url            => $action_url,
    icon_image            => $icon_image,
    icon_image_alt        => $icon_image_alt,
    vars                  => $vars,
  }

  # create object
  icinga2::object { "icinga2::object::Host::${title}":
    ensure      => $ensure,
    object_name => $host_name,
    object_type => 'Host',
    template    => $template,
    import      => $import,
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $target,
    order       => $order,
  }
}
