# == Define: icinga2::object::zone
#
# Manage Icinga2 zone objects.
#
# === Parameters
#
# [*zone*]
#   Set the Icinga2 name of the zone object. Defaults to title of the define resource.
#
# [*endpoints*]
#   List of endpoints belong to this zone.
#
# [*parent*]
#   Parent zone to this zone.
#
# [*global*]
#   If set to true, a global zone is defined and the parameter endpoints
#   and parent are ignored. Defaults to false.
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
  icinga2::object { "icinga2::object::Zone::${title}":
    object_name => $zone,
    object_type => 'Zone',
    attrs       => $attrs,
    target      => $_target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
