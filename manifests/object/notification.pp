# == Defined type: icinga2::object::notification
#
# This is a defined type for Icinga 2 apply objects that create notification commands
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-notification
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::notification (
  $object_notificationname = $name,
  $command                 = undef,
  $host_name               = undef,
  $service_name            = undef,
  $vars                    = {},
  $users                   = [],
  $user_groups             = [],
  $times                   = {},
  $interval                = undef,
  $period                  = undef,
  $types                   = [],
  $states                  = [],
  $target_dir              = '/etc/icinga2/objects/notifications',
  $target_file_name        = "${name}.conf",
  $target_file_ensure      = file,
  $target_file_owner       = 'root',
  $target_file_group       = 'root',
  $target_file_mode        = '0644',
  $refresh_icinga2_service = true
) {

  #Do some validation of the class' parameters:
  validate_string($object_notificationname)
  validate_string($command)
  if $host_name {
    validate_string($host_name)
  }
  if $service_name {
    validate_string($service_name)
  }
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
  #Array concatenation not available,
  #if $types - ['DowntimeStart','DowntimeEnd','DowntimeRemoved','Custom','Acknowledgement','Problem','Recovery','FlappingStart','FlappingEnd'] != [] {
  #  fail ('You are using unavailable notification type filter.')
  #}
  validate_array($states)
  #Array concatenation not available,
  #if $states - ['OK','Warning','Critical','Unknown','Up','Down'] != [] {
  #  fail ('You are using unavailable state type filter.')
  #}
  validate_string($target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_re($target_file_mode, '^\d{4}$')
  validate_bool($refresh_icinga2_service)

  #If the refresh_icinga2_service parameter is set to true...
  if $refresh_icinga2_service == true {

    file { "${target_dir}/${target_file_name}":
      ensure  => $target_file_ensure,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template('icinga2/object_notification.conf.erb'),
      #...notify the Icinga 2 daemon so it can restart and pick up changes made to this config file...
      notify  => Service['icinga2'],
    }

  }
  #...otherwise, use the same file resource but without a notify => parameter: 
  else {
  
    file { "${target_dir}/${target_file_name}":
      ensure  => $target_file_ensure,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template('icinga2/object_notification.conf.erb'),
    }
  
  }

}
