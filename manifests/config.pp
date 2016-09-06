# == Class: icinga2::config
#
# This class exists to manage general configuration files needed by Icinga2 to run.
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
class icinga2::config inherits icinga2::params {

  if $module_name != $caller_module_name {
    fail("icinga2::config is a private class of the module icinga2, you're not permitted to use it.")
  }

}
