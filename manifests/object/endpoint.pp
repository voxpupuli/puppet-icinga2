# == Define: icinga2::object::endpoint
#
# Manage Icinga2 endpoint objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*endpoint*]
#   Set the Icinga2 name of the endpoint object. Defaults to title of the define resource.
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
#   String to set the position in the target file, sorted alpha numeric. Defaults to 10.
#
# === Authors
#
# Icinga Development Team <info@icinga.com>
#
define icinga2::object::endpoint(
  $ensure       = present,
  $endpoint     = $title,
  $host         = undef,
  $port         = undef,
  $log_duration = undef,
  $target       = undef,
  $order        = '10',
) {

  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_integer($order)

  if $endpoint { validate_string($endpoint) }
  if $host { validate_ip_address($host) }
  if $port { validate_integer($port) }
  if $log_duration { validate_re($log_duration, '^\d+\.?\d*[d|h|m|s]?$') }

  if $target {
    validate_absolute_path($target)
    $_target = $target }
  else {
    $_target = "${conf_dir}/zones.conf" }

  # compose the attributes
  $attrs = {
    host         => $host,
    port         => $port,
    log_duration => $log_duration,
  }

  # create object
  icinga2::object { "icinga2::object::Endpoint::${title}":
    ensure      => $ensure,
    object_name => $endpoint,
    object_type => 'Endpoint',
    attrs       => $attrs,
    target      => $_target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
