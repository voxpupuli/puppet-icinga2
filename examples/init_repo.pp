case $::facts['os']['name'] {
  'redhat', 'centos': {
    if Integer($::facts['os']['release']['major']) < 8 {
      $epel      = true
      $backports = false
    }
  } # RedHat
  'debian', 'ubuntu': {
    if $::facts['os']['distro']['codename'] in [ 'stretch', 'trusty' ] {
      $epel      = false
      $backports = true
    }
  } # Debian
}

class { '::icinga::repos':
  manage_epel         => $epel,
  configure_backports => $backports,
}

class { 'icinga2':
  manage_repo => true,
}
