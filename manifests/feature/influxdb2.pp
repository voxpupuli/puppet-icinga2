# @summary
#   Configures the Icinga 2 feature influxdb2.
#
# @example
#   class { 'icinga2::feature::influxdb2':
#     host         => "10.10.0.15",
#     organization => "ICINGA",
#     bucket       => "icinga2",
#     auth_token   => "supersecret",
#   }
#
# @param ensure
#   Set to present enables the feature influxdb, absent disables it.
#
# @param host
#    InfluxDB host address.
#
# @param port
#    InfluxDB HTTP port.
#
# @param organization
#    InfluxDB organization name.
#
# @param bucket
#    InfluxDB bucket name.
#
# @param auth_token
#    InfluxDB authentication token.
#
# @param enable_ssl
#    Either enable or disable SSL. Other SSL parameters are only affected if this is set to 'true'.
#
# @param ssl_noverify
#    Disable TLS peer verification.
#
# @param ssl_key_path
#   Location of the private key.
#
# @param ssl_cert_path
#   Location of the certificate.
#
# @param ssl_cacert_path
#   Location of the CA certificate.
#
# @param ssl_key
#   The private key in a base64 encoded string to store in ssl_key_path file.
#
# @param ssl_cert
#   The certificate in a base64 encoded string to store in ssl_cert_path file.
#
# @param ssl_cacert
#   The CA root certificate in a base64 encoded to store in ssl_cacert_path file.
#
# @param host_measurement
#    The value of this is used for the measurement setting in host_template.
#
# @param host_tags
#    Tags defined in this hash will be set in the host_template.
#
# @param service_measurement
#    The value of this is used for the measurement setting in host_template.
#
# @param service_tags
#    Tags defined in this hash will be set in the service_template.
#
# @param enable_send_thresholds
#    Whether to send warn, crit, min & max tagged data.
#
# @param enable_send_metadata
#    Whether to send check metadata e.g. states, execution time, latency etc.
#
# @param flush_interval
#    How long to buffer data points before transfering to InfluxDB.
#
# @param flush_threshold
#    How many data points to buffer before forcing a transfer to InfluxDB.
#
# @param enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
class icinga2::feature::influxdb2(
  String                              $organization,
  String                              $bucket,
  Variant[String, Sensitive[String]]  $auth_token,
  Enum['absent', 'present']           $ensure                 = present,
  Optional[Stdlib::Host]              $host                   = undef,
  Optional[Stdlib::Port]              $port                   = undef,
  Optional[Boolean]                   $enable_ssl             = undef,
  Optional[Boolean]                   $ssl_noverify           = undef,
  Optional[Stdlib::Absolutepath]      $ssl_key_path           = undef,
  Optional[Stdlib::Absolutepath]      $ssl_cert_path          = undef,
  Optional[Stdlib::Absolutepath]      $ssl_cacert_path        = undef,
  Optional[Stdlib::Base64]            $ssl_key                = undef,
  Optional[Stdlib::Base64]            $ssl_cert               = undef,
  Optional[Stdlib::Base64]            $ssl_cacert             = undef,
  String                              $host_measurement       = '$host.check_command$',
  Hash                                $host_tags              = { hostname => '$host.name$' },
  String                              $service_measurement    = '$service.check_command$',
  Hash                                $service_tags           = { hostname => '$host.name$', service => '$service.name$' },
  Optional[Boolean]                   $enable_send_thresholds = undef,
  Optional[Boolean]                   $enable_send_metadata   = undef,
  Optional[Icinga2::Interval]         $flush_interval         = undef,
  Optional[Integer[1]]                $flush_threshold        = undef,
  Optional[Boolean]                   $enable_ha              = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $user          = $::icinga2::globals::user
  $group         = $::icinga2::globals::group
  $conf_dir      = $::icinga2::globals::conf_dir
  $ssl_dir       = $::icinga2::globals::cert_dir

  $_ssl_key_mode = $::facts['kernel'] ? {
    'windows' => undef,
    default   => '0600',
  }

  $_notify       = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  $_auth_token = if $auth_token =~ Sensitive {
    $auth_token
  } else {
    Sensitive($auth_token)
  }

  File {
    owner   => $user,
    group   => $group,
  }

  $host_template = { measurement => $host_measurement, tags => $host_tags }
  $service_template = { measurement => $service_measurement, tags => $service_tags}

  if $enable_ssl {

    # Set defaults for certificate stuff
    if $ssl_key {
      if $ssl_key_path {
        $_ssl_key_path = $ssl_key_path }
      else {
        $_ssl_key_path = "${ssl_dir}/Influxdb2Writer_influxdb2.key"
      }

      $_ssl_key = $::facts['os']['family'] ? {
        'windows' => regsubst($ssl_key, '\n', "\r\n", 'EMG'),
        default   => $ssl_key,
      }

      file { $_ssl_key_path:
        ensure    => file,
        mode      => $_ssl_key_mode,
        content   => $_ssl_key,
        show_diff => false,
        tag       => 'icinga2::config::file',
      }
    } else {
      $_ssl_key_path = $ssl_key_path
    }

    if $ssl_cert {
      if $ssl_cert_path {
        $_ssl_cert_path = $ssl_cert_path }
      else {
        $_ssl_cert_path = "${ssl_dir}/Influxdb2Writer_influxdb2.crt"
      }

      $_ssl_cert = $::facts['os']['family'] ? {
        'windows' => regsubst($ssl_cert, '\n', "\r\n", 'EMG'),
        default   => $ssl_cert,
      }

      file { $_ssl_cert_path:
        ensure  => file,
        content => $_ssl_cert,
        tag     => 'icinga2::config::file',
      }
    } else {
      $_ssl_cert_path = $ssl_cert_path
    }

    if $ssl_cacert {
      if $ssl_cacert_path {
        $_ssl_cacert_path = $ssl_cacert_path }
      else {
        $_ssl_cacert_path = "${ssl_dir}/Influxdb2Writer_influxdb2_ca.crt"
      }

      $_ssl_cacert = $::facts['os']['family'] ? {
        'windows' => regsubst($ssl_cacert, '\n', "\r\n", 'EMG'),
        default   => $ssl_cacert,
      }

      file { $_ssl_cacert_path:
        ensure  => file,
        content => $_ssl_cacert,
        tag     => 'icinga2::config::file',
      }
    } else {
      $_ssl_cacert_path = $ssl_cacert_path
    }

    $attrs_ssl = {
      ssl_enable            => $enable_ssl,
      ssl_insecure_noverify => $ssl_noverify,
      ssl_ca_cert           => $_ssl_cacert_path,
      ssl_cert              => $_ssl_cert_path,
      ssl_key               => $_ssl_key_path,
    }
  } # enable_ssl
  else {
    $attrs_ssl = { ssl_enable  => $enable_ssl }
  }

  $attrs = {
    host                   => $host,
    port                   => $port,
    organization           => $organization,
    bucket                 => $bucket,
    auth_token             => $_auth_token,
    host_template          => $host_template,
    service_template       => $service_template,
    enable_send_thresholds => $enable_send_thresholds,
    enable_send_metadata   => $enable_send_metadata,
    flush_interval         => $flush_interval,
    flush_threshold        => $flush_threshold,
    enable_ha              => $enable_ha,
  }

  # create object
  icinga2::object { 'icinga2::object::Influxdb2Writer::influxdb2':
    object_name => 'influxdb2',
    object_type => 'Influxdb2Writer',
    attrs       => delete_undef_values(merge($attrs, $attrs_ssl)),
    attrs_list  => concat(keys($attrs), keys($attrs_ssl)),
    target      => "${conf_dir}/features-available/influxdb2.conf",
    notify      => $_notify,
    order       => 10,
  }

  icinga2::feature { 'influxdb2':
    ensure => $ensure,
  }
}
