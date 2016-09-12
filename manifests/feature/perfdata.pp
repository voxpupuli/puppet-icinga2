# == Class: icinga2::feature::perfdata
#
# This module configures the Icinga2 feature perfdata.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   Set to present enables the feature perfdata, absent disabled it. Default to present.
#
# [*host_perfdata_path*]
#   Absolute path to the perfdata file for hosts. Default depends on plattform,
#   /var/spool/icinga2/host-perfdata on Linux and C:/ProgramData/icinga2/var/spool/icinga2/host-perfdata
#   on Windows.
#
# [*service_perfdata_path*]
#   Absolute path to the perfdata file for services. Default depends on plattform,
#   /var/spool/icinga2/service-perfdata on Linux and C:/ProgramData/icinga2/var/spool/icinga2/service-perfdata
#   on Windows.
#
# [*host_temp_path*]
#   Path to the temporary host file. Defaults depend on plattforms /var/spool/icinga2/tmp/host-perfdata
#   on Linux and C:/ProgramData/icinga2/var/spool/icinga2/tmp/host-perfdata on Windows.
#
# [*service_temp_path*]
#   Path to the temporary service file. Defaults depend on plattforms /var/spool/icinga2/tmp/host-perfdata
#   on Linux and C:/ProgramData/icinga2/var/spool/icinga2/tmp/host-perfdata on Windows.
#
# [*host_format_template*] NOT IMPLEMENTED
#   Host Format template for the performance data file. Defaults to a template that's suitable
#   for use with PNP4Nagios.
#
# [*service_format_template*] NOT IMPLEMENTED
#   Service Format template for the performance data file. Defaults to a template that's
#   suitable for use with PNP4Nagios.
#
# [*rotation_interval*]
#   Rotation interval for the files specified in {host,service}_perfdata_path. Can be
#   written in minutes or seconds, i.e. 1m or 15s. Defaults to 30 seconds.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::perfdata(
  $ensure                = present,
  $host_perfdata_path    = "${::icinga2::params::spool_dir}/perfdata/host-perfdata",
  $service_perfdata_path = "${::icinga2::params::spool_dir}/perfdata/service-perfdata",
  $host_temp_path        = "${::icinga2::params::spool_dir}/tmp/host-perfdata",
  $service_temp_path     = "${::icinga2::params::spool_dir}/tmp/service-perfdata",
  $rotation_interval     = '30s',
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($host_perfdata_path)
  validate_absolute_path($service_perfdata_path)
  validate_absolute_path($host_temp_path)
  validate_absolute_path($service_temp_path)
  validate_re($rotation_interval, '^\d+[ms]*$')

  icinga2::feature { 'perfdata':
    ensure => $ensure,
  }
}
