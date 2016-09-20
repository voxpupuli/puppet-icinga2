define icinga2::object::endpoint(
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
  if $endpoint { validate_string($endpoint) }
  if $host { validate_string($host) }
  if $port { validate_integer($port) }
  if $log_duration { validate_re($log_duration, '^\d+\.?\d*[d|h|m|s]?$') }

  if $target {
    validate_absolute_path($target)
    $_target = $target }
  else {
    $_target = "${conf_dir}/zones.conf" }

  validate_integer($order)

  # compose the attributes
  $attrs = {
    host         => $host,
    port         => $port,
    log_duration => $log_duration,
  }

  # create object
  icinga2::object { "icinga2::object::endpoint::${title}":
    object_name => $endpoint,
    object_type => 'Endpoint',
    attrs       => $attrs,
    target      => $_target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
