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
# [*pki*]
#   Provides multiple sources for the certificate, key and ca. Valid parameters are 'puppet' or 'none'.
#   'puppet' copies the key, cert and CAcert from the Puppet ssl directory to the pki directory
#   /var/lib/icinga2/certs on Linux and C:/ProgramData/icinga2/var/lib/icinga2/certs on Windows.
#   'none' does nothing and you either have to manage the files yourself as file resources
#   or use the ssl_key, ssl_cert, ssl_cacert parameters. Defaults to puppet.
#
# [*ssl_key_path*]
#   Location of the private key. Default depends on platform:
#   /var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch.key on Linux
#   C:/ProgramData/icinga2/var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch.key on Windows
#   The Value of NodeName comes from the corresponding constant.
#
# [*ssl_cert_path*]
#   Location of the certificate. Default depends on platform:
#   /var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch.crt on Linux
#   C:/ProgramData/icinga2/var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch.crt on Windows
#   The Value of NodeName comes from the corresponding constant.
#
# [*ssl_cacert_path*]
#   Location of the CA certificate. Default depends on platform:
#   /var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch_ca.crt on Linux
#   C:/ProgramData/icinga2/var/lib/icinga2/certs/ElasticsearchWriter_elasticsearch_ca.crt on Windows
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
# [*enable_send_perfdata*]
#    Whether to send check performance data metrics. Icinga defaults to 'false'.
#
# [*flush_interval*]
#    How long to buffer data points before transferring to Elasticsearch. Icinga defaults to '10s'.
#
# [*flush_threshold*]
#    How many data points to buffer before forcing a transfer to Elasticsearch. Icinga defaults to '1024'.
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
  Enum['none', 'puppet']                 $pki                  = 'puppet',
  Optional[Stdlib::Absolutepath]         $ssl_key_path         = undef,
  Optional[Stdlib::Absolutepath]         $ssl_cert_path        = undef,
  Optional[Stdlib::Absolutepath]         $ssl_cacert_path      = undef,
  Optional[String]                       $ssl_key              = undef,
  Optional[String]                       $ssl_cert             = undef,
  Optional[String]                       $ssl_cacert           = undef,
  Optional[Boolean]                      $enable_send_perfdata = undef,
  Optional[Pattern[/^\d+[ms]*$/]]        $flush_interval       = undef,
  Optional[Integer]                      $flush_threshold      = undef,
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
    if $ssl_key_path {
      $_ssl_key_path = $ssl_key_path }
    else {
      $_ssl_key_path = "${ssl_dir}/ElasticsearchWriter_elasticsearch.key" }
    if $ssl_cert_path {
      $_ssl_cert_path = $ssl_cert_path }
    else {
      $_ssl_cert_path = "${ssl_dir}/ElasticsearchWriter_elasticsearch.crt" }
    if $ssl_cacert_path {
      $_ssl_cacert_path = $ssl_cacert_path }
    else {
      $_ssl_cacert_path = "${ssl_dir}/ElasticsearchWriter_elasticsearch_ca.crt" }

    $attrs_ssl = {
      enable_tls  => $enable_ssl,
      ca_path     => $_ssl_cacert_path,
      cert_path   => $_ssl_cert_path,
      key_path    => $_ssl_key_path,
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
