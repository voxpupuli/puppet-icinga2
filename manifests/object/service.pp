# @summary
#   Manage Icinga 2 service objects.
#
# @example A service `ping` is applied to all hosts with a valid ipv4 address.
#   ::icinga2::object::service { 'ping4':
#     import        => ['generic-service'],
#     apply         => true,
#     check_command => 'ping',
#     assign        => ['host.address'],
#     target        => '/etc/icinga2/zones.d/global-templates/services.conf',
#   }
#
# @example A `apply Service for (disk_name =>config in host.vars.disks)` rule is applied to all Linux hosts with an Icinga Agent. Note in this example it's required that the endpoint (see `command_endpoint`) and the host object has the same name!
#   ::icinga2::object::service { 'linux_disks':
#     import           => ['generic-service'],
#     apply            =>  'disk_name => config in host.vars.disks',
#     check_command    => 'disk',
#     command_endpoint => 'host.name',
#     vars             => '+ config',
#     assign           => ['host.vars.os == Linux'],
#     ignore           => ['host.vars.noagent'],
#     target           => '/etc/icinga2/zones.d/global-templates/services.conf',
#   }
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param service_name
#   Set the Icinga 2 name of the service object.
#
# @param display_name
#   A short description of the service.
#
# @param host_name
#   The host this service belongs to. There must be a Host object with
#   that name.
#
# @param groups
#   The service groups this service belongs to.
#
# @param vars
#   A dictionary containing custom attributes that are specific to this service,
#   a string to do operations on this dictionary or an array for multiple use
#   of custom attributes.
#
# @param check_command
#   The name of the check command.
#
# @param max_check_attempts
#   The number of times a service is re-checked before changing into a hard
#   state.
#
# @param check_period
#   The name of a time period which determines when this service should be
#   checked.
#
# @param check_timeout
#   Check command timeout in seconds. Overrides the CheckCommand's timeout
#   attribute.
#
# @param check_interval
#   The check interval (in seconds). This interval is used for checks when the
#   service is in a HARD state.
#
# @param retry_interval
#   The retry interval (in seconds). This interval is used for checks when the
#   service is in a SOFT state.
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
#   The name of an event command that should be executed every time the
#   service's state changes or the service is in a SOFT state.
#
# @param flapping_threshold_low
#   Flapping lower bound in percent for a host to be considered not flapping.
#
# @param flapping_threshold_high
#   Flapping upper bound in percent for a host to be considered flapping.
#
# @param volatile
#   The volatile setting enables always HARD state types if NOT-OK state changes
#   occur.
#
# @param zone
#   The zone this object is a member of.
#
# @param command_endpoint
#   The endpoint where commands are executed on.
#
# @param notes
#   Notes for the service.
#
# @param notes_url
#   Url for notes for the service (for example, in notification commands).
#
# @param action_url
#   Url for actions for the service (for example, an external graphing tool).
#
# @param icon_image
#   Icon image for the service. Used by external interfaces only.
#
# @param icon_image_alt
#   Icon image description for the service. Used by external interface only.
#
# @param template
#   Set to true creates a template instead of an object.
#
# @param apply
#   Dispose an apply instead an object if set to 'true'. Value is taken as statement,
#   i.e. 'vhost => config in host.vars.vhosts'.
#
# @param prefix
#   Set service_name as prefix in front of 'apply for'. Only effects if apply is a string.
#
# @param assign
#   Assign user group members using the group assign rules.
#
# @param ignore
#   Exclude users using the group ignore rules.
#
# @param import
#   Sorted List of templates to include.
#
# @param target
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# @param order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
define icinga2::object::service (
  Stdlib::Absolutepath                       $target,
  Enum['absent', 'present']                  $ensure                  = present,
  String                                     $service_name            = $title,
  Optional[String]                           $display_name            = undef,
  Optional[String]                           $host_name               = undef,
  Optional[Array]                            $groups                  = undef,
  Optional[Icinga2::CustomAttributes]        $vars                    = undef,
  Optional[String]                           $check_command           = undef,
  Optional[Integer[1]]                       $max_check_attempts      = undef,
  Optional[String]                           $check_period            = undef,
  Optional[Icinga2::Interval]                $check_timeout           = undef,
  Optional[Icinga2::Interval]                $check_interval          = undef,
  Optional[Icinga2::Interval]                $retry_interval          = undef,
  Optional[Boolean]                          $enable_notifications    = undef,
  Optional[Boolean]                          $enable_active_checks    = undef,
  Optional[Boolean]                          $enable_passive_checks   = undef,
  Optional[Boolean]                          $enable_event_handler    = undef,
  Optional[Boolean]                          $enable_flapping         = undef,
  Optional[Boolean]                          $enable_perfdata         = undef,
  Optional[String]                           $event_command           = undef,
  Optional[Integer[1]]                       $flapping_threshold_low  = undef,
  Optional[Integer[1]]                       $flapping_threshold_high = undef,
  Optional[Boolean]                          $volatile                = undef,
  Optional[String]                           $zone                    = undef,
  Optional[String]                           $command_endpoint        = undef,
  Optional[String]                           $notes                   = undef,
  Optional[String]                           $notes_url               = undef,
  Optional[String]                           $action_url              = undef,
  Optional[String]                           $icon_image              = undef,
  Optional[String]                           $icon_image_alt          = undef,
  Variant[Boolean, String]                   $apply                   = false,
  Variant[Boolean, String]                   $prefix                  = false,
  Array                                      $assign                  = [],
  Array                                      $ignore                  = [],
  Array                                      $import                  = [],
  Boolean                                    $template                = false,
  Variant[String, Integer]                   $order                   = 60,
) {

  # compose the attributes
  $attrs = {
    'display_name'            => $display_name,
    'host_name'               => $host_name,
    'check_command'           => $check_command,
    'check_timeout'           => $check_timeout,
    'check_interval'          => $check_interval,
    'check_period'            => $check_period,
    'retry_interval'          => $retry_interval,
    'max_check_attempts'      => $max_check_attempts,
    'groups'                  => $groups,
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
  icinga2::object { "icinga2::object::Service::${title}":
    ensure      => $ensure,
    object_name => $service_name,
    object_type => 'Service',
    import      => $import,
    apply       => $apply,
    prefix      => $prefix,
    assign      => $assign,
    ignore      => $ignore,
    template    => $template,
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $target,
    order       => $order,
  }
}
