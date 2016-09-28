# == Class: icinga2::feature::idopgsql
#
# This module configures the Icinga2 feature ido-pgsql.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature ido-pgsql, absent disables it. Defaults to present.
#
# [*host*]
#    PostgreSQL database host address. Defaults to '127.0.0.1'.
#
# [*port*]
#    PostgreSQL database port. Defaults to 5432.
#
# [*user*]
#    PostgreSQL database user with read/write permission to the icinga database. Defaults to "icinga".
#
# [*password*]
#    PostgreSQL database user's password. Defaults to "icinga".
#
# [*database*]
#    PostgreSQL database name. Defaults to "icinga".
#
# [*table_prefix*]
#   PostgreSQL database table prefix. Defaults to "icinga_".
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
#   Whether to import the PostgreSQL schema or not. Defaults to false.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::idopgsql(
  $ensure                 = present,
  $host                   = '127.0.0.1',
  $port                   = 5432,
  $user                   = 'icinga',
  $password               = 'icinga',
  $database               = 'icinga',
  $table_prefix           = 'icinga_',
  $instance_name          = 'default',
  $instance_description   = undef,
  $enable_ha              = true,
  $failover_timeout       = '60s',
  $cleanup                = undef,
  $categories             = undef,
  $import_schema          = false,
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_ip_address($host)
  validate_integer($port)
  validate_string($user)
  validate_string($password)
  validate_string($database)
  validate_string($table_prefix)
  validate_string($instance_name)
  if $instance_description { validate_string($instance_description) }
  validate_bool($enable_ha)
  validate_re($failover_timeout, '^\d+[ms]*$')
  if $cleanup { validate_hash($cleanup) }
  if $categories { validate_array($categories) }
  validate_bool($import_schema)

  $conf_dir  = $::icinga2::params::conf_dir

  package { 'icinga2-ido-pgsql':
    ensure => installed,
  }

  if $import_schema {
    exec { 'idopgsql_import_schema':
      user        => 'root',
      path        => $::path,
      environment => ["PGPASSWORD=${password}"],
      command     => "psql -h '${host}' -U '${user}' -d '${database}' -w -f /usr/share/icinga2-ido-pgsql/schema/pgsql.sql",
      unless      => "psql -h '${host}' -U '${user}' -d '${database}' -w -c 'select version from icinga_dbversion'",
      require     => Package['icinga2-ido-pgsql'],
    }
  }

  $attrs = {
    host                  => $host,
    port                  => $port,
    user                  => $user,
    password              => $password,
    database              => $database,
    table_prefix          => $table_prefix,
    instance_name         => $instance_name,
    instance_description  => $instance_description,
    enable_ha             => $enable_ha,
    failover_timeout      => $failover_timeout,
    cleanup               => $cleanup,
    categories            => $categories,
  }

  # create object
  icinga2::object { "icinga2::object::IdoPgsqlConnection::ido-pgsql":
    object_name => 'ido-pgsql',
    object_type => 'IdoPgsqlConnection',
    attrs       => $attrs,
    target      => "${conf_dir}/features-available/ido-pgsql.conf",
    order       => '10',
    notify      => $ensure ? {
      'present' => Class['::icinga2::service'],
      default   => undef,
    },
  }

  # import library
  concat::fragment { 'icinga2::feature::ido-pgsql':
    target  => "${conf_dir}/features-available/ido-pgsql.conf",
    content => "library \"db_ido_pgsql\"\n\n",
    order   => '05',
  }

  icinga2::feature { 'ido-pgsql':
    ensure => $ensure,
    require => Package['icinga2-ido-pgsql']
  }
}
