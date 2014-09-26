# Class: icinga2::nrpe::service
#
# This class manges the daemons/services for the server components of Icinga.
#
# Parameters:

class icinga2::nrpe::service inherits icinga2::nrpe {

  include icinga2::nrpe

  #Service resource for NRPE.
  #This references the daemon name we defined in the icinga2::params class based on the OS:
  service {$icinga2::params::nrpe_daemon_name:
    ensure    => running,
    enable    => true, #Enable the service to start on system boot
    require   => Package[$icinga2::params::icinga2_client_packages],
    subscribe => Class['icinga2::nrpe::config'], #Subscribe to the client::config class so the service gets restarted if any config files change
  }

}
