# @summary
#   Configures the Icinga 2 feature mainlog.
#
# @param ensure
#   Set to present enables the feature mainlog, absent disables it.
#
# @param path
#   Absolute path to the log file.
#
class icinga2::feature::debuglog(
  Enum['absent', 'present'] $ensure   = present,
  Stdlib::Absolutepath      $path     = "${::icinga2::globals::log_dir}/debug.log",
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
    severity => 'debug',
    path     => $path,
  }

  # create object
  icinga2::object { 'icinga2::object::FileLogger::debuglog':
    object_name => 'debug-file',
    object_type => 'FileLogger',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/debuglog.conf",
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'debuglog':
    ensure => $ensure,
  }
}
