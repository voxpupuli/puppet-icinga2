# == Define: icinga2::object::servicegroup
#
# Manage Icinga2 servicegroup objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the endpoint object, absent disables it. Defaults to present.
#
# [*display_name*]
#   A short description of the service group.
#
# [*groups*]
#   An array of nested group names.
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
# === Authors
#
# Alessandro Lorenzi <alessandro@lm-net.it>
#
define icinga2::object::servicegroup (
  $ensure       = 'present',
  $display_name = $title,
  $groups       = [],
  $template     = false,
  $import       = [],
  $order        = '30',
  $target       = undef,
){
  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_array($import)
  validate_bool($template)
  validate_absolute_path($target)
  validate_string($order)

  validate_string ( $display_name )
  validate_array ( $groups )


  # compose attributes
  $attrs = {
    'display_name'  => $display_name,
    'groups'        => $groups,
  }

  # create object
  icinga2::object { "icinga2::object::ServiceGroup::${title}":
    ensure      => $ensure,
    object_name => $name,
    object_type => 'ServiceGroup',
    import      => $import,
    template    => $template,
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
