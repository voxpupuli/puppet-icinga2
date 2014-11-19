# == Defined type: icinga2::object::apply_notification_to_service
#
#  This is a defined type for Icinga 2 apply dependency objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-notification
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#apply
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::apply_notification_to_service (
  $object_notificationname = $name,
  $host_name               = undef,
  $notification_to_import  = undef,
  $assign_where            = undef,
  $ignore_where            = undef,
  $command                 = undef,
  $vars                    = {},
  $users                   = [],
  $user_groups             = [],
  $times                   = {},
  $interval                = undef,
  $period                  = undef,
  $types                   = [],
  $states                  = [],
  $target_dir              = '/etc/icinga2/objects/applys',
  $target_file_name        = "${name}.conf",
  $target_file_ensure      = file,
  $target_file_owner       = 'root',
  $target_file_group       = 'root',
  $target_file_mode        = '0644'
) {

  #Do some validation of the class' parameters:
  validate_string($object_notificationname)
  validate_string($host_name)
  validate_string($notification_to_import)
  validate_string($command)
  validate_hash($vars)
  validate_array($users)
  validate_array($user_groups)
  validate_hash($times)
  if $interval {
    validate_re($interval, '^\d$')
  }
  if $period {
    validate_string($period)
  }
  validate_array($types)
  validate_array($states)
  validate_string($target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_re($target_file_mode, '^\d{4}$')

  file { "${target_dir}/${target_file_name}":
    ensure  => $target_file_ensure,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_apply_notification_to_service.conf.erb'),
    notify  => Service['icinga2'],
  }
}
