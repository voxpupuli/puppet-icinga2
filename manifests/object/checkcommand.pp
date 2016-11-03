# == Define: icinga2::object::checkcommand
#
# Manage Icinga2 checkcommand objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the endpoint object, absent disabled it. Defaults to present.
#
# [*execute*]
#   The "execute" script method takes care of executing the check. The default
#   template "plugin-check-command" which is imported into all CheckCommand
#   objects takes care of this setting.
#
# [*command*]
#   The command. This can either be an array of individual command arguments.
#   Alternatively a string can be specified in which case the shell interpreter
#   (usually /bin/sh) takes care of parsing the command. When using the
#   "arguments" attribute this must be an array. Can be specified as function
#   for advanced implementations.
#
# [*env*]
#   A dictionary of macros which should be exported as environment variables
#   prior to executing the command.
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
# [*template*]
#   Set to true creates a template instead of an object. Defaults to false.
#
# [*import*]
#   Sorted List of templates to include. Defaults to an empty list.
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
# Alessandro Lorenzi <alessandro@lm-net.it>
#
define icinga2::object::checkcommand (
  $ensure     = 'present',
  $execute    = undef,
  $command    = undef,
  $env        = undef,
  $vars       = undef,
  $timeout    = undef,
  $arguments  = undef,
  $import     = [],
  $template   = false,
  $target     = undef,
  $order      = '10',
){
  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir
  if $target {
    validate_absolute_path( $target )
    $_target = $target }
  else {
    $_target = "${conf_dir}/repository.d/checkcommands.conf"
  }

  # validation
  validate_array($import)
  validate_bool($template)
  validate_absolute_path($_target)
  validate_string($order)

  validate_string ($execute)
  validate_string ($command)
  if $env { validate_string ($env) }
  if $vars { validate_string ($vars) }
  if $timeout { validate_string ($timeout) }
  if $arguments { validate_string ($arguments) }

  # compose attributes
  $attrs = {
    'execute'   => $execute,
    'command'   => $command,
    'env'       => $env,
    'vars'      => $vars,
    'timeout'   => $timeout,
    'arguments' => $arguments,
  }

  # create object
  icinga2::object { "icinga2::object::CheckCommand::${title}":
    ensure      => $ensure,
    object_name => $name,
    object_type => 'CheckCommand',
    template    => $template,
    import      => $import,
    attrs       => $attrs,
    target      => $_target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
