# Enable Features for Icinga 2
class icinga2::server::features (
  $enabled_features = $icinga2::server::server_enabled_features,
) {

  # Do some checking
  validate_array($enabled_features)

  # Pass the features arry to the define to loop though
  icinga2::server::features::enable { $enabled_features: }

}
