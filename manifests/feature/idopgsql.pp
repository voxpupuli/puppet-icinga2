# @summary
#   Installs and configures the Icinga 2 feature ido-pgsql.
#
# @example The ido-pgsql featue requires an existing database and a user with permissions. This example uses the [puppetlab/postgresql](https://forge.puppet.com/puppetlabs/postgresql) module.
#   include icinga2
#   include postgresql::server
#
#   postgresql::server::db { 'icinga2':
#     user     => 'icinga2',
#     password => postgresql_password('icinga2', 'supersecret'),
#   }
#
#   class{ 'icinga2::feature::idopgsql':
#     user          => 'icinga2',
#     password      => 'supersecret',
#     database      => 'icinga2',
#     import_schema => true,
#     require       => Postgresql::Server::Db['icinga2']
#   }
#
# @param [Enum['absent', 'present']] ensure
#   Set to present enables the feature ido-pgsql, absent disables it.
#
# @param [Stdlib::Host] host
#    PostgreSQL database host address.
#
# @param [Stdlib::Port::Unprivileged] port
#    PostgreSQL database port.
#
# @param [String] user
#    PostgreSQL database user with read/write permission to the icinga database.
#
# @param [String] password
#    PostgreSQL database user's password. The password parameter isn't parsed anymore.
#
# @param [String] database
#    PostgreSQL database name.
#
# @param [Optional[String]] table_prefix
#   PostgreSQL database table prefix.
#
# @param [Optional[String]] instance_name
#   Unique identifier for the local Icinga 2 instance.
#
# @param [Optional[String]] instance_description
#   Description of the Icinga 2 instance.
#
# @param [Optional[Boolean]] enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
# @param [Optional[Icinga2::Interval]] failover_timeout
#   Set the failover timeout in a HA cluster. Must not be lower than 60s.
#
# @param [Optional[Hash]] cleanup
#   Hash with items for historical table cleanup.
#
# @param [Optional[Array]] categories
#   Array of information types that should be written to the database.
#
# @param [Boolean] import_schema
#   Whether to import the PostgreSQL schema or not.
#
class icinga2::feature::idopgsql(
  String                         $password,
  Enum['absent', 'present']      $ensure               = present,
  Stdlib::Host                   $host                 = 'localhost',
  Stdlib::Port::Unprivileged     $port                 = 5432,
  String                         $user                 = 'icinga',
  String                         $database             = 'icinga',
  Optional[String]               $table_prefix         = undef,
  Optional[String]               $instance_name        = undef,
  Optional[String]               $instance_description = undef,
  Optional[Boolean]              $enable_ha            = undef,
  Optional[Icinga2::Interval]    $failover_timeout     = undef,
  Optional[Hash]                 $cleanup              = undef,
  Optional[Array]                $categories           = undef,
  Boolean                        $import_schema        = false,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir               = $::icinga2::globals::conf_dir
  $ido_pgsql_package_name = $::icinga2::globals::ido_pgsql_package_name
  $ido_pgsql_schema       = $::icinga2::globals::ido_pgsql_schema
  $manage_package         = $::icinga2::manage_package
  $_notify                = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  $attrs = {
    host                  => $host,
    port                  => $port,
    user                  => $user,
    password              => "-:\"${password}\"",   # The password parameter isn't parsed anymore.
    database              => $database,
    table_prefix          => $table_prefix,
    instance_name         => $instance_name,
    instance_description  => $instance_description,
    enable_ha             => $enable_ha,
    failover_timeout      => $failover_timeout,
    cleanup               => $cleanup,
    categories            => $categories,
  }

  # install additional package
  if $ido_pgsql_package_name and $manage_package {
    if $::osfamily == 'debian' {
      ensure_resources('file', { '/etc/dbconfig-common' => { ensure => directory, owner => 'root', group => 'root' } })
      file { "/etc/dbconfig-common/${ido_pgsql_package_name}.conf":
        ensure  => file,
        content => "dbc_install='false'\ndbc_upgrade='false'\ndbc_remove='false'\n",
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        before  => Package[$ido_pgsql_package_name],
      }
    } # Debian

    package { $ido_pgsql_package_name:
      ensure => installed,
      before => Icinga2::Feature['ido-pgsql'],
    }
  }

  # import db schema
  if $import_schema {
    if $ido_pgsql_package_name and $manage_package {
      Package[$ido_pgsql_package_name] -> Exec['idopgsql-import-schema']
    }
    exec { 'idopgsql-import-schema':
      user        => 'root',
      path        => $::path,
      environment => ["PGPASSWORD=${password}"],
      command     => "psql -h '${host}' -U '${user}' -p '${port}' -d '${database}' -w -f \"${ido_pgsql_schema}\"",
      unless      => "psql -h '${host}' -U '${user}' -p '${port}' -d '${database}' -w -c 'select version from icinga_dbversion'",
    }
  }

  # create object
  icinga2::object { 'icinga2::object::IdoPgsqlConnection::ido-pgsql':
    object_name => 'ido-pgsql',
    object_type => 'IdoPgsqlConnection',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/ido-pgsql.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library
  concat::fragment { 'icinga2::feature::ido-pgsql':
    target  => "${conf_dir}/features-available/ido-pgsql.conf",
    content => "library \"db_ido_pgsql\"\n\n",
    order   => '05',
  }

  icinga2::feature { 'ido-pgsql':
    ensure  => $ensure,
  }
}
