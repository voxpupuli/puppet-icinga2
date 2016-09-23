# == Class: icinga2::feature::influxdb
#
# This module configures the Icinga2 feature influxdb.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature influxdb, absent disables it. Defaults to present.
#
# [*host*]
#    InfluxDB host address. Defaults to 127.0.0.1.
#
# [*port*]
#    InfluxDB HTTP port. Defaults to 8086.
#
# [*database*]
#    InfluxDB database name. Defaults to icinga2.
#
# [*username*]
#    InfluxDB user name. Defaults to undef.
#
# [*password*]
#    InfluxDB user password. Defaults to undef.
#
# [*ssl*]
#    SSL settings will be set depending on this parameter.
#      puppet: Use puppet certificates
#      custom: Set custom paths for certificate, key and CA
#      false: Disable SSL (default)
#
# [*ssl_ca_cert*]
#    CA certificate to validate the remote host. Only valid if ssl is set to 'custom'. Defaults to undef.
#
# [*ssl_cert*]
#    Host certificate to present to the remote host for mutual verification. 
#    Only valid if ssl is set to 'custom'. Defaults to undef..
#
# [*ssl_key*]
#    Host key to accompany the ssl_cert. Only valid if ssl is set to 'custom'. Defaults to undef.
#
# [*host_measurement*]
#    The value of this is used for the measurement setting in host_template. Defaults to  '$host.check_command$'
#
# [*host_tags*]
#    Tags defined in this hash will be set in the host_template.
#
#  [*service_measurement*]
#    The value of this is used for the measurement setting in host_template. Defaults to  '$service.check_command$'
#
# [*service_tags*]
#    Tags defined in this hash will be set in the service_template.
#
# [*enable_send_thresholds*]
#    Whether to send warn, crit, min & max tagged data. Defaults to false.
#
# [*enable_send_metadata*]
#    Whether to send check metadata e.g. states, execution time, latency etc. Defaults to false.
#
# [*flush_interval*]
#    How long to buffer data points before transfering to InfluxDB. Defaults to 10s.
#
# [*flush_threshold*]
#    How many data points to buffer before forcing a transfer to InfluxDB. Defaults to 1024.
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
  $ssl                    = false,
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

  include ::icinga2::params

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_ip_address($host)
  validate_integer($port)
  validate_string($database)
  validate_string($username)
  validate_string($password)
  validate_string($host_measurement)
  validate_hash($host_tags)
  validate_string($service_measurement)
  validate_hash($service_tags)
  validate_bool($enable_send_thresholds)
  validate_bool($enable_send_metadata)
  validate_re($flush_interval, '^\d+[ms]*$')
  validate_integer($flush_threshold)

  $user      = $::icinga2::params::user
  $group     = $::icinga2::params::group
  $node_name = $::icinga2::_constants['NodeName']
  $ssl_dir   = "${::icinga2::params::pki_dir}/influxdb"

  File {
    owner   => $user,
    group   => $group,
  }

  if $ssl {
    validate_re($ssl, [ '^puppet$', '^custom$' ],
      "${ssl} isn't supported. Valid values are 'puppet' and 'custom'.")

    case $ssl {
      'puppet': {
        file { $ssl_dir:
          ensure => directory,
          before => Icinga2::Feature['influxdb']
        }

        file { "${ssl_dir}/${node_name}.key":
          ensure => file,
          mode   => $::kernel ? {
            'windows' => undef,
            default   => '0600',
          },
          source => $::settings::hostprivkey,
          tag    => 'icinga2::config::file',
        }

       file { "${ssl_dir}/${node_name}.crt":
         ensure => file,
         source => $::settings::hostcert,
         tag    => 'icinga2::config::file',
       }

       file { "${ssl_dir}/ca.crt":
         ensure => file,
         source => $::settings::localcacert,
         tag    => 'icinga2::config::file',
       }
      }
      'custom': {
        validate_absolute_path($ssl_ca_cert)
        validate_absolute_path($ssl_cert)
        validate_absolute_path($ssl_key)
      }
      default: {
        fail("SSL method ${ssl} is not supported.")
      }
    }
  }

  icinga2::feature { 'influxdb':
    ensure => $ensure,
  }
}
