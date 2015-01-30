# == Defined type: icinga2::object::checkercomponent
#
# This is a defined type for Icinga 2 apply objects that create Checker Component
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-checkercomponent
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::checkercomponent (
  $ensure                    = 'file',
  $object_name               = $name,
  $target_dir                = '/etc/icinga2/features-available',
  $target_file_name          = "${name}.conf",
  $target_file_owner         = 'root',
  $target_file_group         = 'root',
  $target_file_mode          = '0644'
) {

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
    content => template('icinga2/object_checkercomponent.conf.erb'),
#    notify  => Service['icinga2'], # Dont need to reload/restart the service only enable/disable the feature. Should we force enable/disable the feature (icinga2 feature enable checker) or should the user define it?
  }
}
