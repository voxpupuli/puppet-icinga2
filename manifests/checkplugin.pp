# == Defined Type: icinga2::checkplugin
#
# === Parameters
#
#
define icinga2::checkplugin (
  $checkplugin_name               = $name,
  $checkplugin_libdir             = $icinga2::params::checkplugin_libdir,
  $checkplugin_target_file_owner  = 'root',
  $checkplugin_target_file_group  = 'root',
  $checkplugin_target_file_mode   = '0755',
  $checkplugin_source_file        = undef,
) {

  #Do some validation of the class' parameters:
  validate_string($name)
  validate_string($checkplugin_libdir)
  validate_string($checkplugin_name)
  validate_string($checkplugin_target_file_owner)
  validate_string($checkplugin_target_file_group)
  validate_string($checkplugin_target_file_mode)

  file { "${checkplugin_libdir}/${checkplugin_name}":
    owner   => $checkplugin_target_file_owner,
    group   => $checkplugin_target_file_group,
    mode    => $checkplugin_target_file_mode,
    source  => $checkplugin_source_file,
    require => Package[$icinga2::params::icinga2_client_packages],
  }

}
