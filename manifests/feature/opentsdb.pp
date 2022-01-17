# @summary
#   Configures the Icinga 2 feature opentsdb.
#
# @param ensure
#   Set to present enables the feature opentsdb, absent disables it.
#
# @param host
#   OpenTSDB host address.
#
# @param port
#   OpenTSDB port.
#
# @param enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
class icinga2::feature::opentsdb(
  Enum['absent', 'present']               $ensure    = present,
  Optional[Stdlib::Host]                  $host      = undef,
  Optional[Stdlib::Port::Unprivileged]    $port      = undef,
  Optional[Boolean]                       $enable_ha = undef,
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
    host      => $host,
    port      => $port,
    enable_ha => $enable_ha,
  }

  # create object
  icinga2::object { 'icinga2::object::OpenTsdbWriter::opentsdb':
    object_name => 'opentsdb',
    object_type => 'OpenTsdbWriter',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/opentsdb.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'perfdata'
  concat::fragment { 'icinga2::feature::opentsdb':
    target  => "${conf_dir}/features-available/opentsdb.conf",
    content => "library \"perfdata\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'opentsdb':
    ensure => $ensure,
  }
}
