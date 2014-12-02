# == Defined type: icinga2::object::icingastatuswriter
#
# This is a defined type for Icinga 2 apply objects that create IcingaStatusWriter
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-checkercomponent
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::icingastatuswriter (
  $ensure                    = 'file',
  $object_name               = $name,
  $status_path               = undef,
  $update_interval           = undef,
  $target_dir                = '/etc/icinga2/objects/icingastatuswriters',
  $target_file_name          = "${name}.conf",
  $target_file_owner         = 'root',
  $target_file_group         = 'root',
  $target_file_mode          = '0644'
) {

  if $status_path {
    validate_string($status_path)
  }
  if $update_interval {
    validate_string($update_interval)
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
    content => template('icinga2/object_icingastatuswriter.conf.erb'),
    notify  => Service['icinga2'],
  }
}
