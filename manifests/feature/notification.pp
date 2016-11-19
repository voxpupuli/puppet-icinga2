# == Class: icinga2::feature::notification
#
# This module configures the Icinga2 feature notification.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature notification, absent disabled it. Defaults to present.
#
# === Authors
#
# Icinga Development Team <info@icinga.com>
#
class icinga2::feature::notification(
  $ensure = present,
) {

  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  # create object
  icinga2::object { "icinga2::object::NotificationComponent::notification":
    object_name => 'notification',
    object_type => 'NotificationComponent',
    attrs       => {},
    target      => "${conf_dir}/features-available/notification.conf",
    order       => '10',
    notify      => $ensure ? {
      'present' => Class['::icinga2::service'],
      default   => undef,
    },
  }

  # import library 'notification'
  concat::fragment { 'icinga2::feature::notification':
    target  => "${conf_dir}/features-available/notification.conf",
    content => "library \"notification\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'notification':
    ensure      => $ensure,
  }

}
