# == Class: icinga2::server::service
#
# This class mangages the daemons of the server components for the Icinga 2 monitoring system.
#
# === Parameters
#
# Coming soon...
#
# === Examples
#
# Coming soon...
#

class icinga2::server::service inherits icinga2::server {

  include icinga2::server

  #Service resource for the Icinga 2 daemon:
  service {$icinga2::params::icinga2_server_service_name:
    ensure    => running,
    subscribe => [ Class['icinga2::server::config'], Class['icinga2::server::features'] ],
  }

}
