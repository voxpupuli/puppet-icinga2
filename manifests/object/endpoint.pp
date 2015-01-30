# == Defined type: icinga2::object::endpoint
#
# This is a defined type for Icinga 2 apply objects that create EndPoint
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-endpoint
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::endpoint (
  $ensure                    = 'file',
  $object_name               = $name,
  $host                      = undef,
  $port                      = undef,
  $log_duration              = undef,
  $target_dir                = '/etc/icinga2/objects/endpoints',
  $target_file_name          = "${name}.conf",
  $target_file_owner         = 'root',
  $target_file_group         = 'root',
  $target_file_mode          = '0644'
) {

  validate_string($host)
  if $port {
    validate_re($port, '^\d{1,5}$')
  }
  if $log_duration {
    validate_string($log_duration)
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
    content => template('icinga2/object_endpoint.conf.erb'),
    notify  => Service['icinga2'],
  }
}
