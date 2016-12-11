# == Define: icinga2::config::fragment
#
# Set a code fragment in a target configuration file.
#
# === Parameters
#
# [*content*]
#   Content to insert in file specified in target.
#
# [*target*]
#   Destination config file to store in this fragment. File will be declared the
#   first time.
#
# [*order*]
#   String to set the position in the target file, sorted in alpha numeric order.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
define icinga2::config::fragment(
  $code_name = $title,
  $content,
  $target,
  $order,
) {

  include ::icinga2::params
  require ::icinga2::config

  case $::osfamily {
    'windows': {
      Concat {
        owner => 'Administrators',
        group => 'NETWORK SERVICE',
        mode  => '0770',
      }
    } # windows
    default: {
      Concat {
        owner => $::icinga2::params::user,
        group => $::icinga2::params::group,
        mode  => '0640',
      }
    } # default
  }

  validate_string($content)
  validate_absolute_path($target)
  validate_string($order)

  if !defined(Concat[$target]) {
    concat { $target:
      ensure => present,
      tag    => 'icinga2::config::file',
      warn   => true,
    }
  }

  concat::fragment { "icinga2::config::${code_name}":
    target   => $target,
    content  => $::osfamily ? {
      'windows' => regsubst($content, '\n', "\r\n", 'EMG'),
      default   => $content,
    },
    order  => $order,
    notify => Class['::icinga2::serice'],
  }

}
