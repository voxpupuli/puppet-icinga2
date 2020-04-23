# @summary
#   Manage Icinga 2 zone objects.
#
# @param [Enum['absent', 'present']] ensure
#   Set to present enables the object, absent disables it.
#
# @param [String] zone_name
#   Set the Icinga 2 name of the zone object.
#
# @param [Optional[Array]] endpoints
#   List of endpoints belong to this zone.
#
# @param [Optional[String]] parent
#   Parent zone to this zone.
#
# @param [Optional[Boolean]] global
#   If set to true, a global zone is defined and the parameter endpoints
#   and parent are ignored.
#
# @param [Optional[Stdlib::Absolutepath]] target
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# @param [Variant[String, Integer]] order
#   String or integer to control the position in the target file, sorted alpha numeric.
#
define icinga2::object::zone(
  Enum['absent', 'present']          $ensure    = present,
  String                             $zone_name = $title,
  Optional[Array]                    $endpoints = [],
  Optional[String]                   $parent    = undef,
  Optional[Boolean]                  $global    = false,
  Optional[Stdlib::Absolutepath]     $target    = undef,
  Variant[String, Integer]           $order     = 45,
) {

  $conf_dir = $::icinga2::globals::conf_dir

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
  }
}
