define icinga2::object::endpoint(
  $endpoint     = $title,
  $host         = undef,
  $port         = undef,
  $log_duration = undef,
) {

  if $endpoint { validate_string($endpoint) }
  if $host { validate_string($host) }
  if $port { validate_integer($port) }
  if $log_duration { validate_re($log_duration, '^\d+\.?\d*[d|h|m|s]?$') }

  $attrs = {
    host                  => $host,
    port                  => $port,
    log_duration          => $log_duration,
  }

  icinga2::object { $title:
    object_name => $endpoint,
    object_type => 'Endpoint',
    attrs       => $attrs,
  }
}
