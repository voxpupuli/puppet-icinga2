# == Class: icinga2::feature::graphite
#
# This module configures the Icinga 2 feature graphite.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature graphite, absent disabled it. Defaults to present.
#
# [*host*]
#   Graphite Carbon host address. Icinga defaults to '127.0.0.1'.
#
# [*port*]
#   Graphite Carbon port. Icinga defaults to 2003.
#
# [*host_name_template*]
#   Template for metric path of hosts.
#   Icinga defaults to 'icinga2.$host.name$.host.$host.check_command$'.
#
# [*service_name_template*]
#   Template for metric path of services.
#   Icinga defaults to 'icinga2.$host.name$.services.$service.name$.$service.check_command$'.
#
# [*enable_send_thresholds*]
#   Send threholds as metrics. Icinga defaults to false.
#
# [*enable_send_metadata*]
#   Send metadata as metrics. Icinga defaults to false.
#
#
class icinga2::feature::graphite(
  Enum['absent', 'present']      $ensure                 = present,
  Optional[String]               $host                   = undef,
  Optional[Integer[1,65535]]     $port                   = undef,
  Optional[String]               $host_name_template     = undef,
  Optional[String]               $service_name_template  = undef,
  Optional[Boolean]              $enable_send_thresholds = undef,
  Optional[Boolean]              $enable_send_metadata   = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir = $::icinga2::params::conf_dir
  $_notify  = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  # compose attributes
  $attrs = {
    host                   => $host,
    port                   => $port,
    host_name_template     => $host_name_template,
    service_name_template  => $service_name_template,
    enable_send_thresholds => $enable_send_thresholds,
    enable_send_metadata   => $enable_send_metadata,
  }

  # create object
  icinga2::object { 'icinga2::object::GraphiteWriter::graphite':
    object_name => 'graphite',
    object_type => 'GraphiteWriter',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/graphite.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'perfdata'
  concat::fragment { 'icinga2::feature::graphite':
    target  => "${conf_dir}/features-available/graphite.conf",
    content => "library \"perfdata\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'graphite':
    ensure => $ensure,
  }
}
