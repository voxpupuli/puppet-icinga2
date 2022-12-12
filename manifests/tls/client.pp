# @summary
#   A class to generate tls key, cert and cacert paths.
#
# @api private
#
# @param args
#   A config hash with the keys:
#   key_file, cert_file, cacert_file, key, cert and cacert
#
define icinga2::tls::client (
  Hash[String, Any] $args,
) {
  assert_private()

  $owner = $icinga2::globals::user
  $group = $icinga2::globals::group

  if $facts['os']['family'] == 'Windows' {
    $key_mode = undef
  } else {
    File {
      owner => $owner,
      group => $group,
      mode  => '0640',
    }
    $key_mode = '0400'
  }

  if $args[key] {
    file { $args['key_file']:
      ensure    => file,
      content   => icinga2::unwrap($args['key']),
      mode      => $key_mode,
      show_diff => false,
    }
  }

  if $args['cert'] {
    file { $args['cert_file']:
      ensure  => file,
      content => $args['cert'],
    }
  }

  if $args['cacert'] {
    file { $args['cacert_file']:
      ensure  => file,
      content => $args['cacert'],
    }
  }
}
