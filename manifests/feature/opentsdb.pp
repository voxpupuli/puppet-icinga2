# == Class: icinga2::feature::opentsdb
#
# This module configures the Icinga2 feature opentsdb.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature opentsdb, absent disables it. Default is present.
#
# [*host*]
#   OpenTSDB host address. Default is '127.0.0.1'.
#
# [*port*]
#   OpenTSDB port. Default is 4242.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::opentsdb(
  $ensure               = present,
  $host                 = '127.0.0.1',
  $port                 = '4242',
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_ip_address($host)
  validate_integer($port)

  icinga2::feature { 'opentsdb':
    ensure => $ensure,
  }
}
