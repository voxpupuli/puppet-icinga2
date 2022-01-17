# @summary
#   Configures the Icinga 2 feature livestatus.
#
# @param ensure
#   Set to present enables the feature livestatus, absent disables it.
#
# @param socket_type
#   Specifies the socket type. Can be either 'tcp' or 'unix'.
#
# @param bind_host
#   IP address to listen for connections. Only valid when socket_type is 'tcp'.
#
# @param bind_port
#   Port to listen for connections. Only valid when socket_type is 'tcp'.
#
# @param socket_path
#   Specifies the path to the UNIX socket file. Only valid when socket_type is 'unix'.
#
# @param compat_log_path
#   Required for historical table queries. Requires CompatLogger feature to be enabled.
#
class icinga2::feature::livestatus(
  Enum['absent', 'present']                $ensure          = present,
  Optional[Enum['tcp', 'unix']]            $socket_type     = undef,
  Optional[Stdlib::Host]                   $bind_host       = undef,
  Optional[Stdlib::Port::Unprivileged]     $bind_port       = undef,
  Optional[Stdlib::Absolutepath]           $socket_path     = undef,
  Optional[Stdlib::Absolutepath]           $compat_log_path = undef,
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
    socket_type     => $socket_type,
    bind_host       => $bind_host,
    bind_port       => $bind_port,
    socket_path     => $socket_path,
    compat_log_path => $compat_log_path,
  }

  # create object
  icinga2::object { 'icinga2::object::LivestatusListener::livestatus':
    object_name => 'livestatus',
    object_type => 'LivestatusListener',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/livestatus.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'livestatus'
  concat::fragment { 'icinga2::feature::livestatus':
    target  => "${conf_dir}/features-available/livestatus.conf",
    content => "library \"livestatus\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'livestatus':
    ensure => $ensure,
  }
}
