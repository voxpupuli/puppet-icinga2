# == Class: icinga2::feature::influxdb
#
# This module configures the Icinga 2 feature influxdb.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature influxdb, absent disables it. Defaults to present.
#
# [*host*]
#    InfluxDB host address. Icinga defaults to 127.0.0.1.
#
# [*port*]
#    InfluxDB HTTP port. Icinga defaults to 8086.
#
# [*database*]
#    InfluxDB database name. Icinga defaults to icinga2.
#
# [*username*]
#    InfluxDB user name.
#
# [*password*]
#    InfluxDB user password.
#
# [*enable_ssl*]
#    Either enable or disable SSL. Other SSL parameters are only affected if this is set to 'true'.
#    Icinga defaults to 'false'.
#
# [*pki*]
#   Provides multiple sources for the certificate, key and ca. Valid parameters are 'puppet' or 'none'.
#   'puppet' copies the key, cert and CAcert from the Puppet ssl directory to the pki directory
#   /var/lib/icinga2/certs on Linux and C:/ProgramData/icinga2/var/lib/icinga2/certs on Windows.
#   'none' does nothing and you either have to manage the files yourself as file resources
#   or use the ssl_key, ssl_cert, ssl_cacert parameters. Defaults to puppet.
#
# [*ssl_key_path*]
#   Location of the private key. Default depends on platform:
#   /var/lib/icinga2/certs/InfluxdbWriter_influxdb.key on Linux
#   C:/ProgramData/icinga2/var/lib/icinga2/certs/InfluxdbWriter_influxdb.key on Windows
#
# [*ssl_cert_path*]
#   Location of the certificate. Default depends on platform:
#   /var/lib/icinga2/certs/InfluxdbWriter_influxdb.crt on Linux
#   C:/ProgramData/icinga2/var/lib/icinga2/certs/InfluxdbWriter_influxdb.crt on Windows
#
# [*ssl_cacert_path*]
#   Location of the CA certificate. Default is:
#   /var/lib/icinga2/certs/InfluxdbWriter_influxdb_ca.crt on Linux
#   C:/ProgramData/icinga2/var/lib/icinga2/certs/InfluxdbWriter_influxdb_ca.crt on Windows
#
# [*ssl_key*]
#   The private key in a base64 encoded string to store in pki directory, file is stored to
#   path spicified in ssl_key_path. This parameter requires pki to be set to 'none'.
#
# [*ssl_cert*]
#   The certificate in a base64 encoded string to store in pki directory, file is  stored to
#   path spicified in ssl_cert_path. This parameter requires pki to be set to 'none'.
#
# [*ssl_cacert*]
#   The CA root certificate in a base64 encoded string to store in pki directory, file is stored
#   to path spicified in ssl_cacert_path. This parameter requires pki to be set to 'none'.
#
# [*host_measurement*]
#    The value of this is used for the measurement setting in host_template. Icinga defaults to '$host.check_command$'.
#
# [*host_tags*]
#    Tags defined in this hash will be set in the host_template.
#
#  [*service_measurement*]
#    The value of this is used for the measurement setting in host_template. Icinga defaults to '$service.check_command$'.
#
# [*service_tags*]
#    Tags defined in this hash will be set in the service_template.
#
# [*enable_send_thresholds*]
#    Whether to send warn, crit, min & max tagged data. Icinga defaults to 'false'.
#
# [*enable_send_metadata*]
#    Whether to send check metadata e.g. states, execution time, latency etc. Icinga defaults to 'false'.
#
# [*flush_interval*]
#    How long to buffer data points before transfering to InfluxDB. Icinga defaults to '10s'.
#
# [*flush_threshold*]
#    How many data points to buffer before forcing a transfer to InfluxDB. Icinga defaults to '1024'.
#
# === Example
#
# class { 'icinga2::feature::influxdb':
#   host     => "10.10.0.15",
#   username => "icinga2",
#   password => "supersecret",
#   database => "icinga2"
# }
#
#
class icinga2::feature::influxdb(
  Enum['absent', 'present']          $ensure                 = present,
  Optional[String]                   $host                   = undef,
  Optional[Integer[1,65535]]         $port                   = undef,
  Optional[String]                   $database               = undef,
  Optional[String]                   $username               = undef,
  Optional[String]                   $password               = undef,
  Optional[Boolean]                  $enable_ssl             = undef,
  Enum['none', 'puppet']             $pki                    = 'puppet',
  Optional[Stdlib::Absolutepath]     $ssl_key_path           = undef,
  Optional[Stdlib::Absolutepath]     $ssl_cert_path          = undef,
  Optional[Stdlib::Absolutepath]     $ssl_cacert_path        = undef,
  Optional[String]                   $ssl_key                = undef,
  Optional[String]                   $ssl_cert               = undef,
  Optional[String]                   $ssl_cacert             = undef,
  Optional[String]                   $host_measurement       = undef,
  Optional[Hash]                     $host_tags              = undef,
  Optional[String]                   $service_measurement    = undef,
  Optional[Hash]                     $service_tags           = undef,
  Optional[Boolean]                  $enable_send_thresholds = undef,
  Optional[Boolean]                  $enable_send_metadata   = undef,
  Optional[Pattern[/^\d+[ms]*$/]]    $flush_interval         = undef,
  Optional[Integer[1]]               $flush_threshold        = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $user          = $::icinga2::params::user
  $group         = $::icinga2::params::group
  $conf_dir      = $::icinga2::params::conf_dir
  $ssl_dir       = $::icinga2::params::pki_dir
  $_ssl_key_mode = $::kernel ? {
    'windows' => undef,
    default   => '0600',
  }
  $_notify       = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  File {
    owner   => $user,
    group   => $group,
  }

  $host_template = { measurement => $host_measurement, tags => $host_tags }
  $service_template = { measurement => $service_measurement, tags => $service_tags}

  if $enable_ssl {
  
    # Set defaults for certificate stuff
    if $ssl_key_path {
      $_ssl_key_path = $ssl_key_path }
    else {
      $_ssl_key_path = "${ssl_dir}/InfluxdbWriter_influxdb.key" }
    if $ssl_cert_path {
      $_ssl_cert_path = $ssl_cert_path }
    else {
      $_ssl_cert_path = "${ssl_dir}/InfluxdbWriter_influxdb.crt" }
    if $ssl_cacert_path {
      $_ssl_cacert_path = $ssl_cacert_path }
    else {
      $_ssl_cacert_path = "${ssl_dir}/InfluxdbWriter_influxdb_ca.crt" }

    $attrs_ssl = {
      ssl_enable  => $enable_ssl,
      ssl_ca_cert => $_ssl_cacert_path,
      ssl_cert    => $_ssl_cert_path,
      ssl_key     => $_ssl_key_path,
    }

    case $pki {
      'puppet': {
        file { $_ssl_key_path:
          ensure => file,
          mode   => $_ssl_key_mode,
          source => $::icinga2_puppet_hostprivkey,
          tag    => 'icinga2::config::file',
        }

        file { $_ssl_cert_path:
          ensure => file,
          source => $::icinga2_puppet_hostcert,
          tag    => 'icinga2::config::file',
        }

        file { $_ssl_cacert_path:
          ensure => file,
          source => $::icinga2_puppet_localcacert,
          tag    => 'icinga2::config::file',
        }
      } # puppet

      'none': {
        if $ssl_key {
          $_ssl_key = $::osfamily ? {
            'windows' => regsubst($ssl_key, '\n', "\r\n", 'EMG'),
            default   => $ssl_key,
          }

          file { $_ssl_key_path:
            ensure  => file,
            mode    => $_ssl_key_mode,
            content => $_ssl_key,
            tag     => 'icinga2::config::file',
          }
        }

        if $ssl_cert {
          $_ssl_cert = $::osfamily ? {
            'windows' => regsubst($ssl_cert, '\n', "\r\n", 'EMG'),
            default   => $ssl_cert,
          }

          file { $_ssl_cert_path:
            ensure  => file,
            content => $_ssl_cert,
            tag     => 'icinga2::config::file',
          }
        }

        if $ssl_cacert {
          $_ssl_cacert = $::osfamily ? {
            'windows' => regsubst($ssl_cacert, '\n', "\r\n", 'EMG'),
            default   => $ssl_cacert,
          }

          file { $_ssl_cacert_path:
            ensure  => file,
            content => $_ssl_cacert,
            tag     => 'icinga2::config::file',
          }
        }
      } # none
    } # case pki
  } # enable_ssl
  else {
    $attrs_ssl = { ssl_enable  => $enable_ssl }
  }

  $attrs = {
    host                   => $host,
    port                   => $port,
    database               => $database,
    username               => $username,
    password               => $password,
    host_template          => $host_template,
    service_template       => $service_template,
    enable_send_thresholds => $enable_send_thresholds,
    enable_send_metadata   => $enable_send_metadata,
    flush_interval         => $flush_interval,
    flush_threshold        => $flush_threshold,
  }

  # create object
  icinga2::object { 'icinga2::object::InfluxdbWriter::influxdb':
    object_name => 'influxdb',
    object_type => 'InfluxdbWriter',
    attrs       => delete_undef_values(merge($attrs, $attrs_ssl)),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/influxdb.conf",
    notify      => $_notify,
    order       => 10,
  }

  # import library 'perfdata'
  concat::fragment { 'icinga2::feature::influxdb':
    target  => "${conf_dir}/features-available/influxdb.conf",
    content => "library \"perfdata\"\n\n",
    order   => '05',
  }

  icinga2::feature { 'influxdb':
    ensure => $ensure,
  }
}
