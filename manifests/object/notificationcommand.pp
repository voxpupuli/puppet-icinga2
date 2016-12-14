# == Define: icinga2::object::notificationcommand
#
# Manage Icinga2 notificationcommand objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*execute*]
# 	 The "execute" script method takes care of executing the notification.
#    The default template "plugin-notification-command" which is imported into
#    all CheckCommand objects takes care of this setting.
#
# [*command*]
# 	 The command. This can either be an array of individual command arguments.
#    Alternatively a string can be specified in which case the shell interpreter
#    (usually /bin/sh) takes care of parsing the command.
#
# [*env*]
# 	 A dictionary of macros which should be exported as environment variables
#    prior to executing the command.
#
# [*vars*]
# 	 A dictionary containing custom attributes that are specific to this command.
#
# [*timeout*]
# 	 The command timeout in seconds. Defaults to 60 seconds.
#
# [*arguments*]
# 	 A dictionary of command arguments.
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
# Icinga Development Team <info@icinga.com>
#
define icinga2::object::notificationcommand (
  $ensure     = present,
  $command    = undef,
  $env        = undef,
  $vars       = undef,
  $timeout    = undef,
  $arguments  = undef,
  $template   = false,
  $import     = ['plugin-notification-command'],
  $order      = '10',
  $target     = undef,
){
  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_array($import)
  validate_bool($template)
  validate_absolute_path($target)
  validate_string($order)

  validate_array($command)
  if $env { validate_hash ($env) }
  if $vars { validate_hash ($vars) }
  if $timeout { validate_integer ($timeout) }
  if $arguments { validate_hash ($arguments) }

  # compose attributes
  $attrs = {
    'command' => $command,
    'env' => $env,
    'vars' => $vars,
    'timeout' => $timeout,
    'arguments' => $arguments,
  }

  # create object
  icinga2::object { "icinga2::object::NotificationCommand::${title}":
    ensure      => $ensure,
    object_name => $name,
    object_type => 'NotificationCommand',
    template    => $template,
    import      => $import,
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
