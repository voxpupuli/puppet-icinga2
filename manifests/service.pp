# @summary
#   This class handles the Icinga 2 service. By default the service will
#   start on boot and will be restarted if stopped.
#
# @api private
#
class icinga2::service {
  assert_private()

  $ensure         = $icinga2::ensure
  $enable         = $icinga2::enable
  $manage_service = $icinga2::manage_service
  $service_name   = $icinga2::globals::service_name
  $reload         = $icinga2::globals::service_reload
  $logon_account  = $icinga2::globals::logon_account

  $hasrestart     = $reload ? {
    undef   => false,
    default => true,
  }

  if $manage_service {
    if $facts['os']['kernel'] == 'windows' and versioncmp($::facts['puppetversion'], '6.18.0') >= 0 {
      service { $service_name:
        ensure       => $ensure,
        enable       => $enable,
        hasrestart   => $hasrestart,
        restart      => $reload,
        logonaccount => $logon_account,
      }
    } else {
      service { $service_name:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => $hasrestart,
        restart    => $reload,
      }
    }
  }
}
