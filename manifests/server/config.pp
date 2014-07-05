# == Class: icinga2::server::config
#
# This class configures the server components for the Icinga 2 monitoring system.
#
# === Parameters
#
# Coming soon...
#
# === Examples
# 
# Coming soon...
# 

class icinga2::server::config inherits icinga2::server {
  
  include icinga2::params
  #Directory resource for /etc/icinga2/
  file { '/etc/icinga2/':
    path    => '/etc/icinga2/',
    ensure  => directory,
    owner   => $etc_icinga2_owner,
    group   => $etc_icinga2_group,
    mode    => $etc_icinga2_mode,
    #require => Package[$icinga2::params::icinga2_server_packages],
  }


  
}