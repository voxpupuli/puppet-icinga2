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

  #File resource for /etc/icinga2/icinga2.conf:
  file { '/etc/icinga2/icinga2.conf':
    path    => '/etc/icinga2/icinga2.conf',
    ensure  => file,
    owner   => $etc_icinga2_icinga2_conf_owner,
    group   => $etc_icinga2_icinga2_conf_group,
    mode    => $etc_icinga2_icinga2_conf_mode,
    content => template('icinga2/icinga2.conf.erb'),
  }
  
}