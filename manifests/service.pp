# == Class: icinga2::service
#
# This class handles the Icinga2 service. By default the service will start on boot and will be restarted if stopped.
#
# === Parameters
#
# This class does not provide any parameters.
# To control the behaviour of this class, have a look at the parameters:
# * icinga2::ensure
# * icinga2::enable
#
# === Examples
#
# This class is private and should not be called by others than this module.
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
