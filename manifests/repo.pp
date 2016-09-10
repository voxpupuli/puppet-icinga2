# == Class: icinga2::repo
#
# This class manages the packages.icinga.org repository based on the operating system. Windows is not supported, as the
# Icinga Project does not offer a chocolate repository.
#
# === Parameters
#
# This class does not provide any parameters.
# To control the behaviour of this class, have a look at the parameters:
# * icinga2::manage_repo
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::repo {

  if $module_name != $caller_module_name {
    fail("icinga2::repo is a private class of the module icinga2, you're not permitted to use it.")
  }

  if $::icinga2::manage_repo {

    case $::osfamily {
      'redhat': {
        case $::operatingsystem {
          'centos', 'redhat': {
            yumrepo { 'icinga-stable-release':
              baseurl  => "http://packages.icinga.org/epel/${::operatingsystemmajrelease}/release/",
              descr    => 'ICINGA (stable release for epel)',
              enabled  => 1,
              gpgcheck => 1,
              gpgkey   => 'http://packages.icinga.org/icinga.key',
            }
          }
          default: {
            fail('Your plattform is not supported to manage a repository.')
          }
        }
      }
      'debian': {
        case $::operatingsystem {
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
          'ubuntu': {
            apt::source { 'icinga-stable-release':
              location    => 'http://packages.icinga.org/ubuntu',
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
      }
      'windows': {
        warning("The Icinga Project doesn't offer chocolaty packages at the moment.")
      }
      default: {
        fail('Your plattform is not supported to manage a repository.')
      }
    }

  } # if $::icinga::manage_repo

}
