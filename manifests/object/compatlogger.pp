# == Defined type: icinga2::object::compatlogger
#
# This is a defined type for Icinga 2 apply objects that create Compat Logger
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-compatlogger
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::compatlogger (
  $ensure                  = 'file',
  $object_compatloggername = $name,
  $log_dir                 = undef,
  $rotation_method         = undef,
  $target_dir              = '/etc/icinga2/objects/compatloggers',
  $target_file_name        = "${name}.conf",
  $target_file_ensure      = file,
  $target_file_owner       = 'root',
  $target_file_group       = 'root',
  $target_file_mode        = '0644'
) {

  #Do some validation of the class' parameters:
  if $object_compatloggername {
    validate_string($object_compatloggername)
  }
  if $log_dir {
    validate_string($log_dir)
  }
  if $rotation_method {
    validate_string($rotation_method)
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
    content => template('icinga2/object_compatlogger.conf.erb'),
    notify  => Service['icinga2'],
  }

}
