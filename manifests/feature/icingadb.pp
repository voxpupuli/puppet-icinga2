# @summary
#   Configures the Icinga 2 feature icingadb.
#
# @param ensure
#   Set to present, enables the feature icingadb, absent disabled it.
#
# @param host
#   IcingaDB Redis host address.
#
# @param port
#   IcingaDB Redis port.
#
# @param socket_path
#   IcingaDB Redis unix sockt. Can be used instead of host and port attributes.
#
# @param connect_timeout
#   Timeout for establishing new connections.
#
# @param password
#   IcingaDB Redis password. The password parameter isn't parsed anymore.
#
class icinga2::feature::icingadb(
  Enum['absent', 'present']                     $ensure          = present,
  Optional[Stdlib::Host]                        $host            = undef,
  Optional[Stdlib::Port::Unprivileged]          $port            = undef,
  Optional[Stdlib::Absolutepath]                $socket_path     = undef,
  Optional[Icinga2::Interval]                   $connect_timeout = undef,
  Optional[Variant[String, Sensitive[String]]]  $password        = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir = $::icinga2::globals::conf_dir

  $_notify  = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  $_password = if $password =~ String {
    Sensitive($password)
  } elsif $password =~ Sensitive {
    $password
  } else {
    undef
  }

  # compose attributes
  $attrs = {
    host     => $host,
    port     => $port,
    path     => $socket_path,
    password => $_password,
  }

  # create object
  icinga2::object { 'icinga2::object::IcingaDB::icingadb':
    object_name => 'icingadb',
    object_type => 'IcingaDB',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/icingadb.conf",
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'icingadb':
    ensure => $ensure,
  }
}
