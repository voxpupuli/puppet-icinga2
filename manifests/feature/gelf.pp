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
#   The client private key in PEM format. Only valid if ssl is enabled.
#
# @param ssl_cert
#   The client certificate in PEM format. Only valid if ssl is enabled.
#
# @param ssl_cacert
#   The CA certificate in PEM format. Only valid if ssl is enabled.
#
# @param ssl_noverify
#     Disable TLS peer verification. Only valid if ssl is enabled.
#
# @param enable_send_perfdata
#   Enable performance data for 'CHECK RESULT' events.
#
# @param enable_ha
#   Enable the high availability functionality. Only valid in a cluster setup.
#
class icinga2::feature::gelf (
  Enum['absent', 'present']      $ensure               = present,
  Optional[Stdlib::Host]         $host                 = undef,
  Optional[Stdlib::Port]         $port                 = undef,
  Optional[String[1]]            $source               = undef,
  Boolean                        $enable_ssl           = false,
  Optional[Stdlib::Absolutepath] $ssl_key_path         = undef,
  Optional[Stdlib::Absolutepath] $ssl_cert_path        = undef,
  Optional[Stdlib::Absolutepath] $ssl_cacert_path      = undef,
  Optional[Icinga::Secret]       $ssl_key              = undef,
  Optional[String[1]]            $ssl_cert             = undef,
  Optional[String[1]]            $ssl_cacert           = undef,
  Optional[Boolean]              $ssl_noverify         = undef,
  Optional[Boolean]              $enable_send_perfdata = undef,
  Optional[Boolean]              $enable_ha            = undef,
) {
  if ! defined(Class['icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $owner    = $icinga2::globals::user
  $group    = $icinga2::globals::group
  $conf_dir = $icinga2::globals::conf_dir
  $ssl_dir  = $icinga2::globals::cert_dir

  $_notify = $ensure ? {
    'present' => Class['icinga2::service'],
    default   => undef,
  }

  if $enable_ssl {
    $cert = icinga::cert::files(
      'GelfWriter_gelf',
      $ssl_dir,
      $ssl_key_path,
      $ssl_cert_path,
      $ssl_cacert_path,
      $ssl_key,
      $ssl_cert,
      $ssl_cacert,
    )

    $attrs_ssl = {
      'enable_tls'        => true,
      'insecure_noverify' => $ssl_noverify,
      'ca_path'           => $cert['cacert_file'],
      'cert_path'         => $cert['cert_file'],
      'key_path'          => $cert['key_file'],
    }

    # Workaround, icinga::cert doesn't accept undef values for owner and group!
    if $facts['os']['family'] != 'windows' {
      icinga::cert { 'GelfWriter_gelf':
        args   => $cert,
        owner  => $owner,
        group  => $group,
        notify => $_notify,
      }
    } else {
      icinga::cert { 'GelfWriter_gelf':
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

  # compose attributes
  $attrs = {
    'host'                 => $host,
    'port'                 => $port,
    'source'               => $source,
    'enable_send_perfdata' => $enable_send_perfdata,
    'enable_ha'            => $enable_ha,
  }

  # create object
  icinga2::object { 'icinga2::object::GelfWriter::gelf':
    object_name => 'gelf',
    object_type => 'GelfWriter',
    attrs       => delete_undef_values($attrs + $attrs_ssl),
    attrs_list  => concat(keys($attrs), keys($attrs_ssl)),
    target      => "${conf_dir}/features-available/gelf.conf",
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'gelf':
    ensure => $ensure,
  }
}
