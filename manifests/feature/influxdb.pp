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
# [*host_template*]
#    Host template to define the InfluxDB line protocol.
#
# [*service_template*]
#    Service template to define the influxDB line protocol.
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
  $host_template          = { measurement => '$host.check_command$', tags => { hostname => '$host.name$' } },
  $service_template       = { measurement => '$service.check_command$', tags => { hostname => '$host.name$', service => '$service.name$' } },
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
  validate_hash($host_template)
  validate_hash($service_template)
  validate_bool($enable_send_thresholds)
  validate_bool($enable_send_metadata)
  validate_re($flush_interval, '^\d+[ms]*$')
  validate_integer($flush_threshold)

  icinga2::feature { 'influxdb':
    ensure => $ensure,
  }
}
