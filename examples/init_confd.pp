class { 'icinga2':
  confd       => '/etc/icinga2/local.d',
}

file { '/etc/icinga2/local.d':
  ensure => directory,
  tag    => 'icinga2::config::file',
}
