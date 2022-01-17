# @summary
#   Configures the Icinga 2 feature gelf.
#
# @param ensure
#   Set to present enables the feature gelf, absent disables it.
#
# @param host
#   GELF receiver host address.
#
# @param port
#   GELF receiver port.
#
# @param source
#   Source name for this instance.
#
# @param enable_ssl
#    Either enable or disable SSL/TLS. Other SSL parameters are only affected if this is set to 'true'.
#
# @param ssl_key_path
#   Location of the private key. Only valid if ssl is enabled.
#
# @param ssl_cert_path
#   Location of the certificate. Only valid if ssl is enabled.
#
# @param ssl_cacert_path
#   Location of the CA certificate. Only valid if ssl is enabled.
#
# @param ssl_key
#   The private key in a base64 encoded string to store in spicified ssl_key_path file.
#   Only valid if ssl is enabled.
#
# @param ssl_cert
#   The certificate in a base64 encoded string to store in spicified ssl_cert_path file.
#   Only valid if ssl is enabled.
#
# @param ssl_cacert
#   The CA root certificate in a base64 encoded string to store in spicified ssl_cacert_path file.
#   Only valid if ssl is enabled.
#
# @param ssl_noverify
#     Disable TLS peer verification.
#
# @param enable_send_perfdata
#   Enable performance data for 'CHECK RESULT' events.
#
# @param enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
class icinga2::feature::gelf(
  Enum['absent', 'present']                $ensure               = present,
  Optional[Stdlib::Host]                   $host                 = undef,
  Optional[Stdlib::Port::Unprivileged]     $port                 = undef,
  Optional[String]                         $source               = undef,
  Boolean                                  $enable_ssl           = false,
  Optional[Stdlib::Absolutepath]           $ssl_key_path         = undef,
  Optional[Stdlib::Absolutepath]           $ssl_cert_path        = undef,
  Optional[Stdlib::Absolutepath]           $ssl_cacert_path      = undef,
  Optional[Stdlib::Base64]                 $ssl_key              = undef,
  Optional[Stdlib::Base64]                 $ssl_cert             = undef,
  Optional[Stdlib::Base64]                 $ssl_cacert           = undef,
  Optional[Boolean]                        $ssl_noverify         = undef,
  Optional[Boolean]                        $enable_send_perfdata = undef,
  Optional[Boolean]                        $enable_ha            = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $owner    = $::icinga2::globals::user
  $group    = $::icinga2::globals::group
  $conf_dir = $::icinga2::globals::conf_dir
  $ssl_dir  = $::icinga2::globals::cert_dir

  $_ssl_key_mode = $::facts['os']['family'] ? {
    'windows' => undef,
    default   => '0600',
  }

  $_notify = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  File {
    owner   => $owner,
    group   => $group,
  }


  if $enable_ssl {
    # Set defaults for certificate stuff
    if $ssl_key {
      if $ssl_key_path {
        $_ssl_key_path = $ssl_key_path }
      else {
        $_ssl_key_path = "${ssl_dir}/GelfWriter_gelf.key"
      }

      $_ssl_key = $::facts['os']['family'] ? {
        'windows' => regsubst($ssl_key, '\n', "\r\n", 'EMG'),
        default   => $ssl_key,
      }

      file { $_ssl_key_path:
        ensure    => file,
        mode      => $_ssl_key_mode,
        content   => $ssl_key,
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
        $_ssl_cert_path = "${ssl_dir}/GelfWriter_gelf.crt"
      }

      $_ssl_cert = $::facts['os']['family'] ? {
        'windows' => regsubst($ssl_cert, '\n', "\r\n", 'EMG'),
        default   => $ssl_cert,
      }

      file { $_ssl_cert_path:
        ensure  => file,
        content => $ssl_cert,
        tag     => 'icinga2::config::file',
      }
    } else {
      $_ssl_cert_path = $ssl_cert_path
    }

    if $ssl_cacert {
      if $ssl_cacert_path {
        $_ssl_cacert_path = $ssl_cacert_path }
      else {
        $_ssl_cacert_path = "${ssl_dir}/GelfWriter_gelf_ca.crt"
      }

      $_ssl_cacert = $::facts['os']['family'] ? {
        'windows' => regsubst($ssl_cacert, '\n', "\r\n", 'EMG'),
        default   => $ssl_cacert,
      }

      file { $_ssl_cacert_path:
        ensure  => file,
        content => $ssl_cacert,
        tag     => 'icinga2::config::file',
      }
    } else {
      $_ssl_cacert_path = $ssl_cacert_path
    }

    $attrs_ssl = {
      enable_tls        => $enable_ssl,
      insecure_noverify => $ssl_noverify,
      ca_path           => $_ssl_cacert_path,
      cert_path         => $_ssl_cert_path,
      key_path          => $_ssl_key_path,
    }
  } # enable_ssl
  else {
    $attrs_ssl = { enable_tls  => $enable_ssl }
  }


  # compose attributes
  $attrs = {
    host                 => $host,
    port                 => $port,
    source               => $source,
    enable_send_perfdata => $enable_send_perfdata,
    enable_ha            => $enable_ha,
  }

  # create object
  icinga2::object { 'icinga2::object::GelfWriter::gelf':
    object_name => 'gelf',
    object_type => 'GelfWriter',
    attrs       => delete_undef_values(merge($attrs, $attrs_ssl)),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/gelf.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'perfdata'
  concat::fragment { 'icinga2::feature::gelf':
    target  => "${conf_dir}/features-available/gelf.conf",
    content => "library \"perfdata\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'gelf':
    ensure => $ensure,
  }
}
