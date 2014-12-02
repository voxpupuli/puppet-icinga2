# == Defined type: icinga2::object::filelogger
#
# This is a defined type for Icinga 2 apply objects that create File Logger
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-filelogger
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::filelogger (
  $ensure                    = 'file',
  $object_name               = $name,
  $path                      = undef,
  $severity                  = undef,
  $target_dir                = '/etc/icinga2/conf.d',
  $target_file_name          = "${name}.conf",
  $target_file_owner         = 'root',
  $target_file_group         = 'root',
  $target_file_mode          = '0644'
) {

  if $object_name {
    validate_string($object_name)
  }
  validate_string($path)
  if $severity {
    validate_string($severity)
  }
  validate_string($target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_re($target_file_mode, '^\d{4}$')

  file {"${target_dir}/${target_file_name}":
    ensure  => $ensure,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_filelogger.conf.erb'),
    notify  => Service['icinga2']
  }
}
