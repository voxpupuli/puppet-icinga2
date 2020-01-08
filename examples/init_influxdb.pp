case $::osfamily {
  'redhat': {
    package { 'epel-release': }
  } # RedHat
}

class { 'icinga2':
  manage_repo => true,
}

include icinga2::feature::influxdb
