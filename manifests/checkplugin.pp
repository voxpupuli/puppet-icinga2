# == Defined Type: icinga2::checkplugin
#
# === Parameters
#
#
define icinga2::checkplugin (
  $checkplugin_name                     = $name,
  $checkplugin_libdir                   = $icinga2::params::checkplugin_libdir,
  $checkplugin_target_file_owner        = 'root',
  $checkplugin_target_file_group        = 'root',
  $checkplugin_target_file_mode         = '0755',
  $checkplugin_file_distribution_method = 'content',
  $checkplugin_template_module          = 'icinga2',
  $checkplugin_template                 = undef,
  $checkplugin_source_file              = undef,
) {

  #Do some validation of the class' parameters:
  validate_string($name)
  validate_string($checkplugin_libdir)
  validate_string($checkplugin_name)
  validate_string($checkplugin_target_file_owner)
  validate_string($checkplugin_target_file_group)
  validate_string($checkplugin_target_file_mode)

  if $checkplugin_file_distribution_method == 'content' {
    file { "${checkplugin_libdir}/${checkplugin_name}":
      owner   => $checkplugin_target_file_owner,
      group   => $checkplugin_target_file_group,
      mode    => $checkplugin_target_file_mode,
      content => template("${checkplugin_template_module}/${checkplugin_template}"),
      require => Package[$icinga2::params::icinga2_client_packages],
    }
  }
  elsif $checkplugin_file_distribution_method == 'source' {
    file { "${checkplugin_libdir}/${checkplugin_name}":
      owner   => $checkplugin_target_file_owner,
      group   => $checkplugin_target_file_group,
      mode    => $checkplugin_target_file_mode,
      source  => $checkplugin_source_file,
      require => Package[$icinga2::params::icinga2_client_packages],
    }
  }
  else {
    notify {'Missing/Incorrect File Distribution Method':
      message => 'The parameter checkplugin_file_distribution_method is missing or incorrect. Please set content or source',
    }
  }

}
