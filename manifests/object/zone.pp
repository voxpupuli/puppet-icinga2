# == Define: icinga2::object::zone
#
# Manage Icinga 2 zone objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*zone_name*]
#   Set the Icinga 2 name of the zone object. Defaults to title of the define resource.
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
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# [*order*]
#   String to control the position in the target file, sorted alpha numeric.
#
#
define icinga2::object::zone(
  Enum['absent', 'present']      $ensure    = present,
  String                         $zone_name = $title,
  Optional[Array]                $endpoints = [],
  Optional[String]               $parent    = undef,
  Optional[Boolean]              $global    = false,
  Optional[Stdlib::Absolutepath] $target    = undef,
  Pattern[/^\d+$/]               $order     = '45',
) {

  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # set defaults
  if $target {
    $_target = $target
  } else {
    $_target = "${conf_dir}/zones.conf"
  }

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
    ensure      => $ensure,
    object_name => $zone_name,
    object_type => 'Zone',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $_target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
