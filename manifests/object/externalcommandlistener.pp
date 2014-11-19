# == Defined type: icinga2::object::externalcommandlistener
#
# This is a defined type for Icinga 2 apply objects that create ExternalCommand Listener
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-externalcommandlistener
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::externalcommandlistener (
  $ensure                             = 'file',
  $object_externalcommandlistenername = $name,
  $command_path                       = undef,
  $target_dir                         = '/etc/icinga2/objects/externalcommandlisteners',
  $target_file_name                   = "${name}.conf",
  $target_file_ensure                 = file,
  $target_file_owner                  = 'root',
  $target_file_group                  = 'root',
  $target_file_mode                   = '0644'
) {

  #Do some validation of the class' parameters:
  if $object_externalcommandlistenername {
    validate_string($object_externalcommandlistenername)
  }
  if $command_path {
    validate_string($command_path)
  }
  validate_string($target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_re($target_file_mode, '^\d{4}$')


  file {"${target_dir}/${target_file_name}":
    ensure  => $target_file_ensure,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_externalcommandlistener.conf.erb'),
    notify  => Service['icinga2'],
  }

}
