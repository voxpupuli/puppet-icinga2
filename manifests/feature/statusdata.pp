# == Class: icinga2::feature::statusdata
#
# This module configures the Icinga2 feature statusdata.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature statusdata, absent disables it. Defaults to present.
#
# [*status_path*]
#   Absolute path to the status.dat file. Default depends on platform:
#   /var/cache/icinga2/status.dat on Linux
#   C:/ProgramData/icinga2/var/cache/icinga2/status.dat on Windows
#
# [*object_path*]
#   Absolute path to the object.cache file. Default depends on platform:
#   /var/cache/icinga2/object.cache on Linux
#   C:/ProgramData/icinga2/var/cache/icinga2/object.cache on Windows
#
# [*update_interval*]
#   Interval in seconds to update both status files.
#   You can also specify it in minutes with the letter m or in seconds with s. Defaults to '30s'
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::statusdata(
  $ensure          = present,
  $status_path     = "${::icinga2::params::cache_dir}/status.dat",
  $objects_path    = "${::icinga2::params::cache_dir}/objects.cache",
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
