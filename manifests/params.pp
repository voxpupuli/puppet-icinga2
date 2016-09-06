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

  case $::osfamily {
    'redhat': {
      $user     = 'icinga'
      $group    = 'icinga'
      $conf_dir = '/etc/icinga2'
    }
    'debian': {
      $user     = 'nagios'
      $group    = 'nagios'
      $conf_dir = '/etc/icinga2'
    }
    'windows': {
      $user     = 'SYSTEM'
      $conf_dir = 'C:/ProgramData/icinga2/etc/icinga2'
    }
    default: {
      fail("Your plattform ${::osfamily} is not supported, yet.")
    }
  }

}
