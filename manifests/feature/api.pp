# == Class: icinga2::feature::api
#
# This module configures the Icinga2 feature api.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature api, absent disabled it. Defaults to present.
#
# [*pki*]
#   Provides multiple sources for the certificate, key and ca. Valid parameters are 'puppet' or 'none'.
#   'puppet' copies the key, cert and CAcert from the Puppet ssl directory to the pki directory
#   /etc/icinga2/pki on Linux and C:/ProgramData/icinga2/etc/icinga2/pki on Windows.
#   'none' does nothing and you either have to manage the files yourself as file resources
#   or use the ssl_key, ssl_cert, ssl_cacert parameters. Defaults to puppet.
#
# [*ssl_key_path*]
#   Location of the private key. Default depends on platform:
#   /etc/icinga2/pki/NodeName.key on Linux
#   C:/ProgramData/icinga2/etc/icinga2/pki/NodeName.key on Windows
#   The Value of NodeName comes from the corresponding constant.
#
# [*ssl_cert_path*]
#   Location of the certificate. Default depends on platform:
#   /etc/icinga2/pki/NodeName.crt on Linux
#   C:/ProgramData/icinga2/etc/icinga2/pki/NodeName.crt on Windows
#   The Value of NodeName comes from the corresponding constant.
#
# [*ssl_cacert_path*]
#   Location of the CA certificate. Default is:
#   /etc/icinga2/pki/ca.crt on Linux
#   C:/ProgramData/icinga2/etc/icinga2/pki/ca.crt on Windows
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
# [*accept_config*]
#   Accept zone configuration. Defaults to false.
#
# [*accept_commands*]
#   Accept remote commands. Defaults to false.
#
# [*ticket_salt*]
#   Salt to use for ticket generation. Defaults to icinga2 constant TicketSalt.
#
# [*endpoints*]
#   Hash to configure endpoint objects. Defaults to { 'NodeName' => {} }.
#   NodeName is a icnga2 constant.
#
# [*zones*]
#   Hash to configure zone objects. Defaults to { 'ZoneName' => {'endpoints' => ['NodeName']} }.
#   ZoneName and NodeName are icinga2 constants.
#
# === Variables
#
# [*node_name*]
#   Certname and Keyname based on constant NodeName.
#
# [*_ssl_key_path*]
#   Validated path to private key file.
#
# [*_ssl_cert_path*]
#   Validated path to certificate file.
#
# [*_ssl_casert_path*]
#   Validated path to root CA certificate file.
#
# === Examples
#
# Use the puppet certificates and key copy these files to the 'pki' directory
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
#     owner => 'icnga',
#     group => 'icinga',
#   }
#
#   file { "/etc/icinga2/pki/${::fqdn}.key":
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
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2::feature::api(
  $ensure          = present,
  $pki             = 'puppet',
  $ssl_key_path    = undef,
  $ssl_cert_path   = undef,
  $ssl_cacert_path = undef,
  $accept_config   = false,
  $accept_commands = false,
  $ticket_salt     = 'TicketSalt',
  $endpoints       = { 'NodeName' => {} },
  $zones           = { 'ZoneName' => { endpoints => [ 'NodeName' ] } },
  $ssl_key         = undef,
  $ssl_cert        = undef,
  $ssl_cacert      = undef,
) {

  include ::icinga2::params

  $conf_dir  = $::icinga2::params::conf_dir
  $pki_dir   = $::icinga2::params::pki_dir
  $user      = $::icinga2::params::user
  $group     = $::icinga2::params::group
  $node_name = $::icinga2::_constants['NodeName']

  File {
    owner => $user,
    group => $group,
  }

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_re($pki, [ '^puppet$', '^none$' ],
    "${pki} isn't supported. Valid values are 'puppet' and 'none'.")
  validate_bool($accept_config)
  validate_bool($accept_commands)
  validate_string($ticket_salt)
  validate_hash($endpoints)
  validate_hash($zones)

  # Set defaults for certificate stuff and/or do validation
  if $ssl_key_path {
    validate_absolute_path($ssl_key_path)
    $_ssl_key_path = $ssl_key_path }
  else {
    $_ssl_key_path = "${pki_dir}/${node_name}.key" }
  if $ssl_cert_path {
    validate_absolute_path($ssl_cert_path)
    $_ssl_cert_path = $ssl_cert_path }
  else {
    $_ssl_cert_path = "${pki_dir}/${node_name}.crt" }
  if $ssl_cacert_path {
    validate_absolute_path($ssl_cacert_path)
    $_ssl_cacert_path = $ssl_cacert_path }
  else {
    $_ssl_cacert_path = "${pki_dir}/ca.crt" }

  # handle the certificate's stuff
  case $pki {
    'puppet': {
      file { $_ssl_key_path:
        ensure => file,
        mode   => $::kernel ? {
          'windows' => undef,
          default   => '0600',
        },
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
        file { $_ssl_key_path:
          ensure => file,
          mode   => $::kernel ? {
            'windows' => undef,
            default   => '0600',
          },
          content  => $::osfamily ? {
            'windows' => regsubst($ssl_key, '\n', "\r\n", 'EMG'),
            default   => $ssl_key,
          },
          tag     => 'icinga2::config::file',
        }
      }

      if $ssl_cert {
        file { $_ssl_cert_path:
          ensure  => file,
          content  => $::osfamily ? {
            'windows' => regsubst($ssl_cert, '\n', "\r\n", 'EMG'),
            default   => $ssl_cert,
          },
          tag     => 'icinga2::config::file',
        }
      }

      if $ssl_cacert {
        file { $_ssl_cacert_path:
          ensure  => file,
          content  => $::osfamily ? {
            'windows' => regsubst($ssl_cacert, '\n', "\r\n", 'EMG'),
            default   => $ssl_cacert,
          },
          tag     => 'icinga2::config::file',
        }
      }
    } # none
  } # pki

  # compose attributes
  $attrs = {
    cert_path       => $_ssl_cert_path,
    key_path        => $_ssl_key_path,
    ca_path         => $_ssl_cacert_path,
    accept_commands => $accept_commands,
    accept_config   => $accept_config,
    ticket_salt     => $ticket_salt,
  }

  # create endpoints and zones
  create_resources('icinga2::object::endpoint', $endpoints)
  create_resources('icinga2::object::zone', $zones)

  # create object
  icinga2::object { "icinga2::object::ApiListener::api":
    object_name => 'api',
    object_type => 'ApiListener',
    attrs       => $attrs,
    target      => "${conf_dir}/features-available/api.conf",
    order       => '10',
    notify      => $ensure ? {
      'present' => Class['::icinga2::service'],
      default   => undef,
    },
  }

  # manage feature
  icinga2::feature { 'api':
    ensure      => $ensure,
  }

}
