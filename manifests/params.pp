# == Class: icinga2::params
#
# In this class all default parameters are stored. It is inherited by other classes in order to get access to those
# parameters.
#
# === Parameters
#
# This class does not provide any parameters.
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::params {

  $package          = 'icinga2'
  $service          = 'icinga2'
  $plugins          = [ 'plugins', 'plugins-contrib', 'windows-plugins', 'nscp' ]
  $default_features = [ 'checker', 'mainlog', 'notification' ]

  case $::kernel {

    'linux': {
      $conf_dir  = '/etc/icinga2'
      $log_dir   = '/var/log/icinga2'
      $spool_dir = '/var/spool/icinga2'

      case $::osfamily {
        'redhat': {
          $user     = 'icinga'
          $owner    = 'icinga'
          $lib_dir  = $::architecture ? {
            'x86_64' => '/usr/lib64',
            default  => '/usr/lib',
          }
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
      $owner     = undef
      $conf_dir  = 'C:/ProgramData/icinga2/etc/icinga2'
      $log_dir   = 'C:/ProgramData/icinga2/var/log/icinga2'
      $spool_dir = 'C:/ProgramData/icinga2/var/spool/icinga2'
      $constants = {
        'PluginDir'          => "C:/Program Files/ICINGA2/sbin",
        'PluginContribDir'   => "C:/Program Files/ICINGA2/sbin",
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
