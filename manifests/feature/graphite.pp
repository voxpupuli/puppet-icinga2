# == Class: icinga2::feature::graphite
#
# This module configures the Icinga2 feature graphite.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature graphite, absent disabled it. Default is present.
#
# [*host*]
#   Graphite Carbon host address. Default is '127.0.0.1'.
#
# [*port*]
#   Graphite Carbon port. Default is 2003.
#
# [*host_name_template*]
#   Template for metric path of hosts. Default is 'icinga2.$host.name$.host.$host.check_command$'.
#
# [*service_name_template*]
#   Template for metric path of services. Default is 'icinga2.$host.name$.services.$service.name$.$service.check_command$'.
#
# [*enable_send_thresholds*]
#   Send threholds as metrics. Default is false.
#
# [*enable_send_metadata*]
#   Send metadata as metrics. Default is false.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::graphite(
  $ensure                 = present,
  $host                   = '127.0.0.1',
  $port                   = '2003',
  $host_name_template     = 'icinga2.$host.name$.host.$host.check_command$',
  $service_name_template  = 'icinga2.$host.name$.services.$service.name$.$service.check_command$',
  $enable_send_thresholds = false,
  $enable_send_metadata   = false,
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_ip_address($host)
  validate_integer($port)
  validate_string($host_name_template)
  validate_string($service_name_template)
  validate_bool($enable_send_thresholds)
  validate_bool($enable_send_metadata)

  icinga2::feature { 'graphite':
    ensure => $ensure,
  }
}
