# == Defined type: icinga2::object::dependency
#
#  This is a defined type for Icinga 2 dependency objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-dependency
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::dependency (
  $object_name           = $name,
  $display_name          = $name,
  $parent_host_name      = $host_name,
  $parent_service_name   = undef,
  $child_host_name       = undef,
  $child_service_name    = undef,
  $disable_checks        = undef,
  $disable_notifications = undef,
  $period                = undef,
  $states                = [],
  $target_dir            = '/etc/icinga2/conf.d',
  $target_file_name      = "${name}.conf",
  $target_file_ensure    = file,
  $target_file_owner     = 'root',
  $target_file_group     = 'root',
  $target_file_mode      = '0644',
  $refresh_icinga2_service = true
  ) {
  # Do some validation of the class' parameters:
  validate_string($object_name)
  validate_string($display_name)
  validate_string($host_name)
  validate_string($parent_host_name)
  validate_string($child_host_name)
  validate_string($child_service_name)
  validate_string($parent_service_name)
  #  validate_bool($disable_checks)
  #  validate_bool($disable_notifications)
  validate_string($period)
  validate_array($states)
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
      content => template('icinga2/object_dependency.conf.erb'),
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
      content => template('icinga2/object_dependency.conf.erb'),
    }
  
  }

}
