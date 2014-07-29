# == Defined type: icinga2::object::service
#  
# This is a defined type for Icinga 2 service objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-service
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::service (
  $object_servicename = $name,
  $template_to_import = 'generic-service',
  $display_name = $name,
  $host_name = $fqdn,
  $groups = [],
  $vars = {},
  #Parameters to add:
  # * check_command
  # * max_check_attempts
  # * check_period
  # * check_interval
  # * retry_interval
  # * enable_notifications
  # * enable_active_checks
  # * enable_passive_checks
  # * enable_event_handler
  # * enable_flap_detection
  # * enable_perfdata
  # * event_command
  # * flapping_threshold
  # * volatile
  # * notes
  # * notes_url
  # * action_url
  # * icon_image
  # * icon_image_alt  
  $target_dir        = '/etc/icinga2/conf.d',
  $target_file_name  = "${name}.conf",
  $target_file_owner = 'root',
  $target_file_group = 'root',
  $target_file_mode  = '644'
) {

  file {"${target_dir}/${target_file_name}":
    ensure => file,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_service.conf.erb'),
    notify => Service['icinga2'],
  }

}