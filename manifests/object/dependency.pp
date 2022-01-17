# @summary
#   Manage Icinga 2 dependency objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param dependency_name
#   Set the Icinga 2 name of the dependency object.
#
# @param parent_host_name
#   The parent host.
#
# @param parent_service_name
#   The parent service. If omitted, this dependency object is treated as host
#   dependency.
#
# @param child_host_name
#   The child host.
#
# @param child_service_name
#   The child service. If omitted, this dependency object is treated as host
#   dependency.
#
# @param disable_checks
#   Whether to disable checks when this dependency fails.
#
# @param disable_notifications
#   Whether to disable notifications when this dependency fails.
#   true.
#
# @param ignore_soft_states
#   Whether to ignore soft states for the reachability calculation.
#   true.
#
# @param period
#   Time period during which this dependency is enabled.
#
# @param states
#   A list of state filters when this dependency should be OK.
#
# @param apply
#   Dispose an apply instead an object if set to 'true'. Value is taken as statement,
#   i.e. 'vhost => config in host.vars.vhosts'.
#
# @param prefix
#   Set dependency_name as prefix in front of 'apply for'. Only effects if apply is a string.
#
# @param apply_target
#   An object type on which to target the apply rule. Valid values are `Host`
#   and `Service`.
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
# @param order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
define icinga2::object::dependency (
  Stdlib::Absolutepath          $target,
  Enum['absent', 'present']     $ensure                = present,
  String                        $dependency_name       = $title,
  Optional[String]              $parent_host_name      = undef,
  Optional[String]              $parent_service_name   = undef,
  Optional[String]              $child_host_name       = undef,
  Optional[String]              $child_service_name    = undef,
  Optional[Boolean]             $disable_checks        = undef,
  Optional[Boolean]             $disable_notifications = undef,
  Optional[Boolean]             $ignore_soft_states    = undef,
  Optional[String]              $period                = undef,
  Optional[Array]               $states                = undef,
  Variant[Boolean, String]      $apply                 = false,
  Variant[Boolean, String]      $prefix                = false,
  Enum['Host', 'Service']       $apply_target          = 'Host',
  Array                         $assign                = [],
  Array                         $ignore                = [],
  Array                         $import                = [],
  Boolean                       $template              = false,
  Variant[String, Integer]      $order                 = 70,
){

  # compose attributes
  $attrs = {
    'parent_host_name'      => $parent_host_name,
    'parent_service_name'   => $parent_service_name,
    'child_host_name'       => $child_host_name,
    'child_service_name'    => $child_service_name,
    'disable_checks'        => $disable_checks,
    'disable_notifications' => $disable_notifications,
    'ignore_soft_states'    => $ignore_soft_states,
    'period'                => $period,
    'states'                => $states,
  }

  # create object
  icinga2::object { "icinga2::object::Dependency::${title}":
    ensure       => $ensure,
    object_name  => $dependency_name,
    object_type  => 'Dependency',
    import       => $import,
    template     => $template,
    attrs        => delete_undef_values($attrs),
    attrs_list   => keys($attrs),
    apply        => $apply,
    prefix       => $prefix,
    apply_target => $apply_target,
    assign       => $assign,
    ignore       => $ignore,
    target       => $target,
    order        => $order,
  }

}
