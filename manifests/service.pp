# @summary
#   This class handles the Icinga 2 service. By default the service will
#   start on boot and will be restarted if stopped.
#
# @api private
#
class icinga2::service {

  assert_private()

  $ensure         = $::icinga2::ensure
  $enable         = $::icinga2::enable
  $manage_service = $::icinga2::manage_service
  $service_name   = $::icinga2::globals::service_name
  $reload         = $::icinga2::globals::service_reload
  $hasrestart     = $reload ? {
    undef   => false,
    default => true,
  }

  if $manage_service {
    service { $service_name:
      ensure     => $ensure,
      enable     => $enable,
      hasrestart => $hasrestart,
      restart    => $reload,
    }
  }

}
