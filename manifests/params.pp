# == Class: icinga2::params
#
# Private class to used by this module only.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::params {

  case $::osfamily {
    'redhat': {
      $package = 'icinga2'
      $service = 'icinga2'
    }
    default: {
      fail("Your plattform ${::osfamily} is not supported, yet.")
    }
  }

}
