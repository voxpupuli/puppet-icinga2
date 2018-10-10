# == Class: icinga2::pki::ca
#
# This class provides multiple ways to create the CA used by Icinga 2. By default it will create
# a CA by using the icinga2 CLI. If you want to use your own CA you will either have to transfer
# it by using a file resource or you can set the content of your certificat and key in this class.
#
# The certificate of the icinga2 instance itself will be created, is signed by the new CA and
# has the CN based on the constant NodeName.
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
  Optional[String]               $ca_cert         = undef,
  Optional[String]               $ca_key          = undef,
) {

  $icinga2_bin = $::icinga2::globals::icinga2_bin
  $ca_dir      = $::icinga2::globals::ca_dir
  $cert_dir    = $::icinga2::globals::cert_dir
  $user        = $::icinga2::globals::user
  $group       = $::icinga2::globals::group
  $node_name   = $::icinga2::_constants['NodeName']

  $_ssl_key_path    = "${::icinga2::globals::cert_dir}/${node_name}.key"
  $_ssl_csr_path    = "${::icinga2::globals::cert_dir}/${node_name}.csr"
  $_ssl_cert_path   = "${::icinga2::globals::cert_dir}/${node_name}.crt"
  $_ssl_cacert_path = "${::icinga2::globals::cert_dir}/ca.crt"

  File {
    owner => $user,
    group => $group,
  }

  if $::osfamily != 'windows' {
    $_ca_key_mode = '0600'
  } else {
    $_ca_key_mode = undef
  }


  if !$ca_cert or !$ca_key {
    exec { 'create-icinga2-ca':
      command => "${icinga2_bin} pki new-ca",
      creates => "${ca_dir}/ca.crt",
      before  => File[$_ssl_cacert_path],
      notify  => Class['::icinga2::service'],
    }
  } else {
    if $::osfamily == 'windows' {
      $_ca_cert     = regsubst($ca_cert, '\n', "\r\n", 'EMG')
      $_ca_key      = regsubst($ca_key, '\n', "\r\n", 'EMG')
    } else {
      $_ca_cert     = $ca_cert
      $_ca_key      = $ca_key
    }

    file { "${ca_dir}/ca.crt":
      ensure  => file,
      content => $_ca_cert,
      tag     => 'icinga2::config::file',
      before  => File[$_ssl_cacert_path],
    }

    file { "${ca_dir}/ca.key":
      ensure  => file,
      mode    => $_ca_key_mode,
      content => $_ca_key,
      tag     => 'icinga2::config::file',
    }
  }

  file { $_ssl_cacert_path:
    ensure => file,
    source => $::kernel ? {
      'windows' => "file:///${ca_dir}/ca.crt",
      default   => "${ca_dir}/ca.crt",
    },
  }

  exec { 'icinga2 pki create certificate signing request':
    command => "${icinga2_bin} pki new-cert --cn ${node_name} --key ${_ssl_key_path} --csr ${_ssl_csr_path}",
    creates => $_ssl_key,
    require => File[$_ssl_cacert_path],
  }

  -> file { $_ssl_key_path:
    ensure => file,
    mode   => $_ca_key_mode,
  }

  exec { 'icinga2 pki sign certificate':
    command     => "${icinga2_bin} pki sign-csr --csr ${_ssl_csr_path} --cert ${_ssl_cert_path}",
    subscribe   => Exec['icinga2 pki create certificate signing request'],
    refreshonly => true,
    notify      => Class['::icinga2::service'],
  }

  -> file {
    $_ssl_cert_path:
      ensure => file;
    $_ssl_csr_path:
      ensure => absent;
  }
}
