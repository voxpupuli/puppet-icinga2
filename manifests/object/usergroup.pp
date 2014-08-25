# == Defined type: icinga2::object::usergroup
#
# This is a defined type for Icinga 2 usergroup objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-usergroup
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::usergroup (
  $object_usergroup_name = $name,
  $display_name = $name,
  $template_to_import = undef,
  $groups = [],
  $target_dir = '/etc/icinga2/conf.d',
  $target_file_name = "${name}.conf",
  $target_file_owner = 'root',
  $target_file_group = 'root',
  $target_file_mode = '644',
  $assign_where = undef,
  $ignore_where = undef
) {

  file {"${target_dir}/${target_file_name}":
    ensure => file,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_usergroup.conf.erb'),
    notify => Service['icinga2'],
  }

}