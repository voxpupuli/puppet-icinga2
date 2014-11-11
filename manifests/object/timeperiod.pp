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
  $object_name                   = $name,
  $timeperiod_template_to_import = 'legacy-timeperiod',
  $timeperiod_display_name       = undef,
  $methods                       = undef,
  $ranges                        = {},
  $timeperiod_target_dir         = '/etc/icinga2/objects/timeperiods',
  $timeperiod_target_file_name   = "${name}.conf",
  $target_file_owner             = 'root',
  $target_file_group             = 'root',
  $target_file_mode              = '0644',
) {

  # Do some validation of the class' parameters:
  validate_string($object_name)
  validate_string($timeperiod_template_to_import)
  validate_string($timeperiod_display_name)
  if $methods {
    validate_string($methods)
  }
  validate_hash($ranges)
  validate_string($timeperiod_target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_re($target_file_mode, '^\d{4}$')

  file {"${timeperiod_target_dir}/${timeperiod_target_file_name}":
    ensure  => file,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_timeperiod.conf.erb'),
    notify  => Service['icinga2'],
  }
}
