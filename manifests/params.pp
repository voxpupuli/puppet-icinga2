# == Class: icinga2::params
#
# This class contains config options and settings for use elsewhere in the module.
#
# === Parameters
#
# See the inline comments.
#

class icinga2::params {

  ##############################
  # Package parameters
  ##############################

  #Whether to manage the package repositories
  $manage_repos = 'true'
  $server_db_type = 'pgsql'
  
  ##############################
  # Icinga 2 server package parameters

  #Pick the right package and package provider parameters based on the OS:
  case $operatingsystem {
    #Red Hat/CentOS systems:
    'RedHat', 'CentOS': {
      #Pick the right package provider:
      $package_provider = 'yum'
      #Icinga 2 server package
      $icinga2_server_package = 'icinga2'
      
      #Pick set the right path where we can find the DB schema
      case $server_db_type {
        'mysql': { $server_db_schema_path = '/usr/share/doc/icinga2-ido-mysql-2.0.0/schema/mysql.sql' }
        'pgsql': { $server_db_schema_path = '/usr/share/doc/icinga2-ido-pgsql-2.0.0/schema/pgsql.sql' }
      }
    }
    
    #Debian/Ubuntu systems: 
    /^(Debian|Ubuntu)$/: {
      #Pick the right package provider:
      $package_provider = 'apt'
      #Icinga 2 server package
      $icinga2_server_package = 'icinga2'
      
      #Set some package repo variables based on the Ubuntu release:
      case $operatingsystemrelease {
        #For Ubuntu 12.04 Precise Pangolin: http://releases.ubuntu.com/12.04/
        '12.04': {
          
        }
        #For Ubuntu 14.04 Trusty Tahr: http://releases.ubuntu.com/14.04/
        '14.04': {
          
        }
        #Fail if we are on any other Ubuntu release:
        default: { fail("${operatingsystem} ${operatingsystemrelease} is not a supported Ubuntu release!") }
      }
    }
    
    #Fail if we're on any other OS:
    default: { fail("${operatingsystem} is not supported!") }
  }

}