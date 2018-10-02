# == Define: icinga2::object::checkcommand
#
# Manage Icinga 2 Host objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*checkcommand_name*]
#   Title of the CheckCommand object.
#
# [*import*]
#   Sorted List of templates to include. Defaults to an empty list.
#
# [*command*]
#   The command. This can either be an array of individual command arguments.
#   Alternatively a string can be specified in which case the shell interpreter (usually /bin/sh) takes care of parsing the command.
#   When using the "arguments" attribute this must be an array. Can be specified as function for advanced implementations.
#
# [*env*]
#   A dictionary of macros which should be exported as environment variables prior to executing the command.
#
# [*vars*]
#   A dictionary containing custom attributes that are specific to this command
#   or a string to do operations on this dictionary.
#
# [*timeout*]
#   The command timeout in seconds. Defaults to 60 seconds.
#
# [*arguments*]
#   A dictionary of command arguments.
#
# [*target*]
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# [*order*]
#   String or integer to set the position in the target file, sorted alpha numeric. Defaults to 10.
#
#
define icinga2::object::checkcommand(
  Stdlib::Absolutepath                $target,
  Enum['absent', 'present']           $ensure            = present,
  Optional[String]                    $checkcommand_name = $title,
  Array                               $import            = [],
  Optional[Variant[Array, String]]    $command           = undef,
  Optional[Hash]                      $env               = undef,
  Optional[Variant[String, Hash]]     $vars              = undef,
  Optional[Integer[1]]                $timeout           = undef,
  Optional[Hash]                      $arguments         = undef,
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
