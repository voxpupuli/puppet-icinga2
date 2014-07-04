# == Class: icinga2::server::install
#
# This class installs the server components for the Icinga 2 monitoring system.
#
# === Parameters
#
# Coming soon...
#
# === Examples
# 
# Coming soon...
# 

class icinga2::server::install inherits icinga2::server {
  
  include icinga2::server
  #Apply our classes in the right order. Use the squiggly arrows (~>) to ensure that the 
  #class left is applied before the class on the right and that it also refreshes the 
  #class on the right.
  #
  #Here, we're setting up the package repos first, then installing the packages:
  class{'icinga2::server::install::repos':} ~> 
  class{'icinga2::server::install::packages':} ~> 
  class{'icinga2::server::install::execs':} -> 
  Class['icinga2::server::install']
  
}

class icinga2::server::install::repos inherits icinga2::server {

  include icinga2::server

  case $operatingsystem {
    #Red Hat/CentOS systems:
    'RedHat', 'CentOS': {
    
      #Add the official Icinga Yum repository: http://packages.icinga.org/epel/
      yumrepo { 'icinga2_yum_repo':
        baseurl  => "http://packages.icinga.org/epel/${operatingsystemmajrelease}/release/",
        descr    => "Icinga 2 Yum repository",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'http://packages.icinga.org/icinga.key'
      }
    }
    
    #Debian/Ubuntu systems: 
    /^(Debian|Ubuntu)$/: {
      #Add the Icinga 2 snapshots apt repo for Ubuntu Saucy Salamander:
      apt::source { "icinga2_ubuntu_${lsbdistcodename}_release_apt":
        location          => 'http://packages.icinga.org/ubuntu',
        release           => "icinga-${lsbdistcodename}",
        repos             => 'main',
        required_packages => 'debian-keyring debian-archive-keyring',
        key               => '34410682',
        key_source        => 'http://packages.icinga.org/icinga.key',
        include_src       => true
      }
    }
    
    #Fail if we're on any other OS:
    default: { fail("${operatingsystem} is not supported!") }
  }

}

#Install packages for Icinga 2:
class icinga2::server::install::packages inherits icinga2::server {

  include icinga2::server
  
  #Install the Icinga 2 package
  package {$icinga2_server_package:
    ensure   => installed,
    provider => $package_provider,
  }

  #Pick the right DB lib package name based on the database type the user selected:
  case $server_db_type {
    #MySQL:
    'mysql': { $icinga2_server_db_connector_package = 'icinga2-ido-mysql'}
    #Postgres:
    'pgsql': { $icinga2_server_db_connector_package = 'icinga2-ido-pgsql'}
    default: { fail("${icinga2::params::server_db_type} is not a supported database! Please specify either 'mysql' for MySQL or 'pgsql' for Postgres.") }
  }

  #Install the IDO database connector package. See:
  #http://docs.icinga.org/icinga2/latest/doc/module/icinga2/toc#!/icinga2/latest/doc/module/icinga2/chapter/getting-started#configuring-db-ido
  package {$icinga2_server_db_connector_package:
    ensure   => installed,
    provider => $package_provider,
  }

}

#This class contains exec resources
class icinga2::server::install::execs inherits icinga2::server {

  include icinga2::server

  case $server_db_type {
    #Schema loading for MySQL:
    'mysql': {
      exec { 'mysql_schema_load':
        user    => 'root',
        path    => '/usr/bin:/usr/sbin:/bin/:/sbin',
        command => "mysql -u ${db_user} -p${db_password} ${db_name} < ${server_db_schema_path}; touch /etc/icinga2/mysql_schema_loaded.txt",
        creates => "/etc/icinga2/mysql_schema_loaded.txt",
        require => Class['icinga2::server::install::packages'],
      }
    }
    #Schema loading for Postgres:
    'pgsql': {
      exec { 'postgres_schema_load':
        user    => 'root',
        path    => '/usr/bin:/usr/sbin:/bin/:/sbin',
        command => "su postgres -c 'psql -d ${db_name} < ${server_db_schema_path}'; touch /etc/icinga2/postgres_schema_loaded.txt",
        creates => "/etc/icinga2/postgres_schema_loaded.txt",
        require => Class['icinga2::server::install::packages'],
      }
    }
  
    default: { fail("${server_db_type} is not supported!") }
  }

}