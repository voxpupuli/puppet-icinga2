# @summary
#   Manage Icinga 2 EventCommand objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param eventcommand_name
#   Set the Icinga 2 name of the eventcommand object.
#
# @param command
#   The command. This can either be an array of individual command arguments.
#   Alternatively a string can be specified in which case the shell interpreter (usually /bin/sh)
#   takes care of parsing the command.
#
# @param env
#   A dictionary of macros which should be exported as environment variables prior to executing the command.
#
# @param vars
#   A dictionary containing custom attributes that are specific to this service,
#   a string to do operations on this dictionary or an array for multiple use
#   of custom attributes.
#
# @param timeout
#   The command timeout in seconds.
#
# @param arguments
#   A dictionary of command arguments.
#
# @param target
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# @param import
#   Sorted List of templates to include.
#
# @param order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
define icinga2::object::eventcommand (
  Stdlib::Absolutepath                $target,
  Enum['absent', 'present']           $ensure            = present,
  String                              $eventcommand_name = $title,
  Optional[Variant[Array, String]]    $command           = undef,
  Optional[Hash]                      $env               = undef,
  Optional[Icinga2::CustomAttributes] $vars              = undef,
  Optional[Icinga2::Interval]         $timeout           = undef,
  Optional[Hash]                      $arguments         = undef,
  Array                               $import            = [],
  Variant[String, Integer]            $order             = 20,
){

  # compose the attributes
  $attrs = {
    'command'   => $command,
    'env'       => $env,
    'timeout'   => $timeout,
    'arguments' => $arguments,
    'vars'      => $vars,
  }

  # create object
  icinga2::object { "icinga2::object::EventCommand::${title}":
    ensure      => $ensure,
    object_name => $eventcommand_name,
    object_type => 'EventCommand',
    import      => $import,
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $target,
    order       => $order,
  }
}
