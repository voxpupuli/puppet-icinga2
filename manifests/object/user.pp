# == Define: icinga2::object::user
#
# Manage Icinga2 user objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the endpoint object, absent disabled it. Defaults to present.
#
# [*display_name*]
#   A short description of the user.
#
# [*email*]
#   An email string for this user. Useful for notification commands.
#
# [*pager*]
#   A pager string for this user. Useful for notification commands.
#
# [*vars*]
#   A dictionary containing custom attributes that are specific to this user.
#
# [*groups*]
#   An array of group names.
#
# [*enable_notifications*]
#   Whether notifications are enabled for this user.
#
# [*period*]
#   The name of a time period which determines when a notification for this user
#   should be triggered. Not set by default.
#
# [*types*]
#   A set of type filters when this notification should be triggered. By default
#   everything is matched.
#
# [*states*]
#   A set of state filters when this notification should be triggered. By
#   default everything is matched.
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
define icinga2::object::user (
  $ensure               = 'present',
  $display_name         = $title,
  $email                = undef,
  $pager                = undef,
  $vars                 = undef,
  $groups               = undef,
  $enable_notifications = undef,
  $period               = undef,
  $types                = undef,
  $states               = undef,
  $import               = [],
  $template             = false,
  $order                = '30',
  $target               = undef,
){
  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir
  if $target {
    $_target = $target
  } else {
    $_target = "${conf_dir}/repository.d/users.conf"
  }

  # validation
  validate_array($import)
  validate_bool($template)
  validate_absolute_path($_target)
  validate_string($order)

  if $display_name { validate_string ($display_name) }
  if $email { validate_string ($email) }
  if $pager { validate_string ($pager) }
  if $vars { validate_hash ($vars) }
  if $groups { validate_array ($groups) }
  if $enable_notifications { validate_bool ($enable_notifications) }
  if $period { validate_string ($period) }
  if $types { validate_array ($types) }
  if $states { validate_array ($states) }

  validate_integer ( $order )

  # compose attributes
  $attrs = {
    'display_name' => $display_name,
    'email' => $email,
    'pager' => $pager,
    'vars' => $vars,
    'groups' => $groups,
    'enable_notifications' => $enable_notifications,
    'period' => $period,
    'types' => $types,
    'states' => $states,
  }

  # create object
  icinga2::object { "icinga2::object::User::${title}":
    ensure      => $ensure,
    object_name => $name,
    object_type => 'User',
    template    => $template,
    import      => $import,
    attrs       => $attrs,
    target      => $_target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
