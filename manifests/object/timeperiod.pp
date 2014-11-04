# == Defined type: icinga2::object::timeperiod
#
#  This is a defined type for Icinga 2 host objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/monitoring-basics#timeperiods
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::timeperiod (
  $object_timeperiod_name       = $name,
  $timeperiod_display_name      = undef,
  $timeperiod_ranges            = {},
  $timeperiod_target_dir        = '/etc/icinga2/objects/timeperiods',
  $timeperiod_target_file_name  = "${name}.conf",
  $timeperiod_target_file_owner = 'root',
  $timeperiod_target_file_group = 'root',
  $timeperiod_target_file_mode  = '0644',
) {

  # Do some validation of the class' parameters:
  validate_string($object_timeperiod_name)
  validate_string($timeperiod_display_name)
  validate_hash($timeperiod_ranges)
  validate_string($timeperiod_target_dir)
  validate_string($timeperiod_target_file_name)
  validate_string($timeperiod_target_file_owner)
  validate_string($timeperiod_target_file_group)
  validate_re($timeperiod_target_file_mode, '^\d{4}$')

  file {"${timeperiod_target_dir}/${timeperiod_target_file_name}":
    ensure  => file,
    owner   => $timeperiod_target_file_owner,
    group   => $timeperiod_target_file_group,
    mode    => $timeperiod_target_file_mode,
    content => template('icinga2/object_timeperiod.conf.erb'),
    notify  => Service['icinga2'],
  }
  
}
