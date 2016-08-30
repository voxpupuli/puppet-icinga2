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
      default: {
        fail('Your plattform is not supported to manage a repository.')
      }
    }

  } # if $icinga::manage_repo

}
