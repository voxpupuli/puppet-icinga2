# @summary
#   Configures the Icinga 2 feature elasticsearch.
#
# @example
#   class { 'icinga2::feature::elasticsearch':
#     host     => "10.10.0.15",
#     index    => "icinga2"
#   }
#
# @param ensure
#   Set to present enables the feature elasticsearch, absent disables it.
#
# @param host
#    Elasticsearch host address.
#
# @param port
#    Elasticsearch HTTP port.
#
# @param index
#    Elasticsearch index name.
#
# @param username
#    Elasticsearch user name.
#
# @param password
#    Elasticsearch user password. The password parameter isn't parsed anymore.
#
# @param enable_ssl
#    Either enable or disable SSL. Other SSL parameters are only affected if this is set to 'true'.
#
# @param ssl_noverify
#     Disable TLS peer verification. Only valid if ssl is enabled.
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
# @param enable_send_perfdata
#   Whether to send check performance data metrics.
#
# @param flush_interval
#   How long to buffer data points before transferring to Elasticsearch.
#
# @param flush_threshold
#   How many data points to buffer before forcing a transfer to Elasticsearch.
#
# @param enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
class icinga2::feature::elasticsearch (
  Enum['absent', 'present']      $ensure               = present,
  Optional[Stdlib::Host]         $host                 = undef,
  Optional[Stdlib::Port]         $port                 = undef,
  Optional[String[1]]            $index                = undef,
  Optional[String[1]]            $username             = undef,
  Optional[Icinga::Secret]       $password             = undef,
  Optional[Boolean]              $enable_ssl           = undef,
  Optional[Boolean]              $ssl_noverify         = undef,
  Optional[Stdlib::Absolutepath] $ssl_key_path         = undef,
  Optional[Stdlib::Absolutepath] $ssl_cert_path        = undef,
  Optional[Stdlib::Absolutepath] $ssl_cacert_path      = undef,
  Optional[Icinga::Secret]       $ssl_key              = undef,
  Optional[String[1]]            $ssl_cert             = undef,
  Optional[String[1]]            $ssl_cacert           = undef,
  Optional[Boolean]              $enable_send_perfdata = undef,
  Optional[Icinga2::Interval]    $flush_interval       = undef,
  Optional[Integer[0]]           $flush_threshold      = undef,
  Optional[Boolean]              $enable_ha            = undef,
) {
  if ! defined(Class['icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $owner         = $icinga2::globals::user
  $group         = $icinga2::globals::group
  $conf_dir      = $icinga2::globals::conf_dir
  $ssl_dir       = $icinga2::globals::cert_dir

  $_password = if $password =~ Sensitive {
    $password
  } elsif $password =~ String {
    Sensitive($password)
  } else {
    undef
  }

  $_notify       = $ensure ? {
    'present' => Class['icinga2::service'],
    default   => undef,
  }

  if $enable_ssl {
    $cert = icinga::cert::files(
      'ElasticsearchWriter_elasticsearch',
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
      'ssl_insecure_noverify' => $ssl_noverify,
      'ca_path'               => $cert['cacert_file'],
      'cert_path'             => $cert['cert_file'],
      'key_path'              => $cert['key_file'],
    }

    # Workaround, icinga::cert doesn't accept undef values for owner and group!
    if $facts['os']['family'] != 'windows' {
      icinga::cert { 'ElasticsearchWriter_elasticsearch':
        args   => $cert,
        owner  => $owner,
        group  => $group,
        notify => $_notify,
      }
    } else {
      icinga::cert { 'ElasticsearchWriter_elasticsearch':
        args   => $cert,
        owner  => 'foo',
        group  => 'bar',
        notify => $_notify,
      }
    }
  } else {
    $attrs_ssl = {
      'enable_tls'        => undef,
      'insecure_noverify' => undef,
      'ca_path'           => undef,
      'cert_path'         => undef,
      'key_path'          => undef,
    }
    $cert = {}
  }

  $attrs = {
    'host'                   => $host,
    'port'                   => $port,
    'index'                  => $index,
    'username'               => $username,
    'password'               => $_password,
    'enable_send_perfdata'   => $enable_send_perfdata,
    'flush_interval'         => $flush_interval,
    'flush_threshold'        => $flush_threshold,
    'enable_ha'              => $enable_ha,
  }

  # create object
  icinga2::object { 'icinga2::object::ElasticsearchWriter::elasticsearch':
    object_name => 'elasticsearch',
    object_type => 'ElasticsearchWriter',
    attrs       => delete_undef_values($attrs + $attrs_ssl),
    attrs_list  => concat(keys($attrs), keys($attrs_ssl)),
    target      => "${conf_dir}/features-available/elasticsearch.conf",
    notify      => $_notify,
    order       => 10,
  }

  icinga2::feature { 'elasticsearch':
    ensure => $ensure,
  }
}
