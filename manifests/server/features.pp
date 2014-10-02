# Enable Features for Icinga 2
class icinga2::server::features (
  $enabled_features = $icinga2::server::server_enabled_features,
  $disabled_features = $icinga2::server::server_disabled_features,
) {

  # Do some checking
  validate_array($enabled_features)
  validate_array($disabled_features)

  #Pass the disabled features array to the define for looping
  icinga2::server::features::disable { $disabled_features: }

  #Pass the features array to the define for looping
  icinga2::server::features::enable { $enabled_features: }

}
