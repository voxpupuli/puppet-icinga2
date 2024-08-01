# @summary
#   This class exists to manage general configuration files needed by Icinga 2 to run.
#
# @api private
#
class icinga2::config {
  assert_private()

  $constants      = prefix($icinga2::_constants, 'const ')
  $conf_dir       = $icinga2::globals::conf_dir
  $user           = $icinga2::globals::user
  $group          = $icinga2::globals::group
  $purge_features = $icinga2::purge_features
  $_mainconfig    = epp('icinga2/icinga2.conf.epp',
    { 'plugins' => $icinga2::plugins,
      'confd'   => $icinga2::_confd,
    }
  )

  if $facts['kernel'] != 'windows' {
    $file_permissions    = '0640'
  } else {
    $file_permissions    = undef
  }

  File {
    owner   => $user,
    group   => $group,
    mode    => $file_permissions,
    seltype => 'icinga2_etc_t',
  }

  file { "${conf_dir}/constants.conf":
    ensure  => file,
    content => icinga::newline(icinga2::parse($constants)),
  }

  file { "${conf_dir}/icinga2.conf":
    ensure  => file,
    content => icinga::newline($_mainconfig),
  }

  file { "${conf_dir}/features-enabled":
    ensure  => directory,
    purge   => $purge_features,
    recurse => $purge_features,
  }
}
