# == Class: icinga2::feature::checker
#
# This module configures the Icinga 2 feature checker.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature checker, absent disabled it. Defaults to present.
#
#
class icinga2::feature::checker(
  $ensure = present,
  $concurrent_checks = undef,
) {

  $conf_dir = $::icinga2::params::conf_dir
  $_default_attrs = {}

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")

  if $concurrent_checks {
     validate_integer($concurrent_checks)
     if $concurrent_checks < 0 {
       fail('$concurrent_checks needs to be an integer, either zero or positiv.')
     }
     $_concurrent_checks = $concurrent_checks
  }

  if $_concurrent_checks {
    $_attrs = {
      concurrent_checks => $_concurrent_checks,
    }
  } else {
    $_attrs = $_default_attrs
  }

  # create object
  icinga2::object { 'icinga2::object::CheckerComponent::checker':
    object_name => 'checker',
    object_type => 'CheckerComponent',
    attrs       => delete_undef_values($_attrs),
    #attrs_list  => keys($_attrs),
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
