define icinga2::object(
  $object_name = $title,
  $templates   = [],
  $attrs       = {},
  $object_type,
) {

  file { '/tmp/test.conf':
    ensure  => file,
    content => template('icinga2/object.conf.erb'),
  }
}
