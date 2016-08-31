# == Class: icinga2::repo
#
# Private class to used by this module only.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::repo inherits icinga2::params {

  if $module_name != $caller_module_name {
    fail("icinga2::repo is a private class of the module icinga2, you're not permitted to use it.")
  }

  if $icinga2::manage_repo {

    case $::osfamily {
      'redhat': {
        yumrepo { 'icinga-stable-release':
          baseurl  => "http://packages.icinga.org/epel/${::operatingsystemmajrelease}/release/",
          descr    => 'ICINGA (stable release for epel)',
          enabled  => 1,
          gpgcheck => 1,
          gpgkey   => 'http://packages.icinga.org/icinga.key',
        }
      }
      'debian': {
        include apt, apt::backports
        apt::source { 'icinga-stable-release':
          location    => 'http://packages.icinga.org/debian',
          release     => "icinga-${::lsbdistcodename}",
          repos       => 'main',
          key_source  => 'http://packages.icinga.org/icinga.key',
          key         => 'F51A91A5EE001AA5D77D53C4C6E319C334410682',
          include_src => false,
        }
      }
      default: {
        fail('Your plattform is not supported to manage a repository.')
      }
    }

  } # if $icinga::manage_repo

}
