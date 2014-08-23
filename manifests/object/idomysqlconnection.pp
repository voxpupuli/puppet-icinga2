# == Defined type: icinga2::object::idomysqlconnection
#  
#  This is a defined type for Icinga 2 IDO MySQL connection objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-idomysqlconnection
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::idomysqlconnection (
  $object_name          = $name,
  $host                 = 'localhost',
  $port                 = 3306,
  $user                 = 'icinga',
  $password             = 'icinga',
  $database             = 'icinga',
  $table_prefix         = 'icinga_',
  $instance_name        = 'default',
  $instance_description = undef,
  $cleanup              = {
    acknowledgements_age           => 0,
    commenthistory_age             => 0,
    contactnotifications_age       => 0,
    contactnotificationmethods_age => 0,
    downtimehistory_age            => 0,
    eventhandlers_age              => 0,
    externalcommands_age           => 0,
    flappinghistory_age            => 0,
    hostchecks_age                 => 0,
    logentries_age                 => 0,
    notifications_age              => 0,
    processevents_age              => 0,
    statehistory_age               => 0,
    servicechecks_age              => 0,
    systemcommands_age             => 0
    
  },
  $categories           = [],
  $target_dir           = '/etc/icinga2/conf.d',
  $target_file_name     = "${name}.conf",
  $target_file_owner    = 'root',
  $target_file_group    = 'root',
  $target_file_mode     = '644'
) {

  file {"${target_dir}/${target_file_name}":
    ensure  => file,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_idomysqlconnection.conf.erb'),
    notify  => Service['icinga2'],
  }

}