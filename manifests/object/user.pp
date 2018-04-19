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
  Stdlib::Absolutepath      $target,
  Enum['absent', 'present'] $ensure               = present,
  String                    $user_name            = $title,
  Optional[String]          $display_name         = undef,
  Optional[String]          $email                = undef,
  Optional[String]          $pager                = undef,
  Optional[Hash]            $vars                 = undef,
  Optional[Array]           $groups               = undef,
  Optional[Boolean]         $enable_notifications = undef,
  Optional[String]          $period               = undef,
  Optional[Array]           $types                = undef,
  Optional[Array]           $states               = undef,
  Array                     $import               = [],
  Boolean                   $template             = false,
  Pattern[/^\d+$/]          $order                = '75',
){

  # compose attributes
  $attrs = {
    'display_name'         => $display_name,
    'email'                => $email,
    'pager'                => $pager,
    'groups'               => $groups,
    'enable_notifications' => $enable_notifications,
    'period'               => $period,
    'types'                => $types,
    'states'               => $states,
    'vars'                 => $vars,
  }

  # create object
  icinga2::object { "icinga2::object::User::${title}":
    ensure      => $ensure,
    object_name => $user_name,
    object_type => 'User',
    template    => $template,
    import      => $import,
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
