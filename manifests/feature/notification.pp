class icinga2::feature::notification(
  $ensure = present,
) inherits icinga2::params {

  icinga2::feature { 'notification':
    ensure => $ensure,
  }
}
