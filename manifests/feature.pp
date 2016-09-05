# == Define: icinga2::feature
#
# Private define resource to used by this module only.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
define icinga2::feature(
  $ensure  = present,
  $feature = $title,
) {

  #  if $module_name != $caller_module_name {
  #  fail("icinga2::feature is a private define resource of the module icinga2, you're not permitted to use it.")
  #}

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  $user     = $icinga2::params::user
  $group    = $icinga2::params::group
  $conf_dir = $icinga2::params::conf_dir

  if $::osfamily != 'windows' {
    file { "${conf_dir}/features-enabled/${feature}.conf":
      ensure  => $ensure ? {
        'present' => link,
        default   => absent,
      },
      owner   => 'root',
      group   => 'root',
      target  => "../features-available/${feature}.conf",
      #seluser => 'unconfined_u',
      notify  => Class['icinga2::service'],
    }
  }

}
