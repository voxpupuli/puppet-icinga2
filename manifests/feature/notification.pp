# @summary
#   Configures the Icinga 2 feature notification.
#
# @param ensure
#   Set to present enables the feature notification, absent disabled it.
#
# @param enable_ha
#   Notifications are load-balanced amongst all nodes in a zone.
#
class icinga2::feature::notification(
  Enum['absent', 'present'] $ensure    = present,
  Optional[Boolean]         $enable_ha = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir = $::icinga2::globals::conf_dir
  $_notify  = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  # compose attributes
  $attrs = {
    enable_ha => $enable_ha,
  }

  # create object
  icinga2::object { 'icinga2::object::NotificationComponent::notification':
    object_name => 'notification',
    object_type => 'NotificationComponent',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/notification.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'notification'
  concat::fragment { 'icinga2::feature::notification':
    target  => "${conf_dir}/features-available/notification.conf",
    content => "library \"notification\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'notification':
    ensure      => $ensure,
  }

}
