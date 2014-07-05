# Class: icinga2::client::config
#
# This subclass configures Icinga clients.
#

class icinga2::client::config inherits icinga2::client {
  
  include icinga2::client
  
  #config resources here
 
  #The NRPE configuration base directory:
  file { $nrpe_config_basedir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require   => Package[$icinga2::params::icinga2_client_packages],
  }
  
  #The folder that will hold our command definition files:
  file { '/etc/nagios/nrpe.d':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    require   => Package[$icinga2::params::icinga2_client_packages],
  }

  #File resource for /etc/nagios/nrpe.cfg
  file { '/etc/nagios/nrpe.cfg':
    path    => '/etc/nagios/nrpe.cfg',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    content => template('icinga2/nrpe.cfg.erb'),
    require   => Package[$icinga2::params::icinga2_client_packages],
  }

}
