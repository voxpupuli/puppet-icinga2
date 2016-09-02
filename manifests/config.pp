# == Class: icinga2::config
#
# Private class to used by this module only.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::config inherits icinga2::params {

  if $module_name != $caller_module_name {
    fail("icinga2::config is a private class of the module icinga2, you're not permitted to use it.")
  }

  $constants = merge($icinga2::params::constants, $icinga2::constants)

  if $::kernel != 'windows' {
    $template_constants = template('icinga2/constants.conf.erb')
  } else {
    $template_constants = regsubst(template('icinga2/constants.conf.erb'), '\n', "\r\n", 'EMG')
  }

  file { "${conf_dir}/constants.conf":
    ensure  => file,
    content => $template_constants,
  }

}
