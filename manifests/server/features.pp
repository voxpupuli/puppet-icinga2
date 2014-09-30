# Enable Features for Icinga 2
class icinga2::server::feature (
  $features = [],
) {

  # Do some checking
  validate_array($features)

  # Pass the features arry to the define to loop though
  icinga::server::feature::enable { $features: }

}
