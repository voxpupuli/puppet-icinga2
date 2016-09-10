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

  if defined($caller_module_name) and $module_name != $caller_module_name {
    fail("icinga2::feature is a private define resource of the module icinga2, you're not permitted to use it.")
  }

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  $user     = $::icinga2::params::user
  $group    = $::icinga2::params::group
  $conf_dir = $::icinga2::params::conf_dir

  file { "${conf_dir}/features-available/${feature}.conf":
    ensure  => file,
    content => $::osfamily ? {
      'windows' => regsubst(template("icinga2/feature/${feature}.conf.erb"), '\n', "\r\n", 'EMG'),
      default   => template("icinga2/feature/${feature}.conf.erb"),
    },
    require => Class['icinga2::install'],
    notify  => $ensure ? {
      'present' => Class['icinga2::service'],
      default   => undef,
    },
  }

  if $::osfamily != 'windows' {
    file { "${conf_dir}/features-enabled/${feature}.conf":
      ensure  => $ensure ? {
        'present' => link,
        default   => absent,
      },
      owner   => 'root',
      group   => 'root',
      target  => "../features-available/${feature}.conf",
      notify  => Class['icinga2::service'],
    }
  } else {
    file { "${conf_dir}/features-enabled/${feature}.conf":
      ensure  => $ensure ? {
        'present' => file,
        default   => absent,
      },
      owner   => $user,
      group   => $group,
      content => "include \"../features-available/${feature}.conf\"\r\n",
      require => File["${conf_dir}/features-available/${feature}.conf"],
      notify  => Class['icinga2::service'],
    }
  }

}
