# == Class: icinga2::feature::influxdb
#
# This module configures the Icinga2 feature influxdb.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature influxdb, absent disabled it. Default is present.
#
# [*host*]
#   InfluxDB host address. Default is '127.0.0.1'.
#
# [*port*]
#   InfluxDB port. Default is 8086.
#
# [*database*]
#   InfluxDB database to store the metrics in. Default is 'icinga2'.
#
# [*username*]
#   InfluxDB username to post the results with. Default it is not defined.
#
# [*password*]
#   InfluxDB password to post the results with. Default it is not defined.
#
# [*host_template*]
#   Template for metric path of hosts. Default is:
#   {
#     measurement = "$host.check_command$"
#     tags = {
#       hostname = "$host.name$"
#     }
#   }
#
# [*service_template*]
#   Template for metric path of services. Default is:
#   {
#     measurement = "$service.check_command$"
#     tags = {
#       hostname = "$host.name$"
#       service  = "$service.name$"
#     }
#   }
#
# [*enable_send_thresholds*]
#   Send threholds as metrics. Default is false.
#
# [*enable_send_metadata*]
#   Send metadata as metrics. Default is false.
#
# [*flush_interval*]
#   How often to flush to InfluxDB host. Default is 10.
#
# [*flush_threshold*]
#   Threshold at which to flush early before the interval is up. Default is 1024.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::influxdb(
  $ensure                 = present,
  $host                   = '127.0.0.1',
  $port                   = '8086',
  $database               = 'icinga2',
  $username               = undef,
  $password               = undef,
  $host_template          = '{
    measurement = "$host.check_command$"
    tags = {
      host = "$host.name$"
    }
  }',
  $service_template       = '{
    measurement = "$service.check_command$"
    tags = {
      host = "$host.name$"
      service = "$service.name$"
    }
  }',
  $enable_send_thresholds = false,
  $enable_send_metadata   = false,
  $flush_interval         = '10',
  $flush_threshold        = '1024'
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_ip_address($host)
  validate_integer($port)
  validate_string($database)
  if $username != undef {
    validate_string($username)
  }
  if $password != undef {
    validate_string($password)
  }
  validate_string($host_template)
  validate_string($service_template)
  validate_bool($enable_send_thresholds)
  validate_bool($enable_send_metadata)
  validate_integer($flush_interval)
  validate_integer($flush_threshold)

  icinga2::feature { 'influxdb':
    ensure => $ensure,
  }
}
