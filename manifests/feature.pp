# == Define: icinga2::feature
#
# Private define resource to used by this module only.
#
#
define icinga2::feature(
  $ensure  = present,
  $feature = $title,
) {

  assert_private()

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  $user     = $::icinga2::params::user
  $group    = $::icinga2::params::group
  $conf_dir = $::icinga2::params::conf_dir

  File {
    owner => $user,
    group => $group,
  }

  if $::osfamily != 'windows' {
    $_ensure = $ensure ? {
      'present' => link,
      default   => absent,
    }

    file { "${conf_dir}/features-enabled/${feature}.conf":
      ensure  => $_ensure,
      target  => "../features-available/${feature}.conf",
      require => Concat["${conf_dir}/features-available/${feature}.conf"],
      notify  => Class['::icinga2::service'],
    }
  } else {
    $_ensure = $ensure ? {
      'present' => file,
      default   => absent,
    }

    file { "${conf_dir}/features-enabled/${feature}.conf":
      ensure  => $_ensure,
      content => "include \"../features-available/${feature}.conf\"\r\n",
      require => Concat["${conf_dir}/features-available/${feature}.conf"],
      notify  => Class['::icinga2::service'],
    }
  }

}
