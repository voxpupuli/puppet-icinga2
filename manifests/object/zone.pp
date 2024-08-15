# @summary
#   Manage Icinga 2 zone objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param zone_name
#   Set the Icinga 2 name of the zone object.
#
# @param endpoints
#   List of endpoints belong to this zone.
#
# @param parent
#   Parent zone to this zone.
#
# @param global
#   If set to true, a global zone is defined and the parameter endpoints
#   and parent are ignored.
#
# @param target
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# @param order
#   String or integer to control the position in the target file, sorted alpha numeric.
#
# @param export
#   Export object to destination, collected by class `icinga2::query_objects`.
#
define icinga2::object::zone (
  Enum['absent', 'present']            $ensure    = present,
  String[1]                            $zone_name = $title,
  Array[String[1]]                     $endpoints = [],
  Optional[String[1]]                  $parent    = undef,
  Boolean                              $global    = false,
  Optional[Stdlib::Absolutepath]       $target    = undef,
  Variant[String[1], Integer[0]]       $order     = 45,
  Variant[Array[String[1]], String[1]] $export    = [],
) {
  require icinga2::globals
  $conf_dir = $icinga2::globals::conf_dir

  # set defaults
  if $target {
    $_target = $target
  } else {
    $_target = "${conf_dir}/zones.conf"
  }

  # compose the attributes
  if $global {
    $attrs = {
      'global'    => $global,
    }
  } else {
    $attrs = {
      'endpoints' => $endpoints,
      'parent'    => $parent,
    }
  }

  # create object
  $config = {
    'object_name' => $zone_name,
    'object_type' => 'Zone',
    'attrs'       => delete_undef_values($attrs),
    'attrs_list'  => keys($attrs),
  }

  unless empty($export) {
    @@icinga2::config::fragment { "icinga2::object::Zone::${title}":
      tag     => prefix(any2array($export), 'icinga2::instance::'),
      content => epp('icinga2/object.conf.epp', $config),
      target  => $_target,
      order   => $order,
    }
  } else {
    icinga2::object { "icinga2::object::Zone::${title}":
      ensure => $ensure,
      target => $_target,
      order  => $order,
      *      => $config,
    }
  }
}
