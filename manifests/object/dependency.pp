# == Define: icinga2::object::dependency
#
# Manage Icinga2 dependency objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*parent_host_name*]
#   The parent host.
#
# [*parent_service_name*]
#   The parent service. If omitted, this dependency object is treated as host
#   dependency.
#
# [*child_host_name*]
#   The child host.
#
# [*child_service_name*]
#   The child service. If omitted, this dependency object is treated as host
#   dependency.
#
# [*disable_checks*]
#   Whether to disable checks when this dependency fails. Defaults to false.
#
# [*disable_notifications*]
#   Whether to disable notifications when this dependency fails. Defaults to
#   true.
#
# [*ignore_soft_states*]
#   Whether to ignore soft states for the reachability calculation. Defaults to
#   true.
#
# [*period*]
#   Time period during which this dependency is enabled.
#
# [*states*]
#   A list of state filters when this dependency should be OK. Defaults to [ OK,
#   Warning ] for services and [ Up ] for hosts.
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
#   String to set the position in the target file, sorted alpha numeric. Defaults to 35.
#
# === Authors
#
# Alessandro Lorenzi <alessandro@lm-net.it>
# Icinga Development Team <info@icinga.org>
#
define icinga2::object::dependency (
  $ensure                 = present,
  $parent_host_name       = undef,
  $parent_service_name    = undef,
  $child_host_name        = undef,
  $child_service_name     = undef,
  $disable_checks         = undef,
  $disable_notifications  = undef,
  $ignore_soft_states     = undef,
  $period                 = undef,
  $states                 = undef,
  $import                 = [],
  $template               = false,
  $target                 = undef,
  $order                  = '35',
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

  validate_string ( $parent_host_name )
  if $parent_service_name { validate_string ( $parent_service_name ) }
  validate_string ( $child_host_name )
  if $child_service_name { validate_string ( $child_service_name ) }
  if $disable_checks { validate_bool ( $disable_checks ) }
  if $disable_notifications { validate_bool ( $disable_notifications ) }
  if $ignore_soft_states { validate_bool ( $ignore_soft_states ) }
  if $period { validate_string ( $period ) }
  if $states { validate_array ( $states ) }

  # compose attributes
  $attrs = {
    'parent_host_name' => $parent_host_name,
    'parent_service_name' => $parent_service_name,
    'child_host_name' => $child_host_name,
    'child_service_name' => $child_service_name,
    'disable_checks' => $disable_checks,
    'disable_notifications' => $disable_notifications,
    'ignore_soft_states' => $ignore_soft_states,
    'period' => $period,
    'states' => $states,
  }

  # create object
  icinga2::object { "icinga2::object::Dependency::${title}":
    ensure      => $ensure,
    object_name => $name,
    object_type => 'Dependency',
    import      => $import,
    template    => $template,
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
