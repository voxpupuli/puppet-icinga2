# == Class: icinga2::feature::idomysql
#
# This module configures the Icinga2 feature ido-mysql.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature ido-mysql, absent disables it. Defaults to present.
#
# [*host*]
#    MySQL database host address. Defaults to '127.0.0.1'.
#
# [*port*]
#    MySQL database port. Defaults to 3306.
#
# [*socket_path*]
#    MySQL socket path.
#
# [*user*]
#    MySQL database user with read/write permission to the icinga database. Defaults to "icinga".
#
# [*password*]
#    MySQL database user's password. Defaults to "icinga".
#
# [*database*]
#    MySQL database name. Defaults to "icinga".
#
# [*ssl*]
#    SSL settings will be set depending on this parameter.
#      puppet: Use puppet certificates
#      custom: Set custom paths for certificate, key and CA
#      false: Disable SSL (default)
#
# [*ssl_key*]
#    MySQL SSL client key file path. Only valid if ssl is set to custom.
#
# [*ssl_cert*]
#    MySQL SSL certificate file path. Only valid if ssl is set to custom.
#
# [*ssl_ca*]
#    MySQL SSL certificate authority certificate file path. Only valid if ssl is set to custom.
#
# [*ssl_capath*]
#    MySQL SSL trusted SSL CA certificates in PEM format directory path. Only valid if ssl is enabled.
#
# [*ssl_cipher*]
#    MySQL SSL list of allowed ciphers. Only valid if ssl is enabled.
#
# [*table_prefix*]
#   MySQL database table prefix. Defaults to "icinga_".
#
# [*instance_name*]
#   Unique identifier for the local Icinga 2 instance. Defaults to "default".
#
# [*instance_description*]
#   Description for the Icinga 2 instance.
#
# [*enable_ha*]
#   Enable the high availability functionality. Only valid in a cluster setup. Defaults to "true".
#
# [*failover_timeout*]
#   Set the failover timeout in a HA cluster. Must not be lower than 60s. Defaults to "60s".
#
# [*cleanup*]
#   Hash with items for historical table cleanup.
#
# [*categories*]
#   Array of information types that should be written to the database.
#
# [*import_schema*]
#   Whether to import the MySQL schema or not. Defaults to false.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::idomysql(
  $ensure                 = present,
  $host                   = '127.0.0.1',
  $port                   = 3306,
  $socket_path            = undef,
  $user                   = 'icinga',
  $password               = 'icinga',
  $database               = 'icinga',
  $ssl                    = false,
  $ssl_key                = undef,
  $ssl_cert               = undef,
  $ssl_ca                 = undef,
  $ssl_capath             = undef,
  $ssl_cipher             = undef,
  $table_prefix           = 'icinga_',
  $instance_name          = 'default',
  $instance_description   = undef,
  $enable_ha              = true,
  $failover_timeout       = '60s',
  $cleanup                = {},
  $categories             = [],
  $import_schema          = false,
) {

  include ::icinga2::params

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_ip_address($host)
  validate_integer($port)
  unless ($socket_path == undef){ validate_absolute_path($socket_path) }
  validate_string($user)
  validate_string($password)
  validate_string($database)
  validate_string($table_prefix)
  validate_string($instance_name)
  unless ($instance_description == undef){ validate_string($instance_description) }
  validate_bool($enable_ha)
  validate_re($failover_timeout, '^\d+[ms]*$')
  validate_hash($cleanup)
  validate_array($categories)
  validate_bool($import_schema)
  unless ($ssl_capath == undef){ validate_absolute_path($ssl_capath) }
  unless ($ssl_cipher == undef){ validate_string($ssl_cipher) }

  $owner     = $::icinga2::params::user
  $group     = $::icinga2::params::group
  $node_name = $::icinga2::_constants['NodeName']
  $ssl_dir   = "${::icinga2::params::pki_dir}/ido-mysql"

  File {
    owner   => $owner,
    group   => $group,
  }

  if $ssl {
    validate_re($ssl, [ '^puppet$', '^custom$' ],
      "${ssl} isn't supported. Valid values are 'puppet' and 'custom'.")

    case $ssl {
      'puppet': {
        file { $ssl_dir:
          ensure => directory,
          before => Icinga2::Feature['ido-mysql']
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
        validate_absolute_path($ssl_ca)
        validate_absolute_path($ssl_cert)
        validate_absolute_path($ssl_key)
      }
      default: {
        fail("SSL method ${ssl} is not supported.")
      }
    }
  }

  package { 'icinga2-ido-mysql':
    ensure => installed,
  }

  if $import_schema {
    exec { 'idomysql_import_schema':
      user    => 'root',
      path    => $::path,
      command => "mysql -h '${host}' -u '${user}' -p'${password}' '${database}' < '/usr/share/icinga2-ido-mysql/schema/mysql.sql'",
      unless  => "mysql -h '${host}' -u '${user}' -p'${password}' '${database}' -Ns -e 'select version from icinga_dbversion'",
      require => Package['icinga2-ido-mysql'],
    }
  }

  icinga2::feature { 'ido-mysql':
    ensure => $ensure,
    require => Package['icinga2-ido-mysql']
  }
}
