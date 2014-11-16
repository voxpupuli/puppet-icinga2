# Class: icinga2::nrpe
#
# This subclass manages Icinga client components. This class is just the entry point for Puppet to get at the
# icinga2::nrpe:: subclasses.
#

class icinga2::nrpe (

  $nrpe_listen_port                       = $icinga2::params::nrpe_listen_port,
  $nrpe_debug_level                       = $icinga2::params::nrpe_debug_level,
  $nrpe_log_facility                      = $icinga2::params::nrpe_log_facility,
  $nrpe_command_timeout                   = $icinga2::params::nrpe_command_timeout,
  $nrpe_connection_timeout                = $icinga2::params::nrpe_connection_timeout,
  $nrpe_allowed_hosts                     = $icinga2::params::nrpe_allowed_hosts,
  $nrpe_allow_command_argument_processing = $icinga2::params::allow_command_argument_processing,
  $nrpe_purge_unmanaged                   = $icinga2::params::nrpe_purge_unmanaged,

) inherits icinga2::params {

  #Do some validation of the parameters that are passed in:
  validate_string($nrpe_log_facility)
  validate_array($nrpe_allowed_hosts)

  #Apply our classes in the right order. Use the squiggly arrows (~>) to ensure that the
  #class left is applied before the class on the right and that it also refreshes the
  #class on the right.
  class {'icinga2::nrpe::install':} ~>
  class {'icinga2::nrpe::config':} ~>
  class {'icinga2::nrpe::service':}
}
