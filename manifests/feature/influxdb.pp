# == Class: icinga2::feature::influxdb
#
# This module configures the Icinga2 feature influxdb.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature influxdb, absent disables it. Default is present.
#
# [*host*]
#    InfluxDB host address. Default is 127.0.0.1.
#
# [*port*]
#    InfluxDB HTTP port. Default is 8086.
#
# [*database*]
#    InfluxDB database name. Default is icinga2.
#
# [*username*]
#    InfluxDB user name. Default is undef.
#
# [*password*]
#    InfluxDB user password. Default is undef.
#
# [*ssl_enable*]
#    Whether to use a TLS stream. Defaults to false.
#
# [*ssl_ca_cert*]
#    CA certificate to validate the remote host. Default is undef.
#
# [*ssl_cert*]
#    Host certificate to present to the remote host for mutual verification. Default is undef.
#
# [*ssl_key*]
#    Host key to accompany the ssl_cert. Default is undef.
#
# [*host_measurement*]
#    The value of this is used for the measurement setting in host_template. Default is  '$host.check_command$'
#
# [*host_tags*]
#    Tags defined in this hash will be set in the host_template.
#
#  [*service_measurement*]
#    The value of this is used for the measurement setting in host_template. Default is  '$service.check_command$'
#
# [*service_tags*]
#    Tags defined in this hash will be set in the service_template.
#
# [*enable_send_thresholds*]
#    Whether to send warn, crit, min & max tagged data. Default is false.
#
# [*enable_send_metadata*]
#    Whether to send check metadata e.g. states, execution time, latency etc. Default is false.
#
# [*flush_interval*]
#    How long to buffer data points before transfering to InfluxDB. Default is 10s.
#
# [*flush_threshold*]
#    How many data points to buffer before forcing a transfer to InfluxDB. Default is 1024.
#
# === Example
#
# class { 'icinga2::feature::influxdb':
#   host     => "10.10.0.15",
#   username => "icinga2",
#   password => "supersecret",
#   database => "icinga2"
# }
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::influxdb(
  $ensure                 = present,
  $host                   = '127.0.0.1',
  $port                   = 8086,
  $database               = 'icinga2',
  $username               = undef,
  $password               = undef,
  $ssl_enable             = false,
  $ssl_ca_cert            = undef,
  $ssl_cert               = undef,
  $ssl_key                = undef,
  $host_measurement       = '$host.check_command$',
  $host_tags              = { hostname => '$host.name$' },
  $service_measurement    = '$service.check_command$',
  $service_tags           = { hostname => '$host.name$', service => '$service.name$' },
  $enable_send_thresholds = false,
  $enable_send_metadata   = false,
  $flush_interval         = '10s',
  $flush_threshold        = 1024
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_ip_address($host)
  validate_integer($port)
  validate_string($database)
  validate_string($username)
  validate_string($password)
  validate_bool($ssl_enable)
  validate_string($host_measurement)
  validate_hash($host_tags)
  validate_string($service_measurement)
  validate_hash($service_tags)
  validate_bool($enable_send_thresholds)
  validate_bool($enable_send_metadata)
  validate_re($flush_interval, '^\d+[ms]*$')
  validate_integer($flush_threshold)

  icinga2::feature { 'influxdb':
    ensure => $ensure,
  }
}
