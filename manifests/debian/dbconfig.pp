# == Class: icinga2::debian::dbconfig
#
class icinga2::debian::dbconfig(
  Enum['mysql', 'pgsql'] $dbtype,
  String                 $dbserver,
  Integer[1,65535]       $dbport,
  String                 $dbname,
  String                 $dbuser,
  String                 $dbpass,
  Boolean                $ssl = false,
) {

  assert_private()

  # dbconfig config for Debian or Ubuntu
  if $::osfamily == 'debian' {

      include ::icinga2::params

      case $dbtype {
        'mysql': {
          $default_port = 3306
          $path         = "/etc/dbconfig-common/${::icinga2::params::ido_mysql_package}.conf"
        }
        'pgsql': {
          $default_port = 5432
          $path         = "/etc/dbconfig-common/${::icinga2::params::ido_pgsql_package}.conf"
        }
        default: {
          fail("Unsupported dbtype: ${dbtype}")
        }
      }

      file_line { "dbc-${dbtype}-dbuser":
        path  => $path,
        line  => "dbc_dbuser='${dbuser}'",
        match => '^dbc_dbuser\s*=',
      }
      file_line { "dbc-${dbtype}-dbpass":
        path  => $path,
        line  => "dbc_dbpass='${dbpass}'",
        match => '^dbc_dbpass\s*=',
      }
      file_line { "dbc-${dbtype}-dbname":
        path  => $path,
        line  => "dbc_dbname='${dbname}'",
        match => '^dbc_dbname\s*=',
      }
      # only set host if isn't the default
      if $dbserver != '127.0.0.1' and $dbserver != 'localhost' {
        file_line { "dbc-${dbtype}-dbserver":
          path  => $path,
          line  => "dbc_dbserver='${dbserver}'",
          match => '^dbc_dbserver\s*=',
        }
      }
      # only set port if isn't the default
      if $dbport != $default_port {
        file_line { "dbc-${dbtype}-dbport":
          path  => $path,
          line  => "dbc_dbport='${dbport}'",
          match => '^dbc_dbport\s*=',
        }
      }
      # set ssl
      if $ssl {
        file_line { "dbc-${dbtype}-ssl":
          path  => $path,
          line  => "dbc_ssl='true'",
          match => '^dbc_ssl\s*=',
        }
      }
  } # debian dbconfig
}
