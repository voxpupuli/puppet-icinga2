# == Class: icinga2::feature::notification
#
# This module configures the Icinga2 feature notification.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   Set to present enables the feature notification, absent disabled it. Default to present.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::notification(
  $ensure = present,
) inherits icinga2::params {

  icinga2::feature { 'notification':
    ensure => $ensure,
  }
}
