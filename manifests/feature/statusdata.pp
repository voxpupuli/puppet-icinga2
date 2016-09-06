class icinga2::feature::statusdata(
  $ensure          = present,
  $status_path     = "${cache_dir}/status.dat",
  $objects_path    = "${cache_dir}/objects.cache",
  $update_interval = '30s',
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
      "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($status_path)
  validate_absolute_path($objects_path)
  validate_re($update_interval, '^\d+[ms]*$')

  icinga2::feature { 'statusdata':
    ensure => $ensure,
  }
}
