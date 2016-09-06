class icinga2::feature::command(
  $ensure       = present,
  $command_path = "${run_dir}/cmd/icinga2.cmd",
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($command_path)

  icinga2::feature { 'command':
    ensure => $ensure,
  }
}
