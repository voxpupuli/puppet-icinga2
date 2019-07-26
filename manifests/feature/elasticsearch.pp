# == Class: icinga2::feature::elasticsearch
#
# This module configures the Icinga 2 feature elasticsearch.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature elasticsearch, absent disables it. Defaults to present.
#
# [*host*]
#    Elasticsearch host address. Icinga defaults to '127.0.0.1'.
#
# [*port*]
#    Elasticsearch HTTP port. Icinga defaults to '9200'.
#
# [*index*]
#    Elasticsearch index name. Icinga defaults to 'icinga2'.
#
# [*username*]
#    Elasticsearch user name.
#
# [*password*]
#    Elasticsearch user password.
#
# [*enable_ssl*]
#    Either enable or disable SSL. Other SSL parameters are only affected if this is set to 'true'.
#    Icinga defaults to 'false'.
#
# [*ssl_key_path*]
#   Location of the private key.
#
# [*ssl_cert_path*]
#   Location of the certificate.
#
# [*ssl_cacert_path*]
#   Location of the CA certificate.
#
# [*ssl_key*]
#   The private key in a base64 encoded string to store in spicified ssl_key_path file.
#   Default depends on platform:
#     /var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch.key on Linux
#     C:/ProgramData/icinga2/var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch.key on Windows
#
# [*ssl_cert*]
#   The certificate in a base64 encoded to store in spicified ssl_cert_path file.
#   Default depends on platform:
#     /var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch.crt on Linux
#     C:/ProgramData/icinga2/var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch.crt on Windows
#
# [*ssl_cacert*]
#   The CA root certificate in a base64 encoded string to store in spicified ssl_cacert_path file.
#   Default depends on platform:
#     /var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch_ca.crt on Linux
#     C:/ProgramData/icinga2/var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch_ca.crt on Windows
#
# [*enable_send_perfdata*]
#   Whether to send check performance data metrics. Icinga defaults to 'false'.
#
# [*flush_interval*]
#   How long to buffer data points before transferring to Elasticsearch. Icinga defaults to '10s'.
#
# [*flush_threshold*]
#   How many data points to buffer before forcing a transfer to Elasticsearch. Icinga defaults to '1024'.
#
# [*enable_ha*]
#   Enable the high availability functionality. Only valid in a cluster setup. Icinga defaults to false.
#
# === Example
#
# class { 'icinga2::feature::elasticsearch':
#   host     => "10.10.0.15",
#   index    => "icinga2"
# }
#
#
class icinga2::feature::elasticsearch(
  Enum['absent', 'present']              $ensure               = present,
  Optional[Stdlib::Host]                 $host                 = undef,
  Optional[Stdlib::Port::Unprivileged]   $port                 = undef,
  Optional[String]                       $index                = undef,
  Optional[String]                       $username             = undef,
  Optional[String]                       $password             = undef,
  Optional[Boolean]                      $enable_ssl           = undef,
  Optional[Stdlib::Absolutepath]         $ssl_key_path         = undef,
  Optional[Stdlib::Absolutepath]         $ssl_cert_path        = undef,
  Optional[Stdlib::Absolutepath]         $ssl_cacert_path      = undef,
  Optional[String]                       $ssl_key              = undef,
  Optional[String]                       $ssl_cert             = undef,
  Optional[String]                       $ssl_cacert           = undef,
  Optional[Boolean]                      $enable_send_perfdata = undef,
  Optional[Icinga2::Interval]            $flush_interval       = undef,
  Optional[Integer]                      $flush_threshold      = undef,
  Optional[Boolean]                      $enable_ha            = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $user          = $::icinga2::globals::user
  $group         = $::icinga2::globals::group
  $conf_dir      = $::icinga2::globals::conf_dir
  $_notify       = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  File {
    owner   => $user,
    group   => $group,
  }

  if $enable_ssl {

    $ssl_dir       = $::icinga2::globals::cert_dir
    $_ssl_key_mode = $::kernel ? {
      'windows' => undef,
      default   => '0600',
    }

    # Set defaults for certificate stuff and/or do validation
    if $ssl_key {
      if $ssl_key_path {
        $_ssl_key_path = $ssl_key_path }
      else {
        $_ssl_key_path = "${ssl_dir}/ElasticsearchWriter_elasticsearch.key"
      }

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
    } else {
      $_ssl_key_path = $ssl_key_path
    }

    if $ssl_cert {
      if $ssl_cert_path {
        $_ssl_cert_path = $ssl_cert_path }
      else {
        $_ssl_cert_path = "${ssl_dir}/ElasticsearchWriter_elasticsearch.crt"
      }

      $_ssl_cert = $::osfamily ? {
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
        $_ssl_cacert_path = "${ssl_dir}/ElasticsearchWriter_elasticsearch_ca.crt"
      }

      $_ssl_cacert = $::osfamily ? {
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
      enable_tls  => $enable_ssl,
      ca_path     => $_ssl_cacert_path,
      cert_path   => $_ssl_cert_path,
      key_path    => $_ssl_key_path,
    }
  } # enable_ssl
  else {
    $attrs_ssl = { enable_tls  => $enable_ssl }
  }

  $attrs = {
    host                   => $host,
    port                   => $port,
    index                  => $index,
    username               => $username,
    password               => $password,
    enable_send_perfdata   => $enable_send_perfdata,
    flush_interval         => $flush_interval,
    flush_threshold        => $flush_threshold,
    enable_ha              => $enable_ha,
  }

  # create object
  icinga2::object { 'icinga2::object::ElasticsearchWriter::elasticsearch':
    object_name => 'elasticsearch',
    object_type => 'ElasticsearchWriter',
    attrs       => delete_undef_values(merge($attrs, $attrs_ssl)),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/elasticsearch.conf",
    notify      => $_notify,
    order       => 10,
  }

  # import library 'perfdata'
  concat::fragment { 'icinga2::feature::elasticsearch':
    target  => "${conf_dir}/features-available/elasticsearch.conf",
    content => "library \"perfdata\"\n\n",
    order   => '05',
  }

  icinga2::feature { 'elasticsearch':
    ensure => $ensure,
  }
}
