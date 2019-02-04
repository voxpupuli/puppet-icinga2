# == Class: icinga2::feature::api
#
# This module configures the Icinga 2 feature api.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature api, absent disabled it. Defaults to present.
#
# [*pki*]
#   Provides multiple sources for the certificate, key and ca. Valid parameters are 'puppet', 'icinga2'  or 'none'.
#   - puppet: Copies the key, cert and CAcert from the Puppet ssl directory to the cert directory
#             /var/lib/icinga2/certs on Linux and C:/ProgramData/icinga2/var/lib/icinga2/certs on Windows.
#   - icinga2: Uses the icinga2 CLI to generate a Certificate Request and Key to obtain a signed
#              Certificate from 'ca_host' using the icinga2 ticket mechanism.
#              In case the 'ticket_salt' has been configured the ticket_id will be generated
#              by the module in a custom function that imitates the icinga ticket generation.
#              The 'ticket_id' parameter can be used to directly set an ticket_id.
#   - none: Does nothing and you either have to manage the files yourself as file resources
#           or use the ssl_key, ssl_cert, ssl_cacert parameters.
#   Defaults to 'icinga2'.
#
# [*ssl_key*]
#   The private key in a base64 encoded string to store in cert directory, file is stored to
#   path specified in ssl_key_path. This parameter requires pki to be set to 'none'.
#
# [*ssl_cert*]
#   The certificate in a base64 encoded string to store in cert directory, file is  stored to
#   path specified in ssl_cert_path. This parameter requires pki to be set to 'none'.
#
# [*ssl_cacert*]
#   The CA root certificate in a base64 encoded string to store in cert directory, file is stored
#   to path specified in ssl_cacert_path. This parameter requires pki to be set to 'none'.
#
# [*ssl_crl*]
#   Optional location of the certificate revocation list.
#
# [*accept_config*]
#   Accept zone configuration. Defaults to false.
#
# [*accept_commands*]
#   Accept remote commands. Defaults to false.
#
# [*ca_host*]
#   This host will be connected to request the certificate. Set this if you use the icinga2 pki.
#
# [*ca_port*]
#   Port of the 'ca_host'. Defaults to 5665
#
# [*ticket_salt*]
#   Salt to use for ticket generation. The salt is stored to api.conf if none or ca is chosen for pki.
#   Defaults to constant TicketSalt.
#
# [*ticket_id*]
#   If a ticket_id is given it will be used instead of generating an ticket_id.
#   The ticket_id will be used only when requesting a certificate from the ca_host
#   in case the pki is set to 'icinga2'.
#
# [*endpoints*]
#   Hash to configure endpoint objects. Defaults to { 'NodeName' => {} }.
#   NodeName is a icnga2 constant.
#
# [*zones*]
#   Hash to configure zone objects. Defaults to { 'ZoneName' => {'endpoints' => ['NodeName']} }.
#   ZoneName and NodeName are icinga2 constants.
#
# [*ssl_protocolmin*]
#   Minimal TLS version to require. Default undef (e.g. "TLSv1.2")
#
# [*ssl_cipher_list*]
#   List of allowed TLS ciphers, to finetune encryption. Default undef (e.g. "HIGH:MEDIUM:!aNULL:!MD5:!RC4")
#
# [*bind_host*]
#   The IP address the api listener will be bound to. (e.g. 0.0.0.0)
#
# [*bind_port*]
#   The port the api listener will be bound to. (e.g. 5665)
#
# [*access_control_allow_origin]
#  Specifies an array of origin URLs that may access the API.
#
# [*access_control_allow_credentials]
#  Indicates whether or not the actual request can be made using credentials. Defaults to `true`.
#
# [*access_control_allow_headers]
#  Used in response to a preflight request to indicate which HTTP headers can be used when making the actual request.
#  Defaults to `Authorization`.
#
# [*access_control_allow_methods]
#  Used in response to a preflight request to indicate which HTTP methods can be used when making the actual request.
#  Defaults to `GET, POST, PUT, DELETE`.
#
# === Examples
#
# Use the puppet certificates and key copy these files to the cert directory
# named to 'hostname.key', 'hostname.crt' and 'ca.crt' if the contant NodeName
# is set to 'hostname'.
#
#   include ::icinga2::feature::api
#
# To use your own certificates and key as file resources if the contant NodeName is
# set to fqdn (default) do:
#
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
#     tag    => 'icinga2::config::file,
#     source => "puppet:///modules/profiles/private_keys/${::fqdn}.key",
#   }
#   ...
#
# If you like to manage the certificates and the key as strings in base64 encoded format:
#
#   class { 'icinga2::feature::api':
#     pki         => 'none',
#     ssl_cacert  => '-----BEGIN CERTIFICATE----- ...',
#     ssl_key     => '-----BEGIN RSA PRIVATE KEY----- ...',
#     ssl_cert    => '-----BEGIN CERTIFICATE----- ...',
#   }
#
#
class icinga2::feature::api(
  Enum['absent', 'present']                               $ensure                           = present,
  Enum['ca', 'icinga2', 'none', 'puppet']                 $pki                              = 'icinga2',
  Optional[Stdlib::Absolutepath]                          $ssl_crl                          = undef,
  Optional[Boolean]                                       $accept_config                    = undef,
  Optional[Boolean]                                       $accept_commands                  = undef,
  Optional[Stdlib::Host]                                  $ca_host                          = undef,
  Stdlib::Port::Unprivileged                              $ca_port                          = 5665,
  String                                                  $ticket_salt                      = 'TicketSalt',
  Optional[String]                                        $ticket_id                        = undef,
  Hash[String, Hash]                                      $endpoints                        = { 'NodeName' => {} },
  Hash[String, Hash]                                      $zones                            = { 'ZoneName' => { endpoints => [ 'NodeName' ] } },
  Optional[String]                                        $ssl_key                          = undef,
  Optional[String]                                        $ssl_cert                         = undef,
  Optional[String]                                        $ssl_cacert                       = undef,
  Optional[Enum['TLSv1', 'TLSv1.1', 'TLSv1.2']]           $ssl_protocolmin                  = undef,
  Optional[String]                                        $ssl_cipher_list                  = undef,
  Optional[Stdlib::Host]                                  $bind_host                        = undef,
  Optional[Stdlib::Port::Unprivileged]                    $bind_port                        = undef,
  Optional[Array[Enum['GET', 'POST', 'PUT', 'DELETE']]]   $access_control_allow_methods     = undef,
  Optional[Array[String]]                                 $access_control_allow_origin      = undef,
  Optional[Boolean]                                       $access_control_allow_credentials = undef,
  Optional[String]                                        $access_control_allow_headers     = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  # cert directory must exists and icinga binary is required for icinga2 pki
  require ::icinga2::install

  $icinga2_bin   = $::icinga2::globals::icinga2_bin
  $conf_dir      = $::icinga2::globals::conf_dir
  $cert_dir      = $::icinga2::globals::cert_dir
  $ca_dir        = $::icinga2::globals::ca_dir
  $user          = $::icinga2::globals::user
  $group         = $::icinga2::globals::group
  $node_name     = $::icinga2::_constants['NodeName']
  $_ssl_key_mode = $::osfamily ? {
    'windows' => undef,
    default   => '0600',
  }
  $_notify       = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  File {
    owner => $user,
    group => $group,
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
      # non means you manage the CA on your own and so
      # the salt has to be stored in api.conf
      $_ticket_salt = $ticket_salt

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

    'icinga2': {
      $_ticket_salt = undef
      $trusted_cert = "${cert_dir}/trusted-cert.crt"
      if($ticket_id) {
        $_ticket_id = $ticket_id
      } elsif($ticket_salt != 'TicketSalt') {
        $_ticket_id = icinga2_ticket_id($node_name, $ticket_salt)
      } else {
        fail("Parameter ticket_salt or ticket_id has be set when using pki='icinga2'")
      }

      Exec {
        notify  => Class['::icinga2::service'],
      }

      exec { 'icinga2 pki create key':
        command => "${icinga2_bin} pki new-cert --cn ${node_name} --key ${_ssl_key_path} --cert ${_ssl_cert_path}",
        creates => $_ssl_key_path,
      }

      -> exec { 'icinga2 pki get trusted-cert':
        command => "${icinga2_bin} pki save-cert --host ${ca_host} --port ${ca_port} --key ${_ssl_key_path} --cert ${_ssl_cert_path} --trustedcert ${trusted_cert}",
        creates => $trusted_cert,
      }

      -> exec { 'icinga2 pki request':
        command => "${icinga2_bin} pki request --host ${ca_host} --port ${ca_port} --ca ${_ssl_cacert_path} --key ${_ssl_key_path} --cert ${_ssl_cert_path} --trustedcert ${trusted_cert} --ticket ${_ticket_id}",
        creates => $_ssl_cacert_path,
      }
    } # icinga2
  } # case pki

  # compose attributes
  $attrs = {
    crl_path                         => $ssl_crl,
    accept_commands                  => $accept_commands,
    accept_config                    => $accept_config,
    ticket_salt                      => $_ticket_salt,
    tls_protocolmin                  => $ssl_protocolmin,
    cipher_list                      => $ssl_cipher_list,
    bind_host                        => $bind_host,
    bind_port                        => $bind_port,
    access_control_allow_origin      => $access_control_allow_origin,
    access_control_allow_credentials => $access_control_allow_credentials,
    access_control_allow_headers     => $access_control_allow_headers,
    access_control_allow_methods     => $access_control_allow_methods,
  }

  # create endpoints and zones
  create_resources('icinga2::object::endpoint', $endpoints)
  create_resources('icinga2::object::zone', $zones)

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
    ensure      => $ensure,
  }
}
