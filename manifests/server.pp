# == Class: icinga2::server
#
# This module installs and configures the server components for the Icinga 2 monitoring system.
#
# === Parameters
#
# Coming soon...
#
# === Examples
#
# Coming soon...
#

class icinga2::server (
  $manage_repos = $icinga2::params::manage_repos,
  $server_db_type = $icinga2::params::server_db_type,
  $db_name = $icinga2::params::db_name,
  $db_user = $icinga2::params::db_user,
  $db_password = $icinga2::params::db_password,
  $db_host = $icinga2::params::db_host,
  $db_port = $icinga2::params::db_port,
  $package_provider = $icinga2::params::package_provider,
  $icinga2_server_package = $icinga2::params::icinga2_server_package,
  #$server_db_schema_path = $icinga2::params::server_db_schema_path
  $server_install_nagios_plugins = $icinga2::params::server_install_nagios_plugins,
) inherits icinga2::params {
  
  #Do some validation of parameters so we know we have the right data types:
  validate_bool($manage_repos)
  validate_string($server_db_type)
  validate_string($db_name)
  validate_string($db_user)
  validate_string($db_password)
  validate_string($db_host)
  validate_string($db_port)
  validate_string($package_provider)
  validate_string($icinga2_server_package)
  validate_bool($server_install_nagios_plugins)

  #Pick set the right path where we can find the DB schema based on the OS...
  case $::operatingsystem {
    'CentOS': {
      #...and database that the user picks
      case $server_db_type {
        'mysql': { $server_db_schema_path = '/usr/share/icinga2-ido-mysql/schema/mysql.sql' }
        'pgsql': { $server_db_schema_path = '/usr/share/icinga2-ido-pgsql/schema/pgsql.sql' }
      }
    }

    #Debian/Ubuntu systems:
    'Ubuntu': {
      #Pick set the right path where we can find the DB schema
      case $server_db_type {
        'mysql': { $server_db_schema_path = '/usr/share/icinga2-ido-mysql/schema/mysql.sql' }
        'pgsql': { $server_db_schema_path = '/usr/share/icinga2-ido-pgsql/schema/pgsql.sql' }
      }
    }

    #Fail if we're on any other OS:
    default: { fail("${::operatingsystem} is not supported!") }
  }


  #Apply our classes in the right order. Use the squiggly arrows (~>) to ensure that the
  #class left is applied before the class on the right and that it also refreshes the
  #class on the right.
  class {'icinga2::server::install':} ~>
  class {'icinga2::server::config':} ~>
  class {'icinga2::server::service':}

}
