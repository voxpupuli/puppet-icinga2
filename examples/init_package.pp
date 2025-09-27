include icinga2::repo

package { 'icinga2':
  ensure => '2.15.1',
  notify => Class['icinga2'],
}

class { 'icinga2':
  manage_packages => false,
}
