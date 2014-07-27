# == Defined type: icinga2::object::host
#  
#  This defined type
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::host (
  $object_hostname = $name,
  $display_name = $fqdn,
  $ipv4_address = $ipaddress_eth0,
  $ipv6_address = $ipaddress_eth0,
  $template_to_import = 'generic-host',
  $groups = [],
  $vars = {},
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
    content => template('icinga2/object_host.conf.erb'),
    notify => Service['icinga2'],
  }

}