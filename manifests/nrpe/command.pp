# Define icinga2::nrpe::command
#
# This defined type creates NRPE command definitions on machines running NRPE.
#
# Parameters:
# * $command_name = What NRPE will know the command as; this defaults to the title of the resource
# * $nrpe_plugin_libdir = The directory where the NRPE plugins themselves live
# * $nrpe_plugin_name = The name of the plugin the command will run
# * $nrpe_plugin_args = The arguments to pass to the plugin. This may be optional,
#                       depending on the plugin and whether it expects any arguments or parameters

define icinga2::nrpe::command (
  $command_name       = $name,
  $nrpe_plugin_libdir = $icinga2::params::nrpe_plugin_libdir,
  $nrpe_plugin_name   = undef,
  $nrpe_plugin_args   = undef,
) {

  #Do some validation of the class' parameters:
  validate_string($command_name)
  validate_string($nrpe_plugin_libdir)
  validate_string($nrpe_plugin_name)
  validate_string($nrpe_plugin_args)

  file { "/etc/nagios/nrpe.d/${command_name}.cfg":
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    content => template('icinga2/nrpe_command.cfg.erb'),
    require => Package[$icinga2::params::icinga2_client_packages],
    notify  => Service[$icinga2::params::nrpe_daemon_name]
  }

}
