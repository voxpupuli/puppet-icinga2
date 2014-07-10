# == Defined type: icinga2::object::host
#  
#  This defined type
#
# === Parameters
#
# See the inline comments.
#

define icinga2::objects::host (
  $ipv4_address = $ipaddress_eth0,
  $ipv6_address = $ipaddress_eth0,
  $object_hostname = $name,
  $display_name = $fqdn,
  $template_to_import = 'generic-host',
  $target_dir = '/etc/icinga2/conf.d',
  $target_file_name = "${fqdn}.conf",
) {

  file {"${target_dir}/${target_file_name}":
    ensure => file,
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    content => template('icinga2/object_host.conf.erb'),
    notify => Service['icinga2'],
  }

}