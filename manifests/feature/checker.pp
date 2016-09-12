# == Class: icinga2::feature::checker
#
# This module configures the Icinga2 feature checker.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature checker, absent disabled it. Default is present.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::checker(
  $ensure = present,
) {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  icinga2::feature { 'checker':
    ensure => $ensure,
  }
}
