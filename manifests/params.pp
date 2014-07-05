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
  # Icinga 2 common parameters
  ##############################

  #This section has parameters that are used by both the client and server subclasses

  ##################
  # Icinga 2 common package parameters
  case $operatingsystem {
    #Red Hat/CentOS systems:
    'RedHat', 'CentOS': {      
      #Pick the right package provider:
      $package_provider = 'yum'
    } 
    
    #Debian/Ubuntu systems: 
    /^(Debian|Ubuntu)$/: {
      #Pick the right package provider:
      $package_provider = 'apt'
    }
    
    #Fail if we're on any other OS:
    default: { fail("${operatingsystem} is not supported!") }
  }

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

  #Pick the right package parameters based on the OS:
  case $operatingsystem {
    #Red Hat/CentOS systems:
    'RedHat', 'CentOS': {
      #Icinga 2 server package
      $icinga2_server_package = 'icinga2'
    }
    
    #Debian/Ubuntu systems: 
    /^(Debian|Ubuntu)$/: {
      #Icinga 2 server package
      $icinga2_server_package = 'icinga2'
    }
    
    #Fail if we're on any other OS:
    default: { fail("${operatingsystem} is not supported!") }
  }

  ##############################
  # Icinga 2 client parameters
  ##############################
  
  ##################
  # Icinga 2 client settings 
  $nrpe_listen_port        = '5666'
  $nrpe_log_facility       = 'daemon'
  $nrpe_debug_level        = '0'
  #in seconds:
  $nrpe_command_timeout    = '60'
  #in seconds:
  $nrpe_connection_timeout = '300'
  #Note: because we use .join in the nrpe.cfg.erb template, this value *must* be an array 
  $nrpe_allowed_hosts      = ['127.0.0.1',]
   
  case $operatingsystem {
    #File and template variable names for Red Had/CentOS systems:
    'RedHat', 'CentOS': {
      $nrpe_config_basedir = "/etc/nagios"
      $nrpe_plugin_liddir  = "/usr/lib64/nagios/plugins"
      $nrpe_pid_file_path  = "/var/run/nrpe/nrpe.pid"
      $nrpe_user           = "nrpe"
      $nrpe_group          = "nrpe"
    }
    #File and template variable names for Debian/Ubuntu systems:
    /^(Debian|Ubuntu)$/: {
      $nrpe_config_basedir  = "/etc/nagios"
      $nrpe_plugin_liddir   = "/usr/lib/nagios/plugins"
      $nrpe_pid_file_path   = "/var/run/nagios/nrpe.pid"
      $nrpe_user            = "nagios"
      $nrpe_group           = "nagios"
    }
    #Fail if we're on any other OS:
    default: { fail("${operatingsystem} is not supported!") }
  }

}