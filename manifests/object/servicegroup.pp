# @summary
#   Manage Icinga 2 servicegroup objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param servicegroup_name
#   Set the Icinga 2 name of the servicegroup object.
#
# @param display_name
#   A short description of the service group.
#
# @param groups
#   An array of nested group names.
#
# @param assign
#   Assign user group members using the group assign rules.
#
# @param ignore
#   Exclude users using the group ignore rules.
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
# @param [Variant[String, Integer]] order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
define icinga2::object::servicegroup (
  Stdlib::Absolutepath          $target,
  Enum['absent', 'present']     $ensure            = present,
  String                        $servicegroup_name = $title,
  Optional[String]              $display_name      = undef,
  Optional[Array]               $groups            = undef,
  Array                         $assign            = [],
  Array                         $ignore            = [],
  Boolean                       $template          = false,
  Array                         $import            = [],
  Variant[String, Integer]      $order             = 65,
){

  # compose attributes
  $attrs = {
    'display_name'  => $display_name,
    'groups'        => $groups,
  }

  # create object
  icinga2::object { "icinga2::object::ServiceGroup::${title}":
    ensure      => $ensure,
    object_name => $servicegroup_name,
    object_type => 'ServiceGroup',
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
