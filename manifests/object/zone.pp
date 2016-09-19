define icinga2::object::zone(
  $zone      = $title,
  $endpoints = [],
  $parent    = undef,
  $global    = false,
  $target    = undef,
  $order     = '20',
) {

  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_string($zone)
  validate_integer($order)

  if $endpoints { validate_array($endpoints) }
  if $parent { validate_string($parent) }
  if $global { validate_bool($global) }

  # set defaults and validate
  if $target {
    validate_absolute_path($target)
    $_target = $target }
  else {
    $_target = "${conf_dir}/zones.conf" }

  # compose the attributes
  if $global {
    $attrs = {
      global    => $global,
    }
  } else {
    $attrs = {
      endpoints => $endpoints,
      parent    => $parent,
    }
  }

  # create object
  icinga2::object { "zone::${title}":
    object_name => $zone,
    object_type => 'Zone',
    attrs       => $attrs,
    target      => $_target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
