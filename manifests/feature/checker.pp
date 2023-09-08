# @summary
#   Configures the Icinga 2 feature checker.
#
# @param ensure
#   Set to present enables the feature checker, absent disabled it.
#
class icinga2::feature::checker (
  Enum['absent', 'present'] $ensure            = present,
) {
  if ! defined(Class['icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir = $icinga2::globals::conf_dir
  $_notify  = $ensure ? {
    'present' => Class['icinga2::service'],
    default   => undef,
  }

  # create object
  icinga2::object { 'icinga2::object::CheckerComponent::checker':
    object_name => 'checker',
    object_type => 'CheckerComponent',
    target      => "${conf_dir}/features-available/checker.conf",
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'checker':
    ensure => $ensure,
  }
}
