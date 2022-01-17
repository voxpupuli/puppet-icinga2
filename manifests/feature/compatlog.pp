# @summary
#   Configures the Icinga 2 feature compatlog.
#
# @param ensure
#   Set to present enables the feature compatlog, absent disabled it.
#
# @param log_dir
#   Absolute path to the log directory.
#
# @param rotation_method
#   Sets how often should the log file be rotated.
#
class icinga2::feature::compatlog(
  Enum['absent', 'present']                                 $ensure          = present,
  Optional[Stdlib::Absolutepath]                            $log_dir         = undef,
  Optional[Enum['DAILY', 'HOURLY', 'MONTHLY', 'WEEKLY']]    $rotation_method = undef,
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
    log_dir         => $log_dir,
    rotation_method => $rotation_method,
  }

  # create object
  icinga2::object { 'icinga2::object::CompatLogger::compatlog':
    object_name => 'compatlog',
    object_type => 'CompatLogger',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/compatlog.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'compat'
  concat::fragment { 'icinga2::feature::compatlog':
    target  => "${conf_dir}/features-available/compatlog.conf",
    content => "library \"compat\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'compatlog':
    ensure => $ensure,
  }
}
