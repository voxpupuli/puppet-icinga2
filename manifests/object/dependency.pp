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
# @param redundancy_group
#   The redundancy group - puts the dependency into a group of mutually redundant ones.
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
# @param export
#   Export object to destination, collected by class `icinga2::query_objects`.
#
define icinga2::object::dependency (
  Stdlib::Absolutepath                 $target,
  Enum['absent', 'present']            $ensure                = present,
  String[1]                            $dependency_name       = $title,
  Optional[String[1]]                  $parent_host_name      = undef,
  Optional[String[1]]                  $parent_service_name   = undef,
  Optional[String[1]]                  $child_host_name       = undef,
  Optional[String[1]]                  $child_service_name    = undef,
  Optional[String[1]]                  $redundancy_group      = undef,
  Optional[Boolean]                    $disable_checks        = undef,
  Optional[Boolean]                    $disable_notifications = undef,
  Optional[Boolean]                    $ignore_soft_states    = undef,
  Optional[String[1]]                  $period                = undef,
  Optional[Array]                      $states                = undef,
  Variant[Boolean, String[1]]          $apply                 = false,
  Variant[Boolean, String[1]]          $prefix                = false,
  Enum['Host', 'Service']              $apply_target          = 'Host',
  Array[String[1]]                     $assign                = [],
  Array[String[1]]                     $ignore                = [],
  Array[String[1]]                     $import                = [],
  Boolean                              $template              = false,
  Variant[String[1], Integer[0]]       $order                 = 70,
  Variant[Array[String[1]], String[1]] $export                = [],
) {
  require icinga2::globals

  # compose attributes
  $attrs = {
    'parent_host_name'      => $parent_host_name,
    'parent_service_name'   => $parent_service_name,
    'child_host_name'       => $child_host_name,
    'child_service_name'    => $child_service_name,
    'redundancy_group'      => $redundancy_group,
    'disable_checks'        => $disable_checks,
    'disable_notifications' => $disable_notifications,
    'ignore_soft_states'    => $ignore_soft_states,
    'period'                => $period,
    'states'                => $states,
  }

  # create object
  $config = {
    'object_name'  => $dependency_name,
    'object_type'  => 'Dependency',
    'import'       => $import,
    'template'     => $template,
    'attrs'        => delete_undef_values($attrs),
    'attrs_list'   => keys($attrs),
    'apply'        => $apply,
    'prefix'       => $prefix,
    'apply_target' => $apply_target,
    'assign'       => $assign,
    'ignore'       => $ignore,
  }

  unless empty($export) {
    @@icinga2::config::fragment { "icinga2::object::Dependency::${title}":
      tag     => prefix(any2array($export), 'icinga2::instance::'),
      content => epp('icinga2/object.conf.epp', $config),
      target  => $target,
      order   => $order,
    }
  } else {
    icinga2::object { "icinga2::object::Dependency::${title}":
      ensure => $ensure,
      target => $target,
      order  => $order,
      *      => $config,
    }
  }
}
