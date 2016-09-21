# == Define: icinga2::object
#
# Private define resource to used by this module only.
#
# === Parameters
#
# [*object_name*]
#   Set the icinga2 name of the object. Defaults to title of the define resource.
#
# [*template*]
#   Set to true will define a template otherwise an object. Defaults to false.
#
# [*import*]
#   A sorted list of templates to import in this object. Defaults to an empty array.
#
# [*attrs*]
#   Hash for the attributes of this object. Keys are the attributes and
#   values are there values. Defaults to an empty Hash.
#
# [*object_type*]
#   Icinga2 object type for this object.
#
# [*target*]
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# [*order*]
#   String to set the position in the target file, sorted alpha numeric.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
define icinga2::object(
  $object_name = $title,
  $template    = false,
  $import      = [],
  $attrs       = {},
  $object_type,
  $target,
  $order,
) {

  if defined($caller_module_name) and $module_name != $caller_module_name {
    fail("icinga2::object is a private define resource of the module icinga2, you're not permitted to use it.")
  }

  include ::icinga2::params

  $user     = $::icinga2::params::user
  $group    = $::icinga2::params::group

  validate_string($object_name)
  validate_bool($template)
  validate_array($import)
  validate_hash($attrs)
  validate_string($object_type)
  validate_absolute_path($target)
  validate_string($order)

  ensure_resource('concat', $target, {
    ensure => present,
    owner  => $user,
    group  => $group,
    tag    => 'icinga2::config::file',
  })

  concat::fragment { "icinga2::object::${object_type}::${object_name}":
    target  => $target,
    content => template('icinga2/object.conf.erb'),
    order   => $order,
  }
}
