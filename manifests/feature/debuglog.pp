class icinga2::feature::debuglog(
  $ensure = present,
  $path   = "${log_dir}/debug.log",
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($path)

  icinga2::feature { 'debuglog':
    ensure => $ensure,
  }
}
