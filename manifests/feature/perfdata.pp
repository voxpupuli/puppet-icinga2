# == Class: icinga2::feature::perfdata
#
# This module configures the Icinga 2 feature perfdata.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature perfdata, absent disables it. Defaults to present.
#
# [*host_perfdata_path*]
#   Absolute path to the perfdata file for hosts. Default depends on platform:
#   /var/spool/icinga2/host-perfdata on Linux
#   C:/ProgramData/icinga2/var/spool/icinga2/host-perfdata on Windows.
#
# [*service_perfdata_path*]
#   Absolute path to the perfdata file for services. Default depends on platform:
#   /var/spool/icinga2/service-perfdata on Linux
#   C:/ProgramData/icinga2/var/spool/icinga2/service-perfdata on Windows.
#
# [*host_temp_path*]
#   Path to the temporary host file. Defaults depends on platform:
#   /var/spool/icinga2/tmp/host-perfdata on Linux
#   C:/ProgramData/icinga2/var/spool/icinga2/tmp/host-perfdata on Windows.
#
# [*service_temp_path*]
#   Path to the temporary service file. Defaults depends on platform:
#   /var/spool/icinga2/tmp/host-perfdata on Linux
#   C:/ProgramData/icinga2/var/spool/icinga2/tmp/host-perfdata on Windows.
#
# [*host_format_template*]
#   Host Format template for the performance data file.
#   Icinga defaults to a template that's suitable for use with PNP4Nagios.
#
# [*service_format_template*]
#   Service Format template for the performance data file.
#   Icinga defaults to a template that's suitable for use with PNP4Nagios.
#
# [*rotation_interval*]
#   Rotation interval for the files specified in {host,service}_perfdata_path. Can be written in minutes or seconds,
#   i.e. 1m or 15s. Icinga defaults to 30s.
#
#
class icinga2::feature::perfdata(
  Enum['absent', 'present']           $ensure                  = present,
  Optional[Stdlib::Absolutepath]      $host_perfdata_path      = undef,
  Optional[Stdlib::Absolutepath]      $service_perfdata_path   = undef,
  Optional[Stdlib::Absolutepath]      $host_temp_path          = undef,
  Optional[Stdlib::Absolutepath]      $service_temp_path       = undef,
  Optional[String]                    $host_format_template    = undef,
  Optional[String]                    $service_format_template = undef,
  Optional[Pattern[/^\d+[ms]*$/]]     $rotation_interval       = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir = $::icinga2::globals::conf_dir
  $_notify  = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  # compose attributes
  $attrs = {
    host_perfdata_path      => $host_perfdata_path,
    service_perfdata_path   => $service_perfdata_path,
    host_temp_path          => $host_temp_path,
    service_temp_path       => $service_temp_path,
    host_format_template    => $host_format_template,
    service_format_template => $service_format_template,
    rotation_interval       => $rotation_interval,
  }

  # create object
  icinga2::object { 'icinga2::object::PerfdataWriter::perfdata':
    object_name => 'perfdata',
    object_type => 'PerfdataWriter',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/perfdata.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'perfdata'
  concat::fragment { 'icinga2::feature::perfdata':
    target  => "${conf_dir}/features-available/perfdata.conf",
    content => "library \"perfdata\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'perfdata':
    ensure => $ensure,
  }
}
