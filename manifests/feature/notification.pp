class icinga2::feature::notification(
  $ensure = present,
) {

  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  icinga2::object::notificationcomponent { 'notification':
    target => "${conf_dir}/features-available/notification.conf",
    notify => $ensure ? {
      'present'   => Class['::icinga2::service'],
      default => undef,
    },
  }

  concat::fragment { 'icinga2::feature::notification':
    target  => "${conf_dir}/features-available/notification.conf",
    content => "library \"notification\"\n\n",
    order   => '05',
  }

  icinga2::feature { 'notification':
    ensure      => $ensure,
  }

}
