# @summary
#   Configures the Icinga 2 feature api.
#
# @example Use the puppet certificates and key copy these files to the cert directory named to 'hostname.key', 'hostname.crt' and 'ca.crt' if the contant NodeName is set to 'hostname'.
#   include icinga2::feature::api
#
# @example To use your own certificates and key as file resources if the contant NodeName is set to fqdn (default) do:
#   class { 'icinga2::feature::api':
#     pki => 'none',
#   }
#
#   File {
#     owner => 'icinga',
#     group => 'icinga',
#   }
#
#   file { "/var/lib/icinga2/certs/${::fqdn}.key":
#     ensure => file,
#     tag    => 'icinga2::config::file',
#     source => "puppet:///modules/profiles/private_keys/${::fqdn}.key",
#   }
#   ...
#
# @example If you like to manage the certificates and the key as strings in base64 encoded format:
#   class { 'icinga2::feature::api':
#     pki         => 'none',
#     ssl_cacert  => '-----BEGIN CERTIFICATE----- ...',
#     ssl_key     => '-----BEGIN RSA PRIVATE KEY----- ...',
#     ssl_cert    => '-----BEGIN CERTIFICATE----- ...',
#   }
#
# @example Fine tune TLS settings
#   class { 'icinga2::feature::api':
#     ssl_protocolmin => 'TLSv1.2',
#     ssl_cipher_list => 'HIGH:MEDIUM:!aNULL:!MD5:!RC4',
#   }
#
# @example Transfer a CA certificate and key from an existing CA by using the file resource:
#   include icinga2
#
#   file { '/var/lib/icinga2/ca/ca.crt':
#     source => '...',
#     tag    => 'icinga2::config::file',
#   }
#
#   file { '/var/lib/icinga2/ca/ca.key':
#     source => '...',
#     tag    => 'icinga2::config::file',
#   }
#
# @param ensure
#   Set to present enables the feature api, absent disabled it.
#
# @param pki
#   Provides multiple sources for the certificate, key and ca.
#   - puppet: Copies the key, cert and CAcert from the Puppet ssl directory to the cert directory
#             /var/lib/icinga2/certs on Linux and C:/ProgramData/icinga2/var/lib/icinga2/certs on Windows.
#             Please note that Puppet 7 uses an intermediate CA by default and Icinga cannot handle
#             its CA certificate, see [Icinga Issue](https://github.com/Icinga/icinga2/pull/8859).
#   - icinga2: Uses the icinga2 CLI to generate a Certificate Request and Key to obtain a signed
#              Certificate from 'ca_host' using the icinga2 ticket mechanism.
#              In case the 'ticket_salt' has been configured the ticket_id will be generated
#              by the module in a custom function that imitates the icinga ticket generation.
#              The 'ticket_id' parameter can be used to directly set an ticket_id.
#   - none: Does nothing and you either have to manage the files yourself as file resources
#           or use the ssl_key, ssl_cert, ssl_cacert parameters.
#
# @param ssl_key
#   The private key in a base64 encoded string to store in cert directory. This parameter
#   requires pki to be set to 'none'.
#
# @param ssl_cert
#   The certificate in a base64 encoded string to store in cert directory This parameter
#    requires pki to be set to 'none'.
#
# @param ssl_cacert
#   The CA root certificate in a base64 encoded string to store in cert directory. This parameter
#   requires pki to be set to 'none'.
#
# @param ssl_crl
#   Optional location of the certificate revocation list.
#
# @param accept_config
#   Accept zone configuration.
#
# @param accept_commands
#   Accept remote commands.
#
# @param max_anonymous_clients
#   Limit the number of anonymous client connections (not configured endpoints and signing requests).
#
# @param ca_host
#   This host will be connected to request the certificate. Set this if you use the icinga2 pki.
#
# @param ca_port
#   Port of the 'ca_host'.
#
# @param fingerprint
#   Fingerprint of the CA host certificate for validation. Requires pki is set to `icinga2`.
#   You can get the fingerprint via 'openssl x509 -noout -fingerprint -sha256 -inform pem -in [certificate-file.crt]'
#   on your CA host. (Icinga2 versions before 2.12.0 require '-sha1' as digest algorithm.)
#
# @param ticket_salt
#   Salt to use for ticket generation. The salt is stored to api.conf if none or ca is chosen for pki.
#   Defaults to constant TicketSalt. Keep in mind this parameter is parsed so please use only alpha numric
#   characters as salt or a constant.
#
# @param ticket_id
#   If a ticket_id is given it will be used instead of generating an ticket_id.
#   The ticket_id will be used only when requesting a certificate from the ca_host
#   in case the pki is set to 'icinga2'.
#
# @param endpoints
#   Hash to configure endpoint objects. `NodeName` is a icnga2 constant.
#
# @param zones
#   Hash to configure zone objects. `ZoneName` and `NodeName` are icinga2 constants.
#
# @param ssl_protocolmin
#   Minimal TLS version to require.
#
# @param ssl_handshake_timeout
#   TLS Handshake timeout.
#
# @param connect_timeout
#   Timeout for establishing new connections.
#
# @param ssl_cipher_list
#   List of allowed TLS ciphers, to finetune encryption.
#
# @param bind_host
#   The IP address the api listener will be bound to.
#
# @param bind_port
#   The port the api listener will be bound to.
#
# @param access_control_allow_origin
#  Specifies an array of origin URLs that may access the API.
#
# @param access_control_allow_credentials
#  Indicates whether or not the actual request can be made using credentials.
#
# @param access_control_allow_headers
#  Used in response to a preflight request to indicate which HTTP headers can be used when making the actual request.
#
# @param access_control_allow_methods
#  Used in response to a preflight request to indicate which HTTP methods can be used when making the actual request.
#
# @param environment
#  Used as suffix in TLS SNI extension name; default from constant ApiEnvironment, which is empty.
#
class icinga2::feature::api (
  Enum['absent', 'present']                                $ensure                           = present,
  Enum['ca', 'icinga2', 'none', 'puppet']                  $pki                              = 'icinga2',
  Optional[Stdlib::Absolutepath]                           $ssl_crl                          = undef,
  Optional[Boolean]                                        $accept_config                    = undef,
  Optional[Boolean]                                        $accept_commands                  = undef,
  Optional[Integer[0]]                                     $max_anonymous_clients            = undef,
  Optional[Stdlib::Host]                                   $ca_host                          = undef,
  Stdlib::Port                                             $ca_port                          = 5665,
  Icinga::Secret                                           $ticket_salt                      = 'TicketSalt',
  Optional[Icinga::Secret]                                 $ticket_id                        = undef,
  Hash[String[1], Hash]                                    $endpoints                        = { 'NodeName' => {} },
  Hash[String[1], Hash]                                    $zones                            = { 'ZoneName' => { endpoints => ['NodeName'] } },
  Optional[Icinga::Secret]                                 $ssl_key                          = undef,
  Optional[String[1]]                                      $ssl_cert                         = undef,
  Optional[String[1]]                                      $ssl_cacert                       = undef,
  Optional[Enum['TLSv1', 'TLSv1.1', 'TLSv1.2', 'TLSv1.3']] $ssl_protocolmin                  = undef,
  Optional[Icinga2::Interval]                              $ssl_handshake_timeout            = undef,
  Optional[Icinga2::Interval]                              $connect_timeout                  = undef,
  Optional[String[1]]                                      $ssl_cipher_list                  = undef,
  Optional[Stdlib::Host]                                   $bind_host                        = undef,
  Optional[Stdlib::Port]                                   $bind_port                        = undef,
  Optional[Array[Enum['GET', 'POST', 'PUT', 'DELETE']]]    $access_control_allow_methods     = undef,
  Optional[Array[String[1]]]                               $access_control_allow_origin      = undef,
  Optional[Boolean]                                        $access_control_allow_credentials = undef,
  Optional[String[1]]                                      $access_control_allow_headers     = undef,
  Optional[Icinga2::Fingerprint]                           $fingerprint                      = undef,
  Optional[String[1]]                                      $environment                      = undef,
) {
  if ! defined(Class['icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  # cert directory must exists and icinga binary is required for icinga2 pki
  require icinga2::install

  $icinga2_bin    = $icinga2::globals::icinga2_bin
  $manage_selinux = $icinga2::_selinux
  $conf_dir       = $icinga2::globals::conf_dir
  $cert_dir       = $icinga2::globals::cert_dir
  $ca_dir         = $icinga2::globals::ca_dir
  $user           = $icinga2::globals::user
  $group          = $icinga2::globals::group
  $node_name      = $icinga2::_constants['NodeName']
  $_ssl_key_mode  = $facts['os']['family'] ? {
    'windows' => undef,
    default   => '0600',
  }
  $_notify        = $ensure ? {
    'present' => Class['icinga2::service'],
    default   => undef,
  }

  File {
    owner   => $user,
    group   => $group,
    seltype => 'icinga2_var_lib_t',
  }

  # Set defaults for certificate stuff
  $_ssl_key_path    = "${cert_dir}/${node_name}.key"
  $_ssl_cert_path   = "${cert_dir}/${node_name}.crt"
  $_ssl_csr_path    = "${cert_dir}/${node_name}.csr"
  $_ssl_cacert_path = "${cert_dir}/ca.crt"

  # handle the certificate's stuff
  case $pki {
    'puppet': {
      $_ticket_salt = undef

      file { $_ssl_key_path:
        ensure    => file,
        mode      => $_ssl_key_mode,
        source    => $facts['icinga2_puppet_hostprivkey'],
        tag       => 'icinga2::config::file',
        show_diff => false,
        backup    => false,
      }

      file { $_ssl_cert_path:
        ensure => file,
        source => $facts['icinga2_puppet_hostcert'],
        tag    => 'icinga2::config::file',
      }

      file { $_ssl_cacert_path:
        ensure => file,
        source => $facts['icinga2_puppet_localcacert'],
        tag    => 'icinga2::config::file',
      }
    } # puppet

    'none': {
      # non means you manage the CA on your own and so
      # the salt has to be stored in api.conf
      $_ticket_salt = if $ticket_salt =~ Sensitive {
        $ticket_salt
      } else {
        Sensitive($ticket_salt)
      }

      if $ssl_key {
        file { $_ssl_key_path:
          ensure    => file,
          mode      => $_ssl_key_mode,
          content   => icinga::newline($ssl_key),
          tag       => 'icinga2::config::file',
          show_diff => false,
          backup    => false,
        }
      }

      if $ssl_cert {
        file { $_ssl_cert_path:
          ensure  => file,
          content => icinga::newline($ssl_cert),
          tag     => 'icinga2::config::file',
        }
      }

      if $ssl_cacert {
        file { $_ssl_cacert_path:
          ensure  => file,
          content => icinga::newline($ssl_cacert),
          tag     => 'icinga2::config::file',
        }
      }
    } # none

    # icinga2 as default
    default: {
      $_ticket_salt = undef
      $trusted_cert = "${cert_dir}/trusted-cert.crt"

      $cmd_pki_get_cert = "\"${icinga2_bin}\" pki save-cert --host ${ca_host} --port ${ca_port} --key ${_ssl_key_path} --cert ${_ssl_cert_path} --trustedcert ${trusted_cert}"

      if($ticket_id) {
        $_ticket = if $ticket_id =~ Sensitive {
          "--ticket ${ticket_id.unwrap}"
        } else {
          "--ticket ${ticket_id}"
        }
      } elsif($ticket_salt != 'TicketSalt') {
        $_ticket = "--ticket ${icinga2::icinga2_ticket_id($node_name, $ticket_salt)}"
      } else {
        $_ticket = ''
      }
      if $fingerprint {
        $_fingerprint = upcase(regsubst($fingerprint, ':', ' ', 'G'))
        if $facts['os']['family'] != 'Windows' {
          $_cmd_pki_get_cert = "${cmd_pki_get_cert} |grep '${_fingerprint}\s*$'"
        } else {
          $_cmd_pki_get_cert = "cmd.exe /c \"${cmd_pki_get_cert} |findstr /R /C:\"${_fingerprint}\"\""
        }
      } else {
        $_cmd_pki_get_cert = $cmd_pki_get_cert
      }

      $_env = $facts['kernel'] ? {
        'windows' => undef,
        default   => ["ICINGA2_USER=${user}", "ICINGA2_GROUP=${group}"],
      }

      Exec {
        environment => $_env,
        notify      => Class['icinga2::service'],
      }

      exec { 'icinga2 pki create key':
        command => "\"${icinga2_bin}\" pki new-cert --cn ${node_name} --key ${_ssl_key_path} --cert ${_ssl_cert_path}",
        creates => $_ssl_key_path,
      }

      -> exec { 'icinga2 pki get trusted-cert':
        path    => $facts['path'],
        command => $_cmd_pki_get_cert,
        creates => $trusted_cert,
      }

      -> exec { 'icinga2 pki request':
        command => "\"${icinga2_bin}\" pki request --host ${ca_host} --port ${ca_port} --ca ${_ssl_cacert_path} --key ${_ssl_key_path} --cert ${_ssl_cert_path} --trustedcert ${trusted_cert} ${_ticket}", # lint:ignore:140chars
        creates => $_ssl_cacert_path,
      }
    } # icinga2
  } # case pki

  # compose attributes
  $attrs = {
    'crl_path'                         => $ssl_crl,
    'accept_commands'                  => $accept_commands,
    'accept_config'                    => $accept_config,
    'max_anonymous_clients'            => $max_anonymous_clients,
    'ticket_salt'                      => $_ticket_salt,
    'tls_protocolmin'                  => $ssl_protocolmin,
    'tls_handshake_timeout'            => $ssl_handshake_timeout,
    'connect_timeout'                  => $connect_timeout,
    'cipher_list'                      => $ssl_cipher_list,
    'bind_host'                        => $bind_host,
    'bind_port'                        => $bind_port,
    'access_control_allow_origin'      => $access_control_allow_origin,
    'access_control_allow_credentials' => $access_control_allow_credentials,
    'access_control_allow_headers'     => $access_control_allow_headers,
    'access_control_allow_methods'     => $access_control_allow_methods,
    'environment'                      => $environment,
  }

  # create endpoints and zones
  create_resources('icinga2::object::endpoint', $endpoints)
  create_resources('icinga2::object::zone', $zones)

  if $manage_selinux and $bind_port {
    # if port is free
    exec { "Add port ${bind_port} for icinga2_port_t":
      command => ['/usr/sbin/semanage', 'port', '-a', '-t', 'icinga2_port_t', '-p', 'tcp', $bind_port],
      unless  => "/usr/sbin/semanage port -l | grep -qw '\\s${bind_port}'",
      before  => Icinga2::Object['icinga2::object::ApiListener::api'],
    }

    # if port is also used by another app
    exec { "Add available port ${bind_port} also for icinga2_port_t":
      command => ['/usr/sbin/semanage', 'port', '-m', '-t', 'icinga2_port_t', '-p', 'tcp', $bind_port],
      onlyif  => "/usr/sbin/semanage port -l | grep -wv '^icinga2_port_t' | grep -wq '\s${bind_port}'",
      before  => Icinga2::Object['icinga2::object::ApiListener::api'],
    }
  }

  # create object
  icinga2::object { 'icinga2::object::ApiListener::api':
    object_name => 'api',
    object_type => 'ApiListener',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/api.conf",
    order       => 10,
    notify      => $_notify,
  }

  # manage feature
  icinga2::feature { 'api':
    ensure => $ensure,
  }
}
