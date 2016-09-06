class icinga2::feature::compatlog(
  $ensure          = present,
  $log_dir         = "${log_dir}/compat",
  $rotation_method = 'HOURLY',
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($log_dir)
  validate_re($rotation_method, ['^HOURLY$','^DAILY$','^WEEKLY$','^MONTHLY$'])

  icinga2::feature { 'compatlog':
    ensure => $ensure,
  }
}
