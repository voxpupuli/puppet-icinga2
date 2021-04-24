include ::icinga2::repo

package { ['icinga2', 'icinga2-ido-mysql']:
  ensure => latest,
  notify => Class['icinga2'],
}

class { 'icinga2':
  manage_packages => false,
}

include icinga2::feature::idomysql
