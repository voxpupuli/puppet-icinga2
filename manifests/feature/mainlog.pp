# @summary
#   Configures the Icinga 2 feature mainlog.
#
# @param ensure
#   Set to 'present' enables the feature mainlog, 'absent' disabled it.
#
# @param severity
#   You can set the log severity to 'information', 'notice', 'warning' or 'debug'.
#
# @param path
#   Absolute path to the log file.
#
class icinga2::feature::mainlog(
  Enum['absent', 'present']    $ensure   = present,
  Icinga2::LogSeverity         $severity = 'information',
  Stdlib::Absolutepath         $path     = "${::icinga2::globals::log_dir}/icinga2.log",
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
    severity => $severity,
    path     => $path,
  }

  # create object
  icinga2::object { 'icinga2::object::FileLogger::mainlog':
    object_name => 'main-log',
    object_type => 'FileLogger',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/mainlog.conf",
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'mainlog':
    ensure      => $ensure,
  }

}
