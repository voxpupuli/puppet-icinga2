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
  # Icinga 2 server parameters
  ##############################

  #Whether to manage the package repositories
  $manage_repos = 'true'
  $server_db_type = 'pgsql'

  #Database paramters
  $db_name = 'icinga2_data'
  $db_user = 'icinga2'
  $db_password = 'password'
  $db_host = 'localhost'

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
    }
    
    #Debian/Ubuntu systems: 
    /^(Debian|Ubuntu)$/: {
      #Pick the right package provider:
      $package_provider = 'apt'
      #Icinga 2 server package
      $icinga2_server_package = 'icinga2'
    }
    
    #Fail if we're on any other OS:
    default: { fail("${operatingsystem} is not supported!") }
  }

}