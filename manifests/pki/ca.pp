# == Class: icinga2::pki::ca
#
# This class provides multiple ways to create the CA used by Icinga 2. By default it will create
# a CA by using the icinga2 CLI. If you want to use your own CA you will either have to transfer
# it by using a file resource or you can set the content of your certificat and key in this class.
#
# === Parameters
#
# [*ca_cert*]
#   Content of the CA certificate. If this is unset, a certificate will be generated with the 
#   Icinga 2 CLI.
#
# [*ca_key*]
#   Content of the CA key. If this is unset, a key will be generated with the Icinga 2 CLI.
#
# === Examples
#
# Let Icinga 2 generate a CA for you:
#
# include icinga2
# class { 'icinga2::pki::ca': }
#
# Set the content of CA certificate and key:
#
# include icinga2
# class { 'icinga2::pki::ca':
#   ca_cert => '-----BEGIN CERTIFICATE----- ...',
#   ca_key  => '-----BEGIN RSA PRIVATE KEY----- ...',
# }
#
#
class icinga2::pki::ca(
  $ssl_key_path    = undef,
  $ssl_cert_path   = undef,
  $ssl_cacert_path = undef,
  $ca_cert         = undef,
  $ca_key          = undef,
) {

  include icinga2::params

  $ca_dir    = $::icinga2::params::ca_dir
  $user      = $::icinga2::params::user
  $group     = $::icinga2::params::group
 
  File {
    owner => $user,
    group => $group,
  }

  if !$ca_cert or !$ca_key {
    $path = $::osfamily ? {
      'windows' => 'C:/ProgramFiles/ICINGA2/sbin',
      default   => '/bin:/usr/bin:/sbin:/usr/sbin',
    }

    exec { 'create-icinga2-ca':
      path    => $path,
      command => 'icinga2 pki new-ca',
      creates => "${ca_dir}/ca.crt",
      notify  => Class['::icinga2::service'],
    } 
  } else {
    validate_string($ca_cert)
    validate_string($ca_key)

    file { $ca_dir:
      ensure => directory,
      mode   => $::kernel ? {
        'windows' => undef,
        default   => '0700',
      }
    }

    file { "${ca_dir}/ca.crt":
      ensure  => file,
      content => $::osfamily ? {
        'windows' => regsubst($ca_cert, '\n', "\r\n", 'EMG'),
        default   => $ca_cert,
      },
      tag     => 'icinga2::config::file',
    }

    file { "${ca_dir}/ca.key":
      ensure  => file,
      mode    => $::kernel ? {
        'windows' => undef,
        default   => '0600',
      },
      content => $::osfamily ? {
        'windows' => regsubst($ca_key, '\n', "\r\n", 'EMG'),
        default   => $ca_key,
      },
      tag     => 'icinga2::config::file',
    }
  }

  
}
