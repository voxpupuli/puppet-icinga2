# == Defined type: icinga2::object::apilistener
#
# This is a defined type for Icinga 2 apply objects that create apilistener objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-apilistener
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::apilistener (
  $ensure                  = 'file',
  $object_name             = $name,
  $cert_path               = 'SysconfDir + "/icinga2/pki/" + NodeName + ".crt"',
  $key_path                = 'SysconfDir + "/icinga2/pki/" + NodeName + ".key"',
  $ca_path                 = 'SysconfDir + "/icinga2/pki/ca.crt"',
  $crl_path                = undef,
  $bind_host               = '0.0.0.0',
  $bind_port               = 5665,
  $accept_config           = false,
  $accept_commands         = false,
  $target_dir              = '/etc/icinga2/objects/apilisteners',
  $target_file_name        = "${name}.conf",
  $target_file_ensure      = file,
  $target_file_owner       = 'root',
  $target_file_group       = 'root',
  $target_file_mode        = '0644',
  $refresh_icinga2_service = true,
) {

  validate_string($cert_path)
  validate_string($key_path)
  validate_string($ca_path)
  if $crl_path { validate_string($crl_path) }
  if $bind_host { validate_string($bind_host) }
  if $bind_port { validate_re($bind_port, '^\d{1,5}$') }
  if $accept_config { validate_bool($accept_config) }
  if $accept_commands { validate_bool($accept_commands) }
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
      content => template('icinga2/object_apilistener.conf.erb'),
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
      content => template('icinga2/object_apilistener.conf.erb'),
    }
  
  }

}
