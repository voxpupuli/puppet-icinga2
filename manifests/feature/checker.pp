# == Class: icinga2::feature::checker
#
# This module configures the Icinga2 feature checker.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   Set to present enables the feature checker, absent disabled it. Default to present.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::checker(
  $ensure = present,
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  icinga2::feature { 'checker':
    ensure => $ensure,
  }
}
