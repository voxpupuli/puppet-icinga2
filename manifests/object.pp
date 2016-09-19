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

  ensure_resource('concat', $target, {
    ensure => present,
    owner  => $user,
    group  => $group,
    tag    => 'icinga2::config::file',
  })

  concat::fragment { "${object_type}::${object_name}":
    target  => $target,
    content => template('icinga2/object.conf.erb'),
    order   => $order,
  }
}
