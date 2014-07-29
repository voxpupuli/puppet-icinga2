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

define icinga2::object::service () {

  file {"${target_dir}/${target_file_name}":
    ensure => file,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_service.conf.erb'),
    notify => Service['icinga2'],
  }

}