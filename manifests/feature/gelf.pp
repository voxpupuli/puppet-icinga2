# == Class: icinga2::feature::gelf
#
# This module configures the Icinga2 feature gelf.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature gelf, absent disables it. Default is present.
#
# [*host*]
#   GELF receiver host address. Default is '127.0.0.1'.
#
# [*port*]
#   GELF receiver port. Default is 12201.
#
# [*source*]
#   Source name for this instance. Default is icinga2.
#
# [*enable_send_perfdata*]
#   Enable performance data for 'CHECK RESULT' events. Default is false.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::gelf(
  $ensure               = present,
  $host                 = '127.0.0.1',
  $port                 = '12201',
  $source               = 'icinga2',
  $enable_send_perfdata = false,
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_ip_address($host)
  validate_integer($port)
  validate_string($source)
  validate_bool($enable_send_perfdata)

  icinga2::feature { 'gelf':
    ensure => $ensure,
  }
}
