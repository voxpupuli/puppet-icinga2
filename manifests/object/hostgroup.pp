# == Defined type: icinga2::object::hostgroup
#
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::hostgroup (
  $object_hostgroup_name = $name,
  $display_name = $name,
  $template_to_import = undef,
  $groups = [],
  $target_dir = '/etc/icinga2/conf.d',
  $target_file_name = "${name}.conf",
  $target_file_owner = 'root',
  $target_file_group = 'root',
  $target_file_mode = '644',
  $assign_where = undef
) {

  file {"${target_dir}/${target_file_name}":
    ensure => file,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_hostgroup.conf.erb'),
    notify => Service['icinga2'],
  }

}