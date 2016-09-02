# == Class: icinga2::params
#
# Private class to used by this module only.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::params {

  $package = 'icinga2'
  $service = 'icinga2'

  case $::kernel {

    'linux': {
      $conf_dir  = '/etc/icinga2'

      case $::osfamily {
        'redhat': {
          $user     = 'icinga'
          $owner    = 'icinga'
          $lib_dir  = '/usr/lib64'
        } # RedHat

        'debian': {
          $user     = 'nagios'
          $owner    = 'nagios'
          $lib_dir  = '/usr/lib'
        } # Debian

        default: {
          fail("Your plattform ${::osfamily} is not supported, yet.")
        }
      } # case $::osfamily

      $constants = {
        'PluginDir'          => "${lib_dir}/nagios/plugins",
        'PluginContribDir'   => "${lib_dir}/nagios/plugins",
        'ManubulonPluginDir' => "${lib_dir}/nagios/plugins",
        'ZoneName'           => $::fqdn,
        'NodeName'           => $::fqdn,
        'TicketSalt'         => '',
      }

    } # Linux

    'windows': {
      $user      = 'SYSTEM'
      $group     = 'None'
      $conf_dir  = 'C:/ProgramData/icinga2/etc/icinga2'
      $constants = {
        'PluginDir'          => "C:/Program Files/ICINGA2/sbin",
        'ManubulonPluginDir' => "C:/Program Files/ICINGA2/sbin",
        'ZoneName'           => $::fqdn,
        'NodeName'           => $::fqdn,
        'TicketSalt'         => '',
      }
    } # Windows

    default: {
      fail("Your plattform ${::osfamily} is not supported, yet.")
    }

  } # case $::kernel

}
