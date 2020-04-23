# @summary
#   Configures the Icinga 2 feature gelf.
#
# @param [Enum['absent', 'present']] ensure
#   Set to present enables the feature gelf, absent disables it.
#
# @param [Optional[Stdlib::Host]] host
#   GELF receiver host address.
#
# @param [Optional[Stdlib::Port::Unprivileged]] port
#   GELF receiver port.
#
# @param [Optional[String]] source
#   Source name for this instance.
#
# @param [Optional[Boolean]] enable_send_perfdata
#   Enable performance data for 'CHECK RESULT' events.
#
# @param [Optional[Boolean]] enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
class icinga2::feature::gelf(
  Enum['absent', 'present']                $ensure               = present,
  Optional[Stdlib::Host]                   $host                 = undef,
  Optional[Stdlib::Port::Unprivileged]     $port                 = undef,
  Optional[String]                         $source               = undef,
  Optional[Boolean]                        $enable_send_perfdata = undef,
  Optional[Boolean]                        $enable_ha            = undef,
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
    host                 => $host,
    port                 => $port,
    source               => $source,
    enable_send_perfdata => $enable_send_perfdata,
    enable_ha            => $enable_ha,
  }

  # create object
  icinga2::object { 'icinga2::object::GelfWriter::gelf':
    object_name => 'gelf',
    object_type => 'GelfWriter',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/gelf.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'perfdata'
  concat::fragment { 'icinga2::feature::gelf':
    target  => "${conf_dir}/features-available/gelf.conf",
    content => "library \"perfdata\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'gelf':
    ensure => $ensure,
  }
}
