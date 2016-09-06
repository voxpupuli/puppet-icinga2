class icinga2::feature::mainlog(
  $ensure   = present,
  $severity = 'information',
  $path     = "${log_dir}/icinga2.log",
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_re($severity, ['^information$','^notice$','^warning$','^debug$'])
  validate_absolute_path($path)

  icinga2::feature { 'mainlog':
    ensure => $ensure,
  }
}
