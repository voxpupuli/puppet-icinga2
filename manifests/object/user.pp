# == Defined type: icinga2::object::user
#  
#  This is a defined type for Icinga 2 user objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-user
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::user (
  $object_username = $name,
  $display_name = $name,
  $email = undef,
  $pager = undef,
  $vars = {},
  $groups = [],
  #Parameters to add:
  # enable_notifications
  # period
  # types
  # states
  $target_dir = '/etc/icinga2/conf.d',
  $target_file_name = "${fqdn}.conf",
  $target_file_owner = 'root',
  $target_file_group = 'root',
  $target_file_mode = '644'
) {

  file {"${target_dir}/${target_file_name}":
    ensure => file,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_user.conf.erb'),
    notify => Service['icinga2'],
  }

}