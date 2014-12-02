# == Defined type: icinga2::object::idopgsqlconnection
#
# This is a defined type for Icinga 2 IDO Postgres connection objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-idopgsqlconnection
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::idopgsqlconnection (
  $object_name          = $name,
  $host                 = '127.0.0.1',
  $port                 = 5432,
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
  $target_file_ensure   = file,
  $target_file_owner    = 'root',
  $target_file_group    = 'root',
  $target_file_mode     = '0644',
  $refresh_icinga2_service = true
) {

  #Do some validation of the class' parameters:
  validate_string($object_name)
  validate_string($template_to_import)
  validate_string($host)
  validate_string($user)
  validate_string($password)
  validate_string($database)
  validate_string($table_prefix)
  validate_string($instance_name)
  validate_hash($cleanup)
  validate_array($categories)
  validate_string($target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_string($target_file_mode)
  validate_bool($refresh_icinga2_service)

  #If the refresh_icinga2_service parameter is set to true...
  if $refresh_icinga2_service == true {

    file { "${target_dir}/${target_file_name}":
      ensure  => $target_file_ensure,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template('icinga2/object_idopgsqlconnection.conf.erb'),
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
      content => template('icinga2/object_idopgsqlconnection.conf.erb'),
    }
  
  }

}
