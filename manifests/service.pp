# == Class: icinga2::service
#
# Private class to used by this module only.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::service inherits icinga2::params {

  if $module_name != $caller_module_name {
    fail("icinga2::service is a private class of the module icinga2, you're not permitted to use it.")
  }

  $ensure = $icinga2::ensure
  $enable = $icinga2::enable

  if $icinga2::manage_service {
    service { $service:
      ensure => $ensure,
      enable => $enable,
    }
  }

}
