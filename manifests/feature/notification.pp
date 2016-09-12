# == Class: icinga2::feature::notification
#
# This module configures the Icinga2 feature notification.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature notification, absent disabled it. Default is present.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::notification(
  $ensure = present,
) {

  icinga2::feature { 'notification':
    ensure => $ensure,
  }
}
