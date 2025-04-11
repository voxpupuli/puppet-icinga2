# @summary
#   Installs and configures the Icinga 2 feature ido-pgsql.
#
# @example The ido-pgsql featue requires an existing database and a user with permissions. This example uses the [puppetlab/postgresql](https://forge.puppet.com/puppetlabs/postgresql) module.
#   include icinga2
#   include postgresql::server
#
#   postgresql::server::db { 'icinga2':
#     user     => 'icinga2',
#     password => postgresql::postgresql_password('icinga2', 'supersecret'),
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
# @param ensure
#   Set to present enables the feature ido-pgsql, absent disables it.
#
# @param host
#    PostgreSQL database host address.
#
# @param port
#    PostgreSQL database port.
#
# @param user
#    PostgreSQL database user with read/write permission to the icinga database.
#
# @param password
#    PostgreSQL database user's password. The password parameter isn't parsed anymore.
#
# @param database
#    PostgreSQL database name.
#
# @param ssl_mode
#   Enable SSL connection mode.
#
# @param ssl_key_path
#   Location of the private key. Only valid if ssl_mode is set unequal to `disabled`.
#
# @param ssl_cert_path
#   Location of the certificate. Only valid if ssl_mode is set unequal to `disabled`.
#
# @param ssl_cacert_path
#   Location of the CA certificate. Only valid if ssl_mode is set unequal to `disabled`.
#
# @param ssl_key
#   The client private key in PEM format. Only valid if ssl_mode is set unequal to `disabled`.
#
# @param ssl_cert
#   The client certificate in PEM format. Only valid if ssl_mode is set unequal to `disabled`.
#
# @param ssl_cacert
#   The CA root certificate in PEM format. Only valid if ssl_mode is set unequal to `disabled`.
#
# @param table_prefix
#   PostgreSQL database table prefix.
#
# @param instance_name
#   Unique identifier for the local Icinga 2 instance.
#
# @param instance_description
#   Description of the Icinga 2 instance.
#
# @param enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
# @param failover_timeout
#   Set the failover timeout in a HA cluster. Must not be lower than 60s.
#
# @param cleanup
#   Hash with items for historical table cleanup.
#
# @param categories
#   Array of information types that should be written to the database.
#
# @param import_schema
#   Whether to import the PostgreSQL schema or not.
#
class icinga2::feature::idopgsql (
  Enum['absent', 'present']                   $ensure               = present,
  Stdlib::Host                                $host                 = 'localhost',
  Optional[Stdlib::Port]                      $port                 = undef,
  String[1]                                   $user                 = 'icinga',
  String[1]                                   $database             = 'icinga',
  Optional[Icinga::Secret]                    $password             = undef,
  Optional[Enum['disable', 'allow', 'prefer',
  'verify-full', 'verify-ca', 'require']]     $ssl_mode             = undef,
  Optional[Stdlib::Absolutepath]              $ssl_key_path         = undef,
  Optional[Stdlib::Absolutepath]              $ssl_cert_path        = undef,
  Optional[Stdlib::Absolutepath]              $ssl_cacert_path      = undef,
  Optional[Icinga::Secret]                    $ssl_key              = undef,
  Optional[String[1]]                         $ssl_cert             = undef,
  Optional[String[1]]                         $ssl_cacert           = undef,
  Optional[String[1]]                         $table_prefix         = undef,
  Optional[String[1]]                         $instance_name        = undef,
  Optional[String[1]]                         $instance_description = undef,
  Optional[Boolean]                           $enable_ha            = undef,
  Optional[Icinga2::Interval]                 $failover_timeout     = undef,
  Optional[Icinga2::IdoCleanup]               $cleanup              = undef,
  Optional[Array]                             $categories           = undef,
  Boolean                                     $import_schema        = false,
) {
  if ! defined(Class['icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $owner                  = $icinga2::globals::user
  $group                  = $icinga2::globals::group
  $conf_dir               = $icinga2::globals::conf_dir
  $ssl_dir                = $icinga2::globals::cert_dir
  $ido_pgsql_package_name = $icinga2::globals::ido_pgsql_package_name
  $ido_pgsql_schema       = $icinga2::globals::ido_pgsql_schema
  $manage_packages        = $icinga2::manage_packages

  $enable_ssl             = if $ssl_mode and $ssl_mode != 'disabled' {
    true
  } else {
    false
  }

  $_notify                = $ensure ? {
    'present' => Class['icinga2::service'],
    default   => undef,
  }

  if $enable_ssl {
    $cert = icinga::cert::files(
      'IdoPgsqlConnection_ido-pgsql',
      $ssl_dir,
      $ssl_key_path,
      $ssl_cert_path,
      $ssl_cacert_path,
      $ssl_key,
      $ssl_cert,
      $ssl_cacert,
    )

    $attrs_ssl = {
      'ssl_mode' => $ssl_mode,
      'ssl_ca'   => $cert['cacert_file'],
      'ssl_cert' => $cert['cert_file'],
      'ssl_key'  => $cert['key_file'],
    }

    # Workaround, icinga::cert doesn't accept undef values for owner and group!
    if $facts['os']['family'] != 'windows' {
      icinga::cert { 'IdoPgsqlConnection_ido-pgsql':
        args   => $cert,
        owner  => $owner,
        group  => $group,
        notify => $_notify,
      }
    } else {
      icinga::cert { 'IdoPgsqlConnection_ido-pgsql':
        args   => $cert,
        owner  => 'foo',
        group  => 'bar',
        notify => $_notify,
      }
    }
  } else {
    $attrs_ssl = {
      'ssl_mode' => undef,
      'ssl_ca'   => undef,
      'ssl_cert' => undef,
      'ssl_key'  => undef,
    }
    $cert = {}
  }

  $attrs = {
    'host'                 => $host,
    'port'                 => $port,
    'user'                 => $user,
    'password'             => Sensitive($password),
    'database'             => $database,
    'table_prefix'         => $table_prefix,
    'instance_name'        => $instance_name,
    'instance_description' => $instance_description,
    'enable_ha'            => $enable_ha,
    'failover_timeout'     => $failover_timeout,
    'cleanup'              => $cleanup,
    'categories'           => $categories,
  }

  # install additional package
  if $ido_pgsql_package_name and $manage_packages {
    if $facts['os']['family'] == 'debian' {
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
    if $ido_pgsql_package_name and $manage_packages {
      Package[$ido_pgsql_package_name] -> Exec['idopgsql-import-schema']
    }

    $db_cli_options = icinga::db::connect({
        'type'     => 'pgsql',
        'host'     => $host,
        'port'     => $port,
        'database' => $database,
        'username' => $user,
    }, $cert, $enable_ssl, $ssl_mode)

    exec { 'idopgsql-import-schema':
      user        => 'root',
      path        => $facts['path'],
      environment => [sprintf('PGPASSWORD=%s', unwrap($password))],
      command     => "psql '${db_cli_options}' -w -f '${ido_pgsql_schema}'",
      unless      => "psql '${db_cli_options}' -w -c 'select version from icinga_dbversion'",
    }
  }

  # create object
  icinga2::object { 'icinga2::object::IdoPgsqlConnection::ido-pgsql':
    object_name => 'ido-pgsql',
    object_type => 'IdoPgsqlConnection',
    attrs       => delete_undef_values($attrs + $attrs_ssl),
    attrs_list  => concat(keys($attrs), keys($attrs_ssl)),
    target      => "${conf_dir}/features-available/ido-pgsql.conf",
    order       => 10,
    notify      => $_notify,
  }

  icinga2::feature { 'ido-pgsql':
    ensure => $ensure,
  }
}
