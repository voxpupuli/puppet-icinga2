# Enable Features for Icinga 2
class icinga2::server::features (
  $enabled_features = $icinga2::server::server_enabled_features,
  $disabled_features = $icinga2::server::server_disabled_features,
) {

  include stdlib

  # Do some checking
  validate_array($enabled_features)
  validate_array($disabled_features)

  #Compare the enabled and disabled feature arrays
  #Remove enabled features that are also listed to be disabled
  $updated_enabled_features = difference($enabled_features,$disabled_features)

  #Pass the disabled features array to the define for looping
  icinga2::server::features::disable { $disabled_features: }

  #Pass the features array to the define for looping
  icinga2::server::features::enable { $updated_enabled_features: }

}
