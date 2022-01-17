# @summary
#   Configures the Icinga 2 feature perfdata.
#
# @param ensure
#   Set to present enables the feature perfdata, absent disables it.
#
# @param host_perfdata_path
#   Absolute path to the perfdata file for hosts.
#
# @param service_perfdata_path
#   Absolute path to the perfdata file for services.
#
# @param host_temp_path
#   Path to the temporary host file.
#
# @param service_temp_path
#   Path to the temporary service file.
#
# @param host_format_template
#   Host Format template for the performance data file.
#
# @param service_format_template
#   Service Format template for the performance data file.
#
# @param rotation_interval
#   Rotation interval for the files specified in {host,service}_perfdata_path. Can be written in minutes or seconds,
#   i.e. 1m or 15s.
#
# @param enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
class icinga2::feature::perfdata(
  Enum['absent', 'present']           $ensure                  = present,
  Optional[Stdlib::Absolutepath]      $host_perfdata_path      = undef,
  Optional[Stdlib::Absolutepath]      $service_perfdata_path   = undef,
  Optional[Stdlib::Absolutepath]      $host_temp_path          = undef,
  Optional[Stdlib::Absolutepath]      $service_temp_path       = undef,
  Optional[String]                    $host_format_template    = undef,
  Optional[String]                    $service_format_template = undef,
  Optional[Icinga2::Interval]         $rotation_interval       = undef,
  Optional[Boolean]                   $enable_ha               = undef,
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
    enable_ha               => $enable_ha,
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
