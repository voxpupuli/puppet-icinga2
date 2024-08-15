# @summary
#   Configures the Icinga 2 feature icingadb.
#
# @param ensure
#   Set to present, enables the feature icingadb, absent disabled it.
#
# @param host
#   IcingaDB Redis host address.
#
# @param port
#   IcingaDB Redis port.
#
# @param socket_path
#   IcingaDB Redis unix sockt. Can be used instead of host and port attributes.
#
# @param connect_timeout
#   Timeout for establishing new connections.
#
# @param password
#   IcingaDB Redis password. The password parameter isn't parsed anymore.
#
# @param env_id
#   The ID is used in all Icinga DB components to separate data from multiple
#   different environments and is written to the file `/var/lib/icinga2/icingadb.env`
#   by Icinga 2. Icinga 2 generates a unique environment ID from its CA certificate
#   when it is first started with the Icinga DB feature enabled.
#
# @param enable_tls
#   Either enable or disable SSL/TLS. Other SSL parameters are only affected if this is set to 'true'.
#
# @param tls_key_file
#   Location of the private key. Only valid if tls is enabled.
#
# @param tls_cert_file
#   Location of the certificate. Only valid if tls is enabled.
#
# @param tls_cacert_file
#   Location of the CA certificate. Only valid if tls is enabled.
#
# @param tls_crl_file
#   Location of the Certicicate Revocation List. Only valid if tls is enabled.
#
# @param tls_key
#   The private key in a PEM formated string to store spicified in tls_key_file.
#   Only valid if tls is enabled.
#
# @param tls_cert
#   The certificate in a PEM format string to store spicified in tls_cert_file.
#   Only valid if tls is enabled.
#
# @param tls_cacert
#   The CA root certificate in a PEM formated string to store spicified in tls_cacert_file.
#   Only valid if tls is enabled.
#
# @param tls_capath
#    Path to all trusted CA certificates. Only valid if tls is enabled.
#
# @param tls_cipher
#    List of allowed ciphers. Only valid if tls is enabled.
#
# @param tls_protocolmin
#    Minimum TLS protocol version like `TLSv1.2`. Only valid if tls is enabled.
#
# @param tls_noverify
#    Whether not to verify the peer.
#
class icinga2::feature::icingadb (
  Enum['absent', 'present']      $ensure          = present,
  Optional[Stdlib::Host]         $host            = undef,
  Optional[Stdlib::Port]         $port            = undef,
  Optional[Stdlib::Absolutepath] $socket_path     = undef,
  Optional[Icinga2::Interval]    $connect_timeout = undef,
  Optional[Icinga::Secret]       $password        = undef,
  Optional[Icinga::Secret]       $env_id          = undef,
  Boolean                        $enable_tls      = false,
  Optional[Stdlib::Absolutepath] $tls_key_file    = undef,
  Optional[Stdlib::Absolutepath] $tls_cert_file   = undef,
  Optional[Stdlib::Absolutepath] $tls_cacert_file = undef,
  Optional[Stdlib::Absolutepath] $tls_crl_file    = undef,
  Optional[Icinga::Secret]       $tls_key         = undef,
  Optional[String[1]]            $tls_cert        = undef,
  Optional[String[1]]            $tls_cacert      = undef,
  Optional[String[1]]            $tls_capath      = undef,
  Optional[String[1]]            $tls_cipher      = undef,
  Optional[String[1]]            $tls_protocolmin = undef,
  Optional[Boolean]              $tls_noverify    = undef,
) {
  if ! defined(Class['icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir = $icinga2::globals::conf_dir
  $data_dir = $icinga2::globals::data_dir
  $cert_dir = $icinga2::globals::cert_dir
  $owner    = $icinga2::globals::user
  $group    = $icinga2::globals::group

  $_password = if $password =~ Sensitive {
    $password
  } elsif $password =~ String {
    Sensitive($password)
  } else {
    undef
  }

  $_notify = $ensure ? {
    'present' => Class['icinga2::service'],
    default   => undef,
  }

  if $env_id {
    file { "${data_dir}/icingadb.env":
      ensure    => file,
      owner     => $owner,
      group     => $group,
      mode      => '0600',
      seltype   => 'icinga2_etc_t',
      content   => sprintf('"%s"', unwrap($env_id)),
      show_diff => false,
      tag       => 'icinga2::config::file',
    }
  }

  if $enable_tls {
    $cert = icinga::cert::files(
      'IcingaDB-icingadb',
      $cert_dir,
      $tls_key_file,
      $tls_cert_file,
      $tls_cacert_file,
      $tls_key,
      $tls_cert,
      $tls_cacert,
    )

    $attrs_tls = {
      'enable_tls'        => true,
      'ca_path'           => $cert['cacert_file'],
      'cert_path'         => $cert['cert_file'],
      'key_path'          => $cert['key_file'],
      'crl_path'          => $tls_crl_file,
      'insecure_noverify' => $tls_noverify,
      'cipher_list'       => $tls_cipher,
      'tls_protocolmin'   => $tls_protocolmin,
    }

    # Workaround, icinga::cert doesn't accept undef values for owner and group!
    if $facts['os']['family'] != 'windows' {
      icinga::cert { 'IcingaDB-icingadb':
        args   => $cert,
        owner  => $owner,
        group  => $group,
        notify => $_notify,
      }
    } else {
      icinga::cert { 'IcingaDB-icingadb':
        args   => $cert,
        owner  => 'foo',
        group  => 'bar',
        notify => $_notify,
      }
    }
  } # enable_tls
  else {
    $attrs_tls = {
      'enable_tls'        => undef,
      'ca_path'           => undef,
      'cert_path'         => undef,
      'key_path'          => undef,
      'crl_path'          => undef,
      'insecure_noverify' => undef,
      'cipher_list'       => undef,
      'tls_protocolmin'   => undef,
    }
    $cert      = {}
  }

  # compose attributes
  $attrs = {
    'host'     => $host,
    'port'     => $port,
    'path'     => $socket_path,
    'password' => $_password,
  }

  # create object
  icinga2::object { 'icinga2::object::IcingaDB::icingadb':
    object_name => 'icingadb',
    object_type => 'IcingaDB',
    attrs       => delete_undef_values($attrs + $attrs_tls),
    attrs_list  => concat(keys($attrs), keys($attrs_tls)),
    target      => "${conf_dir}/features-available/icingadb.conf",
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'icingadb':
    ensure => $ensure,
  }
}
