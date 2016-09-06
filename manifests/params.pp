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

  $package = 'icinga2'
  $service = 'icinga2'

  case $::osfamily {
    'redhat': {
    }
    'debian': {
    }
    'windows': {
    }
    default: {
      fail("Your plattform ${::osfamily} is not supported, yet.")
    }
  }

}
