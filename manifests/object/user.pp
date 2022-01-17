# @summary
#   Manage Icinga 2 user objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param user_name
#   Set the Icinga 2 name of the user object.
#
# @param display_name
#   A short description of the user.
#
# @param email
#   An email string for this user. Useful for notification commands.
#
# @param pager
#   A pager string for this user. Useful for notification commands.
#
# @param vars
#   A dictionary containing custom attributes that are specific to this service,
#   a string to do operations on this dictionary or an array for multiple use
#   of custom attributes.
#
# @param groups
#   An array of group names.
#
# @param enable_notifications
#   Whether notifications are enabled for this user.
#
# @param period
#   The name of a time period which determines when a notification for this user
#   should be triggered.
#
# @param types
#   A set of type filters when this notification should be triggered.
#   everything is matched.
#
# @param states
#   A set of state filters when this notification should be triggered.
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
define icinga2::object::user (
  Stdlib::Absolutepath                $target,
  Enum['absent', 'present']           $ensure               = present,
  String                              $user_name            = $title,
  Optional[String]                    $display_name         = undef,
  Optional[String]                    $email                = undef,
  Optional[String]                    $pager                = undef,
  Optional[Icinga2::CustomAttributes] $vars                 = undef,
  Optional[Array]                     $groups               = undef,
  Optional[Boolean]                   $enable_notifications = undef,
  Optional[String]                    $period               = undef,
  Optional[Array]                     $types                = undef,
  Optional[Array]                     $states               = undef,
  Array                               $import               = [],
  Boolean                             $template             = false,
  Variant[String, Integer]            $order                = 75,
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
  }

}
