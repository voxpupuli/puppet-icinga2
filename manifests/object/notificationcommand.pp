# @summary
#   Manage Icinga 2 notificationcommand objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param notificationcommand_name
#   Set the Icinga 2 name of the notificationcommand object.
#
# @param command
#   The command. This can either be an array of individual command arguments.
#   Alternatively a string can be specified in which case the shell interpreter
#   (usually /bin/sh) takes care of parsing the command.
#
# @param env
#   A dictionary of macros which should be exported as environment variables
#   prior to executing the command.
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
# @param template
#   Set to true creates a template instead of an object.
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
define icinga2::object::notificationcommand (
  Stdlib::Absolutepath                 $target,
  Enum['absent', 'present']            $ensure                   = present,
  String                               $notificationcommand_name = $title,
  Optional[Variant[Array, String]]     $command                  = undef,
  Optional[Hash]                       $env                      = undef,
  Optional[Icinga2::CustomAttributes]  $vars                     = undef,
  Optional[Icinga2::Interval]          $timeout                  = undef,
  Optional[Hash]                       $arguments                = undef,
  Boolean                              $template                 = false,
  Array                                $import                   = [],
  Variant[String, Integer]             $order                    = 25,
){

  # compose attributes
  $attrs = {
    'command'   => $command,
    'env'       => $env,
    'timeout'   => $timeout,
    'arguments' => $arguments,
    'vars'      => $vars,
  }

  # create object
  icinga2::object { "icinga2::object::NotificationCommand::${title}":
    ensure      => $ensure,
    object_name => $notificationcommand_name,
    object_type => 'NotificationCommand',
    template    => $template,
    import      => $import,
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $target,
    order       => $order,
  }

}
