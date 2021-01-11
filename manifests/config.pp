# @summary
#   This class exists to manage general configuration files needed by Icinga 2 to run.
#
# @api private
#
class icinga2::config {

  assert_private()

  $constants      = prefix($::icinga2::_constants, 'const ')
  $conf_dir       = $::icinga2::globals::conf_dir
  $plugins        = $::icinga2::plugins
  $confd          = $::icinga2::_confd
  $purge_features = $::icinga2::purge_features

  if $::kernel != 'windows' {
    $template_constants  = icinga2_attributes($constants)
    $template_mainconfig = template('icinga2/icinga2.conf.erb')
  } else {
    $template_constants  = regsubst(icinga2_attributes($constants), '\n', "\r\n", 'EMG')
    $template_mainconfig = regsubst(template('icinga2/icinga2.conf.erb'), '\n', "\r\n", 'EMG')
  }

  file { "${conf_dir}/constants.conf":
    owner => $::icinga2::globals::user,
    group => $::icinga2::globals::group,
    ensure  => file,
    content => $template_constants,
  }

  file { "${conf_dir}/icinga2.conf":
    owner => $::icinga2::globals::user,
    group => $::icinga2::globals::group,
    ensure  => file,
    content => $template_mainconfig,
  }

  file { "${conf_dir}/features-enabled":
    owner => $::icinga2::globals::user,
    group => $::icinga2::globals::group,
    ensure  => directory,
    purge   => $purge_features,
    recurse => $purge_features,
  }

}
