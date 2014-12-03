# == Defined type: icinga2::object::perfdatawriter
#
# This is a defined type for Icinga 2 apply objects that create Perfdata Writer
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-perfdatawriter
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::perfdatawriter (
  $ensure                    = 'file',
  $object_perfdatawritername = $name,
  $host_perfdata_path        = undef,
  $service_perfdata_path     = undef,
  $host_temp_path            = undef,
  $service_temp_path         = undef,
  $host_format_template      = undef,
  $service_format_template   = undef,
  $rotation_interval         = undef,
  $target_dir                = '/etc/icinga2/objects/perfdatawriters',
  $target_file_name          = "${name}.conf",
  $target_file_ensure        = file,
  $target_file_owner         = 'root',
  $target_file_group         = 'root',
  $target_file_mode          = '0644',
  $refresh_icinga2_service = true
) {

  #Do some validation of the class' parameters:
  if $object_perfdatawritername {
    validate_string($object_perfdatawritername)
  }
  if $host_perfdata_path {
    validate_string($host_perfdata_path)
  }
  if $service_perfdata_path {
    validate_string($service_perfdata_path)
  }
  if $host_temp_path {
    validate_string($host_temp_path)
  }
  if $service_temp_path {
    validate_string($service_temp_path)
  }
  if $host_format_template {
    validate_string($host_format_template)
  }
  if $service_format_template {
    validate_string($service_format_template)
  }
  if $rotation_interval {
    validate_string($rotation_interval)
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
      content => template('icinga2/object_perfdatawriter.conf.erb'),
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
      content => template('icinga2/object_perfdatawriter.conf.erb'),
    }
  
  }

}
