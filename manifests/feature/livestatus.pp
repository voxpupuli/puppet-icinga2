# == Class: icinga2::feature::livestatus
#
# This module configures the Icinga2 feature livestatus.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature livestatus, absent disables it. Default is present.
#
# [*socket_type*]
#   Specifies the socket type. Can be either 'tcp' or 'unix'. Default is 'unix'
#
# [*bind_host*]
#   IP address to listen for connections. Only valid when socket_type is 'tcp'.
#   Default is "127.0.0.1".
#
# [*bind_port*]
#   Port to listen for connections. Only valid when socket_type is 'tcp'. Default is 6558.
#
# [*socket_path*]
#   Specifies the path to the UNIX socket file. Only valid when socket_type is 'unix'.
#   Default depends on platform:
#   '/var/run/icinga2/cmd/livestatus' on Linux
#   'C:/ProgramData/icinga2/var/run/icinga2/cmd/livestatus' on Windows.
#
# [*compat_log_path*]
#   Required for historical table queries. Requires CompatLogger feature to be enabled.
#   Default depends platform:
#   'var/icinga2/log/icinga2/compat' on Linux
#   'C:/ProgramData/icinga2/var/log/icinga2/compat' on Windows.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::livestatus(
  $ensure          = present,
  $socket_type     = 'unix',
  $bind_host       = '127.0.0.1',
  $bind_port       = '6558',
  $socket_path     = "${::icinga2::params::run_dir}/cmd/livestatus",
  $compat_log_path = "${::icinga2::params::log_dir}/compat",
) inherits icinga2::params {

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_re($socket_type, [ '^unix$', '^tcp$' ],
    "${socket_type} isn't supported. Valid values are 'unix' and 'tcp'.")
  validate_ip_address($bind_host)
  validate_integer($bind_port)
  validate_absolute_path($socket_path)
  validate_absolute_path($compat_log_path)

  icinga2::feature { 'livestatus':
    ensure => $ensure,
  }
}
