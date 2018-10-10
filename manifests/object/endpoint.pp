# == Define: icinga2::object::endpoint
#
# Manage Icinga 2 endpoint objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*endpoint_name*]
#   Set the Icinga 2 name of the endpoint object. Defaults to title of the define resource.
#
# [*host*]
#   Optional. The IP address of the remote Icinga 2 instance.
#
# [*port*]
#   The service name/port of the remote Icinga 2 instance. Defaults to 5665.
#
# [*log_duration*]
#   Duration for keeping replay logs on connection loss. Defaults to 1d (86400 seconds).
#   Attribute is specified in seconds. If log_duration is set to 0, replaying logs is disabled.
#   You could also specify the value in human readable format like 10m for 10 minutes
#   or 1h for one hour.
#
# [*target*]
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# [*order*]
#   String or integer to set the position in the target file, sorted alpha numeric. Defaults to 40.
#
#
define icinga2::object::endpoint(
  Enum['absent', 'present']                      $ensure        = present,
  Optional[String]                               $endpoint_name = $title,
  Optional[String]                               $host          = undef,
  Optional[Integer[1,65535]]                     $port          = undef,
  Optional[Pattern[/^\d+\.?\d*[d|h|m|s]?$/]]     $log_duration  = undef,
  Optional[Stdlib::Absolutepath]                 $target        = undef,
  Variant[String, Integer]                       $order         = 40,
) {

  $conf_dir = $::icinga2::globals::conf_dir

  if $target {
    $_target = $target
  } else {
    $_target = "${conf_dir}/zones.conf"
  }

  # compose the attributes
  $attrs = {
    host         => $host,
    port         => $port,
    log_duration => $log_duration,
  }

  # create object
  icinga2::object { "icinga2::object::Endpoint::${title}":
    ensure      => $ensure,
    object_name => $endpoint_name,
    object_type => 'Endpoint',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $_target,
    order       => $order,
  }
}
