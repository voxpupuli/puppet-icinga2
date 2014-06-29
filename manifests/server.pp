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
  $server_db_type = $icinga2::params::server_db_type
) inherits icinga2::params {

  #Apply our classes in the right order. Use the squiggly arrows (~>) to ensure that the 
  #class left is applied before the class on the right and that it also refreshes the 
  #class on the right.
  class {'icinga2::server::install':} #~>
  #class {'icinga2::server::config':} ~>
  #class {'icinga2::server::service':}
  
}