# @summary
#   Manage Icinga 2 Host objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param checkcommand_name
#   Title of the CheckCommand object.
#
# @param import
#   Sorted List of templates to include.
#
# @param command
#   The command. This can either be an array of individual command arguments.
#   Alternatively a string can be specified in which case the shell interpreter (usually /bin/sh) takes care of parsing the command.
#   When using the "arguments" attribute this must be an array. Can be specified as function for advanced implementations.
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
# @param template
#   Set to true creates a template instead of an object.
#
# @param order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
#
define icinga2::object::checkcommand(
  Stdlib::Absolutepath                $target,
  Enum['absent', 'present']           $ensure            = present,
  String                              $checkcommand_name = $title,
  Array                               $import            = [],
  Optional[Variant[Array, String]]    $command           = undef,
  Optional[Hash]                      $env               = undef,
  Optional[Icinga2::CustomAttributes] $vars              = undef,
  Optional[Icinga2::Interval]         $timeout           = undef,
  Optional[Variant[Hash, String]]     $arguments         = undef,
  Boolean                             $template          = false,
  Variant[String, Integer]            $order             = 15,
) {

  # compose the attributes
  $attrs = {
    command   => $command,
    env       => $env,
    timeout   => $timeout,
    arguments => $arguments,
    vars      => $vars,
  }

  # create object
  icinga2::object { "icinga2::object::CheckCommand::${title}":
    ensure      => $ensure,
    object_name => $checkcommand_name,
    object_type => 'CheckCommand',
    template    => $template,
    import      => $import,
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $target,
    order       => $order,
  }
}
