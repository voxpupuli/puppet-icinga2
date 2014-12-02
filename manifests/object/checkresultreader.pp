# == Defined type: icinga2::object::checkresultreader
#
# This is a defined type for Icinga 2 apply objects that create Check Result Reader
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-checkresultreader
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::checkresultreader (
  $ensure                       = 'file',
  $object_checkresultreadername = $name,
  $spool_dir                    = undef,
  $target_dir                   = '/etc/icinga2/objects/checkresultreaders',
  $target_file_name             = "${name}.conf",
  $target_file_ensure           = file,
  $target_file_owner            = 'root',
  $target_file_group            = 'root',
  $target_file_mode             = '0644',
  $refresh_icinga2_service = true
) {

  #Do some validation of the class' parameters:
  if $object_checkresultreadername {
    validate_string($object_checkresultreadername)
  }
  if $spool_dir {
    validate_string($spool_dir)
  }
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
      content => template('icinga2/object_checkresultreader.conf.erb'),
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
      content => template('icinga2/object_checkresultreader.conf.erb'),
    }
  
  }

}
