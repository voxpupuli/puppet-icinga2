class { 'icinga2':
  manage_repo => true,
  confd       => '/etc/icinga/local.d',
}

file { '/etc/icinga2/conf.d/local.d':
  ensure => directory,
}
