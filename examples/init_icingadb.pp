case $::facts['os']['name'] {
  'redhat', 'centos': {
    if Integer($::facts['os']['release']['major']) < 8 {
      $epel      = true
      $backports = false
    } else {
      $epel      = false
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
  manage_release      => false,
  manage_testing      => true,
  manage_epel         => $epel,
  configure_backports => $backports,
}

include ::icinga2
include ::icinga2::feature::icingadb

