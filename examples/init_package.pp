include ::icinga2::repo

package { 'icinga2':
  ensure => latest,
  notify => Class['icinga2'],
}

class { '::icinga2':
  manage_packages => false,
}
