# @summary
#   Configures the Icinga 2 feature influxdb.
#
# @example
#   class { 'icinga2::feature::influxdb':
#     host     => "10.10.0.15",
#     username => "icinga2",
#     password => "supersecret",
#     database => "icinga2"
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
# @param database
#    InfluxDB database name.
#
# @param username
#    InfluxDB user name.
#
# @param password
#    InfluxDB user password. The password parameter isn't parsed anymore.
#
# @param basic_auth
#    Username and password for HTTP basic authentication.
#
# @param enable_ssl
#    Either enable or disable SSL. Other SSL parameters are only affected if this is set to 'true'.
#
# @param ssl_noverify
#    Disable TLS peer verification. Only valid if ssl is enabled.
#
# @param ssl_key_path
#   Location of the client private key. Only valid if ssl is enabled.
#
# @param ssl_cert_path
#   Location of the client certificate. Only valid if ssl is enabled.
#
# @param ssl_cacert_path
#   Location of the CA certificate. Only valid if ssl is enabled.
#
# @param ssl_key
#   The client private key in PEM format. Only valid if ssl is enabled.
#
# @param ssl_cert
#   The client certificate in PEM format. Only valid if ssl is enabled.
#
# @param ssl_cacert
#   The CA root certificate in PEM format. Only valid if ssl is enabled.
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
class icinga2::feature::influxdb (
  Enum['absent', 'present']                     $ensure                 = present,
  Optional[Stdlib::Host]                        $host                   = undef,
  Optional[Stdlib::Port]                        $port                   = undef,
  Optional[String[1]]                              $database               = undef,
  Optional[String[1]]                              $username               = undef,
  Optional[Icinga::Secret]                      $password               = undef,
  Optional[Icinga2::BasicAuth]                  $basic_auth             = undef,
  Optional[Boolean]                             $enable_ssl             = undef,
  Optional[Boolean]                             $ssl_noverify           = undef,
  Optional[Stdlib::Absolutepath]                $ssl_key_path           = undef,
  Optional[Stdlib::Absolutepath]                $ssl_cert_path          = undef,
  Optional[Stdlib::Absolutepath]                $ssl_cacert_path        = undef,
  Optional[Icinga::Secret]                      $ssl_key                = undef,
  Optional[String[1]]                           $ssl_cert               = undef,
  Optional[String[1]]                           $ssl_cacert             = undef,
  String[1]                                     $host_measurement       = '$host.check_command$',
  Hash[String[1], String[1]]                    $host_tags              = { hostname => '$host.name$' },
  String[1]                                     $service_measurement    = '$service.check_command$',
  Hash[String[1], String[1]]                    $service_tags           = { hostname => '$host.name$', service => '$service.name$' },
  Optional[Boolean]                             $enable_send_thresholds = undef,
  Optional[Boolean]                             $enable_send_metadata   = undef,
  Optional[Icinga2::Interval]                   $flush_interval         = undef,
  Optional[Integer[1]]                          $flush_threshold        = undef,
  Optional[Boolean]                             $enable_ha              = undef,
) {
  if ! defined(Class['icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $owner    = $icinga2::globals::user
  $group    = $icinga2::globals::group
  $conf_dir = $icinga2::globals::conf_dir
  $ssl_dir  = $icinga2::globals::cert_dir

  $_notify  = $ensure ? {
    'present' => Class['icinga2::service'],
    default   => undef,
  }

  if $basic_auth {
    $_basic_auth = if $basic_auth['password'] =~ String {
      $basic_auth + { 'password' => Sensitive($password) }
    } elsif $basic_auth['password'] =~ Sensitive {
      $basic_auth
    }
  } else {
    $_basic_auth = undef
  }

  $_password = if $password =~ Sensitive {
    $password
  } elsif $password =~ String {
    Sensitive($password)
  } else {
    undef
  }

  $host_template    = { measurement => $host_measurement, tags => $host_tags }
  $service_template = { measurement => $service_measurement, tags => $service_tags }

  if $enable_ssl {
    $cert = icinga::cert::files(
      'InfluxdbWriter_influxdb',
      $ssl_dir,
      $ssl_key_path,
      $ssl_cert_path,
      $ssl_cacert_path,
      $ssl_key,
      $ssl_cert,
      $ssl_cacert,
    )

    $attrs_ssl = {
      'ssl_enable'            => true,
      'ssl_insecure_noverify' => $ssl_noverify,
      'ssl_ca_cert'           => $cert['cacert_file'],
      'ssl_cert'              => $cert['cert_file'],
      'ssl_key'               => $cert['key_file'],
    }

    # Workaround, icinga::cert doesn't accept undef values for owner and group!
    if $facts['os']['family'] != 'windows' {
      icinga::cert { 'InfluxdbWriter_influxdb':
        args   => $cert,
        owner  => $owner,
        group  => $group,
        notify => $_notify,
      }
    } else {
      icinga::cert { 'InfluxdbWriter_influxdb':
        args   => $cert,
        owner  => 'foo',
        group  => 'bar',
        notify => $_notify,
      }
    }
  } else {
    $attrs_ssl = {
      'ssl_enable'            => undef,
      'ssl_insecure_noverify' => undef,
      'ssl_ca_cert'           => undef,
      'ssl_cert'              => undef,
      'ssl_key'               => undef,
    }
    $cert = {}
  }

  $attrs = {
    'host'                   => $host,
    'port'                   => $port,
    'database'               => $database,
    'username'               => $username,
    'password'               => $_password,
    'basic_auth'             => $_basic_auth,
    'host_template'          => $host_template,
    'service_template'       => $service_template,
    'enable_send_thresholds' => $enable_send_thresholds,
    'enable_send_metadata'   => $enable_send_metadata,
    'flush_interval'         => $flush_interval,
    'flush_threshold'        => $flush_threshold,
    'enable_ha'              => $enable_ha,
  }

  # create object
  icinga2::object { 'icinga2::object::InfluxdbWriter::influxdb':
    object_name => 'influxdb',
    object_type => 'InfluxdbWriter',
    attrs       => delete_undef_values($attrs + $attrs_ssl),
    attrs_list  => concat(keys($attrs), keys($attrs_ssl)),
    target      => "${conf_dir}/features-available/influxdb.conf",
    notify      => $_notify,
    order       => 10,
  }

  icinga2::feature { 'influxdb':
    ensure => $ensure,
  }
}
