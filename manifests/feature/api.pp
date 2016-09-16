# == Class: icinga2::feature::api
#
# This module configures the Icinga2 feature api.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature api, absent disabled it. Default is present.
#
# [*pki*]
#   Provides multiple sources for the certificate and key. Valid parameters are 'puppet' or 'none'.
#   'puppet' copies the key, cert and CAcert from the Puppet ssl directory to the pki directory
#   /etc/icinga2/pki on Linux and C:/ProgramData/icinga2/etc/icinga2/pki on Windows.
#   'none' does nothing and you either have to manage the files yourself as file resources
#   or use the ssl_key, ssl_cert, ssl_ca parameters. Default is puppet.
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
# [*ssl_ca_path*]
#   Location of the CA certificate. Default is:
#   /etc/icinga2/pki/ca.crt on Linux
#   C:/ProgramData/icinga2/etc/icinga2/pki/ca.crt on Windows
#
# [*ssl_key*] NOT IMPLEMENTED
#   The private key in a base64 encoded string to store in pki directory, file is named to the constants 'NodeName'
#   with the suffix '.key'. For use 'pki' must set to 'none'. Default to undef.
#
# [*ssl_cert*] NOT IMPLEMENTED
#   The certificate in a base64 encoded string to store in pki directory, file is named to the constants 'NodeName'
#   with the suffix '.crt'. For use 'pki' must set to 'none'. Default to undef.
#
# [*ssl_ca*] NOT IMPLEMENTED
#   The CA root certificate in a base64 encoded string to store in pki directory, file is named to 'ca.crt'.
#   For use 'pki' must set to 'none'. Default to undef.
#
# [*accept_config*]
#   Accept zone configuration. Default is false.
#
# [*accept_commands*]
#   Accept remote commands. Default is false.
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
# [*_ssl_ca_path*]
#   Validated path to root CA certificate file.
#
# === Examples
#
# Use the puppet certificates and key copy these files to the 'pki' directory
# named to 'hostname.key', 'hostname.crt' and 'ca.crt' if the contant NodeName
# is set to 'hostname'.
#
#   include icinga2::feature::api
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
#     ssl_ca_cert => '-----BEGIN CERTIFICATE----- ...',
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
  $ssl_ca_path     = undef,
  $accept_config   = false,
  $accept_commands = false,
) {

  include ::icinga2::params

  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_re($pki, [ '^puppet$', '^none$' ],
    "${pki} isn't supported. Valid values are 'puppet' and 'none'.")
  validate_bool($accept_config)
  validate_bool($accept_commands)

  $conf_dir  = $::icinga2::params::conf_dir
  $pki_dir   = $::icinga2::params::pki_dir
  $user      = $::icinga2::params::user
  $group     = $::icinga2::params::group
  $node_name = $::icinga2::_constants['NodeName']

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
  if $ssl_ca_path {
    validate_absolute_path($ssl_ca_path)
    $_ssl_ca_path = $ssl_ca_path }
  else {
    $_ssl_ca_path = "${pki_dir}/ca.crt" }

  File {
    owner   => $user,
    group   => $group,
  }

  if $pki == 'puppet' {
    file { $_ssl_key_path:
      ensure => file,
      mode   => $::kernel ? {
        'windows' => undef,
        default   => '0600',
      },
      source => $::settings::hostprivkey,
      tag    => 'icinga2::config::file',
    }

    file { $_ssl_cert_path:
      ensure => file,
      source => $::settings::hostcert,
      tag    => 'icinga2::config::file',
    }

    file { $_ssl_ca_path:
      ensure => file,
      source => $::settings::localcacert,
      tag    => 'icinga2::config::file',
    }
  }

  icinga2::feature { 'api':
    ensure => $ensure,
  }

}
