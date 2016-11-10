# == Define: icinga2::object::checkcommand
#
# Manage Icinga2 Host objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*checkcommand*]
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
#   A dictionary containing custom attributes that are specific to this command.
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
#   String to set the position in the target file, sorted alpha numeric. Defaults to 10.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
define icinga2::object::checkcommand(
  $ensure       = present,
  $checkcommand = $title,
  $import       = ['plugin-check-command'],
  $command      = undef,
  $env          = undef,
  $vars         = undef,
  $timeout      = undef,
  $arguments    = undef,
  $template     = false,
  $order        = '10',
  $target,
) {

  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_array($import)
  validate_absolute_path($target)
  validate_integer($order)

  if $checkcommand { validate_string($checkcommand) }
  if $command { validate_array($command) }
  if $env { validate_hash($env) }
  if $vars { validate_hash($vars) }
  if $timeout { validate_integer($timeout) }
  if $arguments { validate_hash($arguments) }

  # compose the attributes
  $attrs = {
    command   => $command,
    env       => $env,
    vars      => $vars,
    timeout   => $timeout,
    arguments => $arguments,
  }

  # create object
  icinga2::object { "icinga2::object::Host::${title}":
    ensure      => $ensure,
    object_name => $checkcommand,
    object_type => 'CheckCommand',
    template    => $template,
    import      => $import,
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
