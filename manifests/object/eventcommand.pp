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
# @param export
#   Export object to destination, collected by class `icinga2::query_objects`.
#
define icinga2::object::eventcommand (
  Stdlib::Absolutepath                  $target,
  Enum['absent', 'present']             $ensure            = present,
  String[1]                             $eventcommand_name = $title,
  Optional[Variant[Array, String]]      $command           = undef,
  Optional[Hash]                        $env               = undef,
  Optional[Icinga2::CustomAttributes]   $vars              = undef,
  Optional[Icinga2::Interval]           $timeout           = undef,
  Optional[Variant[Hash, String]]       $arguments         = undef,
  Array[String[1]]                      $import            = [],
  Variant[String[1], Integer[0]]        $order             = 20,
  Variant[Array[String[1]], String[1]]  $export            = [],
) {
  require icinga2::globals

  # compose the attributes
  $attrs = {
    'command'   => $command,
    'env'       => $env,
    'timeout'   => $timeout,
    'arguments' => $arguments,
    'vars'      => $vars,
  }

  # create object
  $config = {
    'object_name' => $eventcommand_name,
    'object_type' => 'EventCommand',
    'import'      => $import,
    'attrs'       => delete_undef_values($attrs),
    'attrs_list'  => keys($attrs),
  }

  unless empty($export) {
    @@icinga2::config::fragment { "icinga2::object::EventCommand::${title}":
      tag     => prefix(any2array($export), 'icinga2::instance::'),
      content => epp('icinga2/object.conf.epp', $config),
      target  => $target,
      order   => $order,
    }
  } else {
    icinga2::object { "icinga2::object::EventCommand::${title}":
      ensure => $ensure,
      target => $target,
      order  => $order,
      *      => $config,
    }
  }
}
