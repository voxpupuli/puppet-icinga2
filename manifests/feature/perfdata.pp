class icinga2::feature::perfdata(
  $ensure                = present,
  $host_perfdata_path    = "${spool_dir}/perfdata/host-perfdata",
  $service_perfdata_path = "${spool_dir}/perfdata/service-perfdata",
  $rotation_interval     = '15s',
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($host_perfdata_path)
  validate_absolute_path($service_perfdata_path)
  validate_re($rotation_interval, '^\d+[ms]*$')

  icinga2::feature { 'perfdata':
    ensure => $ensure,
  }
}
