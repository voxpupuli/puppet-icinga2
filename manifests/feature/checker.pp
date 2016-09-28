# == Class: icinga2::feature::checker
#
# This module configures the Icinga2 feature checker.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature checker, absent disabled it. Defaults to present.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::checker(
  $ensure = present,
) {

  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  # create object
  icinga2::object { "icinga2::object::CheckerComponent::checker":
    object_name => 'checker',
    object_type => 'CheckerComponent',
    attrs       => {},
    target      => "${conf_dir}/features-available/checker.conf",
    order       => '10',
    notify      => $ensure ? {
      'present' => Class['::icinga2::service'],
      default   => undef,
    },
  }

  # import library 'checker'
  concat::fragment { 'icinga2::feature::checker':
    target  => "${conf_dir}/features-available/checker.conf",
    content => "library \"checker\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'checker':
    ensure      => $ensure,
  }

}
