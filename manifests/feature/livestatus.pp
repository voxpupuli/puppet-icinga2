# == Class: icinga2::feature::livestatus
#
# This module configures the Icinga2 feature livestatus.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   Set to present enables the feature livestatus, absent disabled it. Default to present.
#
# [*socket_type*]
#   Specifies the socket type. Can be either 'tcp' or 'unix' Default to 'unix'
#
# [*bind_host*]
#   Only valid when socket_type is 'tcp'. Host address to listen on for connections.
#   Default to "127.0.0.1".
#
# [*bind_port*]
#   Only valid when socket_type is 'tcp'. Port to listen on for connections. Default to 6558.
#
# [*socket_path*]
#   Only valid when socket_type is 'unix'. Specifies the path to the UNIX socket file.
#   Default depends on plattforms to '/var/run/icinga2/cmd/livestatus' on Linux
#   and 'C:/ProgramData/icinga2/var/run/icinga2/cmd/livestatus' on Windows.
#
# [*compat_log_path*]
#   Required for historical table queries. Requires CompatLogger feature enabled.
#   Default depends plattforms to 'var/icinga2/log/icinga2/compat' on Linux
#   and 'C:/ProgramData/icinga2/var/log/icinga2/compat' on Windows.
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
  $socket_path     = "${run_dir}/icinga2/cmd/livestatus",
  $compat_log_path = "${log_dir}/log/icinga2/compat",
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
