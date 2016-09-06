class icinga2::feature::checker(
  $ensure = present,
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  icinga2::feature { 'checker':
    ensure => $ensure,
  }
}
