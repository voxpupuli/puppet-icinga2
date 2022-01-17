# @summary
#   Configures the Icinga 2 feature graphite.
#
# @example
#   class { '::icinga2::feature::graphite':
#     host                   => '10.10.0.15',
#     port                   => 2003,
#     enable_send_thresholds => true,
#     enable_send_metadata   => true,
#   }
#
# @param ensure
#   Set to present enables the feature graphite, absent disabled it.
#
# @param host
#   Graphite Carbon host address.
#
# @param port
#   Graphite Carbon port.
#
# @param host_name_template
#   Template for metric path of hosts.
#
# @param service_name_template
#   Template for metric path of services.
#
# @param enable_send_thresholds
#
# @param enable_send_metadata
#
# @param [Optional[Boolean]] enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
class icinga2::feature::graphite(
  Enum['absent', 'present']                $ensure                 = present,
  Optional[Stdlib::Host]                   $host                   = undef,
  Optional[Stdlib::Port::Unprivileged]     $port                   = undef,
  Optional[String]                         $host_name_template     = undef,
  Optional[String]                         $service_name_template  = undef,
  Optional[Boolean]                        $enable_send_thresholds = undef,
  Optional[Boolean]                        $enable_send_metadata   = undef,
  Optional[Boolean]                        $enable_ha              = undef,
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
    host                   => $host,
    port                   => $port,
    host_name_template     => $host_name_template,
    service_name_template  => $service_name_template,
    enable_send_thresholds => $enable_send_thresholds,
    enable_send_metadata   => $enable_send_metadata,
    enable_ha              => $enable_ha,
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
