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
#   Choose the source of certificates and key. Valid parameters are 'puppet' or 'none'.
#   'puppet' copies key, cert and CAcert from the Puppet ssl directory to the pki directory
#   /etc/icinga2/pki on Linux or C:/ProgramData/icinga2/etc/icinga2/pki on Windows.
#   'none' does nothing and you've to manage the files on your own as file resources
#   or you use ssl_key, ssl_cert, ssl_ca parameters. Default to puppet.
#
# [*ssl_key_path*]
#
# [*ssl_cert_path*]
#
# [*ssl_ca_path*]
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
#   Accept zone configuration. Default to false.
#
# [*accept_commands*]
#   Accept remote commands. Default to false.
#
# === Variables
#
# [*node_name*]
#   Certname and Keyname based on constant NodeName.
#
# [*_ssl_key_path*]
#
# [*_ssl_cert_path*]
#
# [*_ssl_ca_path*]
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
