# @summary
#   Manage Icinga 2 usergroup objects.
#
# @param [Enum['absent', 'present']] ensure
#   Set to present enables the object, absent disables it.
#
# @param [String] usergroup_name
#   Set the Icinga 2 name of the usergroup object.
#
# @param [Optional[String]] display_name
#   A short description of the service group.
#
# @param [Array] groups
#   An array of nested group names.
#
# @param [Array] assign
#   Assign user group members using the group assign rules.
#
# @param [Array] ignore
#   Exclude users using the group ignore rules.
#
# @param [Boolean] template
#   Set to true creates a template instead of an object.
#
# @param [Array] import
#   Sorted List of templates to include.
#
# @param [Stdlib::Absolutepath] target
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# @param [Variant[String, Integer]] order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
define icinga2::object::usergroup (
  Stdlib::Absolutepath        $target,
  Enum['absent', 'present']   $ensure         = present,
  String                      $usergroup_name = $title,
  Optional[String]            $display_name   = undef,
  Array                       $groups         = [],
  Array                       $assign         = [],
  Array                       $ignore         = [],
  Array                       $import         = [],
  Boolean                     $template       = false,
  Variant[String, Integer]    $order          = 80,
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
  }

}
