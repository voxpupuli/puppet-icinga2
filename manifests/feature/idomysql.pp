# == Class: icinga2::feature::idomysql
#
# This module configures the Icinga2 feature ido-mysql.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature ido-mysql, absent disables it. Default is present.
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
# [*enable_ssl*]
#    Use SSL. Defaults to false. Change to true in case you want to use any of the SSL options.
#
# [*ssl_key*]
#    MySQL SSL client key file path.
#
# [*ssl_cert*]
#    MySQL SSL certificate file path.
#
# [*ssl_ca*]
#    MySQL SSL certificate authority certificate file path.
#
# [*ssl_capath*]
#    MySQL SSL trusted SSL CA certificates in PEM format directory path.
#
# [*ssl_cipher*]
#    MySQL SSL list of allowed ciphers.
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
  $enable_ssl             = false,
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

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_ip_address($host)
  validate_integer($port)
  unless ($socket_path == undef){
    validate_absolute_path($socket_path)
  }
  validate_string($user)
  validate_string($password)
  validate_string($database)
  validate_bool($enable_ssl)
  validate_string($table_prefix)
  validate_string($instance_name)
  unless ($instance_description == undef){
    validate_string($instance_description)
  }
  validate_bool($enable_ha)
  validate_re($failover_timeout, '^\d+[ms]*$')
  validate_hash($cleanup)
  validate_array($categories)
  validate_bool($import_schema)

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
