# @summary
#   Choose the path of tls key, cert and ca file.
#
# @return
#    Returned hash includes all paths and the key, cert and cacert.
#
function icinga2::cert(
  String                               $name,
  Optional[Stdlib::Absolutepath]       $key_file    = undef,
  Optional[Stdlib::Absolutepath]       $cert_file   = undef,
  Optional[Stdlib::Absolutepath]       $cacert_file = undef,
  Optional[Variant[String, Sensitive]] $key         = undef,
  Optional[String]                     $cert        = undef,
  Optional[String]                     $cacert      = undef,
) >> Hash {
  # @param name
  #   The base name of certicate, key and ca file.
  #
  # @param tls_cert_path
  #   Location of the certificate.
  #
  # @param tls_cacert_path
  #   Location of the CA certificate.
  #
  # @param tls_crl_path
  #   Location of the Certicicate Revocation List.
  #
  # @param tls_key
  #   The private key in a base64 encoded string to store in spicified tls_key_path file.
  #
  # @param tls_cert
  #   The certificate in a base64 encoded string to store in spicified tls_cert_path file.
  #
  # @param tls_cacert
  #   The CA root certificate in a base64 encoded string to store in spicified tls_cacert_path file.
  #
  # @param tls_capath
  #    Trusted CA certificates in PEM format directory path.
  #
  $default_dir = $icinga2::globals::cert_dir

  $result = {
    'key'         => $key,
    'key_file'    => if $key {
      if $key_file {
        $key_file
      } else {
        "${default_dir}/${name}.key"
      }
    } else {
      $key_file
    },
    'cert'        => $cert,
    'cert_file'   => if $cert {
      if $cert_file {
        $cert_file
      } else {
        "${default_dir}/${name}.crt"
      }
    } else {
      $cert_file
    },
    'cacert'      => $cacert,
    'cacert_file' => if $cacert {
      if $cacert_file {
        $cacert_file
      } else {
        "${default_dir}/${name}_ca.crt"
      }
    } else {
      $cacert_file
    },
  }

  $result
}
