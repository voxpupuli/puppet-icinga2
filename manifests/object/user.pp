# == Define: icinga2::object::user
#
# Manage Icinga 2 user objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*user_name*]
#   Set the Icinga 2 name of the user object. Defaults to title of the define resource.
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
#   A dictionary containing custom attributes that are specific to this user
#   or a string to do operations on this dictionary.
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
#   String to set the position in the target file, sorted alpha numeric. Defaults to 30.
#
#
define icinga2::object::user (
  $target,
  $ensure               = present,
  $user_name            = $title,
  $display_name         = undef,
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
  $order                = '75',
){
  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_string($user_name)
  validate_bool($template)
  validate_absolute_path($target)
  validate_string($order)

  if $display_name { validate_string($display_name) }
  if $email { validate_string($email) }
  if $pager { validate_string($pager) }
  if $groups { $_groups = any2array($groups) } else { $_groups = undef }
  if $enable_notifications { validate_bool($enable_notifications) }
  if $period { validate_string($period) }
  if $types { $_types = any2array($types) } else { $_types = undef }
  if $states { $_states = any2array ($states) } else { $_states = undef }

  validate_integer ( $order )

  # compose attributes
  $attrs = {
    'display_name'         => $display_name,
    'email'                => $email,
    'pager'                => $pager,
    'vars'                 => $vars,
    'groups'               => $_groups,
    'enable_notifications' => $enable_notifications,
    'period'               => $period,
    'types'                => $_types,
    'states'               => $_states,
  }

  # create object
  icinga2::object { "icinga2::object::User::${title}":
    ensure      => $ensure,
    object_name => $user_name,
    object_type => 'User',
    template    => $template,
    import      => $import,
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
