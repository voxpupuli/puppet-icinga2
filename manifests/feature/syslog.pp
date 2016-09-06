class icinga2::feature::syslog(
  $ensure   = present,
  $severity = 'warning',
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_re($severity, ['^information$','^notice$','^warning$','^debug$'])

  icinga2::feature { 'syslog':
    ensure => $ensure,
  }
}

