case $::facts['os']['name'] {
  'redhat', 'centos': {
    if Integer($::facts['os']['release']['major']) < 8 {
      package { 'epel-release':
        ensure => installed,
        before => Class['icinga2'],
      }
    }
  } # RedHat
  'debian', 'ubuntu': {
    if $::facts['os']['distro']['codename'] in [ 'stretch', 'trusty' ] {
      include ::apt, ::apt::backports
    }
  } # Debian
}

class { 'icinga2':
  manage_repo => true,
}
