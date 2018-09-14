# == Class: icinga2::feature::opentsdb
#
# This module configures the Icinga 2 feature opentsdb.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature opentsdb, absent disables it. Defaults to present.
#
# [*host*]
#   OpenTSDB host address. Icinga defaults to '127.0.0.1'.
#
# [*port*]
#   OpenTSDB port. Icinga defaults to 4242.
#
#
class icinga2::feature::opentsdb(
  Enum['absent', 'present']     $ensure = present,
  Optional[String]              $host   = undef,
  Optional[Integer[1,65535]]    $port   = undef,
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
    host => $host,
    port => $port,
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
