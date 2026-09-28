# @summary
#   Configures the Icinga 2 feature otlp-metrics.
#
# @param ensure
#   Set to present enables the feature perfdata, absent disables it.
#
# @param host
#   OTLP backend host address.
#
# @param port
#   OTLP backend HTTP port.
#
# @param metrics_endpoint
#    OTLP metrics endpoint path.
#
# @param service_namespace
#   The namespace to associate with emitted metrics used
#   in the `service.namespace` OTel resource attribute.
#
# @param basic_auth
#   Username and password for HTTP basic authentication.
#
# @param host_resource_attributes
#   Additional resource attributes to be included with host metrics.
#
# @param service_resource_attributes
#   Additional resource attributes to be included with service metrics.
#
# @param flush_interval
#   How long to buffer data points before transferring to the OTLP backend.
#
# @param flush_threshold
#   How many bytes to buffer before forcing a transfer to the OTLP backend.
#
# @param enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
# @param enable_send_thresholds
#   Whether to stream warning, critical, minimum & maximum as separate metrics to the OTLP backend.
#
# @param disconnect_timeout
#   Timeout to wait for any outstanding data to be flushed to the OTLP backend before disconnecting.
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
class icinga2::feature::otlpmetrics (
  Enum['absent', 'present']           $ensure                      = present,
  Optional[Stdlib::Host]              $host                        = undef,
  Optional[Stdlib::Port]              $port                        = undef,
  Optional[String[1]]                 $metrics_endpoint            = undef,
  Optional[String[1]]                 $service_namespace           = undef,
  Optional[Icinga2::BasicAuth]        $basic_auth                  = undef,
  Optional[Hash]                      $host_resource_attributes    = undef,
  Optional[Hash]                      $service_resource_attributes = undef,
  Optional[Icinga2::Interval]         $flush_interval              = undef,
  Optional[Integer[1]]                $flush_threshold             = undef,
  Optional[Boolean]                   $enable_ha                   = undef,
  Optional[Boolean]                   $enable_send_thresholds      = undef,
  Optional[Icinga2::Interval]         $disconnect_timeout          = undef,
  Optional[Boolean]                   $enable_ssl                  = undef,
  Optional[Boolean]                   $ssl_noverify                = undef,
  Optional[Stdlib::Absolutepath]      $ssl_key_path                = undef,
  Optional[Stdlib::Absolutepath]      $ssl_cert_path               = undef,
  Optional[Stdlib::Absolutepath]      $ssl_cacert_path             = undef,
  Optional[Icinga::Secret]            $ssl_key                     = undef,
  Optional[String[1]]                 $ssl_cert                    = undef,
  Optional[String[1]]                 $ssl_cacert                  = undef,
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

  $_basic_auth = if $basic_auth {
    if $basic_auth['password'] =~ String {
      $basic_auth + { 'password' => Sensitive($basic_auth['password']) }
    } elsif $basic_auth['password'] =~ Sensitive {
      $basic_auth
    }
  } else {
    undef
  }

  if $enable_ssl {
    $cert = icinga::cert::files(
      'OTLPMetricsWriter_otlpmetrics',
      $ssl_dir,
      $ssl_key_path,
      $ssl_cert_path,
      $ssl_cacert_path,
      $ssl_key,
      $ssl_cert,
      $ssl_cacert,
    )

    $attrs_ssl = {
      'enable_tls'            => true,
      'tls_insecure_noverify' => $ssl_noverify,
      'tls_ca_file'           => $cert['cacert_file'],
      'tls_cert_file'         => $cert['cert_file'],
      'tls_key_file'          => $cert['key_file'],
    }

    icinga::cert { 'OTLPMetricsWriter_otlpmetrics':
      args    => $cert,
      owner   => $owner,
      group   => $group,
      seltype => 'icinga2_var_lib_t',
      notify  => $_notify,
    }
  } else {
    $attrs_ssl = {
      'enable_tls'            => undef,
      'tls_insecure_noverify' => undef,
      'tls_ca_file'           => undef,
      'tls_cert_file'         => undef,
      'tls_key_file'          => undef,
    }
    $cert = {}
  }

  $attrs = {
    'host'                        => $host,
    'port'                        => $port,
    'metrics_endpoint'            => $metrics_endpoint,
    'service_namespace'           => $service_namespace,
    'basic_auth'                  => $_basic_auth,
    'host_resource_attributes'    => $host_resource_attributes,
    'service_resource_attributes' => $service_resource_attributes,
    'flush_interval'              => $flush_interval,
    'flush_threshold'             => $flush_threshold,
    'enable_ha'                   => $enable_ha,
    'enable_send_thresholds'      => $enable_send_thresholds,
    'disconnect_timeout'          => $disconnect_timeout,
  }

  # create object
  icinga2::object { 'icinga2::object::OTLPMetricsWriter::otlpmetrics':
    object_name => 'otlp-metrics',
    object_type => 'OTLPMetricsWriter',
    attrs       => delete_undef_values($attrs + $attrs_ssl),
    attrs_list  => concat(keys($attrs), keys($attrs_ssl)),
    target      => "${conf_dir}/features-available/otlpmetrics.conf",
    notify      => $_notify,
    order       => 10,
  }

  # manage feature
  icinga2::feature { 'otlpmetrics':
    ensure => $ensure,
  }
}
