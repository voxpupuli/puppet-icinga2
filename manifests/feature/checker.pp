# @summary
#   Configures the Icinga 2 feature checker.
#
# @param ensure
#   Set to present enables the feature checker, absent disabled it.
#
# @param concurrent_checks
#   The maximum number of concurrent checks.
#
# @note Deprecated in Icinga 2.11, replaced by global constant
#   MaxConcurrentChecks which will be set if you still use concurrent_checks.
#
class icinga2::feature::checker(
  Enum['absent', 'present'] $ensure            = present,
  Optional[Integer[1]]      $concurrent_checks = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir = $::icinga2::globals::conf_dir
  $_notify  = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  # compose attributes
  $attrs = {
    concurrent_checks => $concurrent_checks,
  }

  # create object
  icinga2::object { 'icinga2::object::CheckerComponent::checker':
    object_name => 'checker',
    object_type => 'CheckerComponent',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/checker.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'checker'
  concat::fragment { 'icinga2::feature::checker':
    target  => "${conf_dir}/features-available/checker.conf",
    content => "library \"checker\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'checker':
    ensure => $ensure,
  }

}
