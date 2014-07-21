# Define icinga2::nrpe::plugin
#
# This defined type distributes .
#
# Parameters:
# * $plugin_name = What Puppet knows this plugin resource as. This is used to create the 
#                  filenameon the client machine in the file resource. By default, it's 
#                  taken from the resource's name
#
# * $nrpe_plugin_liddir = The directory where the NRPE plugins themselves live
#
# * $source_file = The file that will get distributed to Icinga client machines. This can 
#                  be anywhere on your Puppet master. See  http://docs.puppetlabs.com/references/3.stable/type.html#file-attribute-source
#                  for more info on what formats of URLs you can use to specify which files
#                  you want to distribute.

define icinga2::nrpe::plugin (
  $plugin_name        = $name,
  $nrpe_plugin_liddir = $icinga2::params::nrpe_plugin_liddir,
  $source_file        = undef,
) {

  file { "${nrpe_plugin_liddir}/${plugin_name}":
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    source => $source_file,
    require => Package[$icinga2::params::icinga2_client_packages],
    notify  => Service[$icinga2::params::nrpe_daemon_name]
  }
  
  
}