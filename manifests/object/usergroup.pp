# == Define: icinga2::object::usergroup
#
# Manage Icinga 2 usergroup objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*usergroup_name*]
#   Set the Icinga 2 name of the usergroup object. Defaults to title of the define resource.
#
# [*display_name*]
#   A short description of the service group.
#
# [*groups*]
#   An array of nested group names.
#
# [*assign*]
#   Assign user group members using the group assign rules.
#
# [*ignore*]
#   Exclude users using the group ignore rules.
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
#
define icinga2::object::usergroup (
  Stdlib::Absolutepath      $target,
  Enum['absent', 'present'] $ensure         = present,
  String                    $usergroup_name = $title,
  Optional[String]          $display_name   = undef,
  Array                     $groups         = [],
  Array                     $assign         = [],
  Array                     $ignore         = [],
  Array                     $import         = [],
  Boolean                   $template       = false,
  Pattern[/^\d+$/]          $order          = '80',
){

  if $ignore != [] and $assign == [] {
    fail('When attribute ignore is used, assign must be set.')
  }

  # compose attributes
  $attrs = {
    'display_name'  => $display_name,
    'groups'        => $groups,
  }

  # create object
  icinga2::object { "icinga2::object::UserGroup::${title}":
    ensure      => $ensure,
    object_name => $usergroup_name,
    object_type => 'UserGroup',
    import      => $import,
    template    => $template,
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    assign      => $assign,
    ignore      => $ignore,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
