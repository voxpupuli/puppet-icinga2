case $::osfamily {
  'redhat': {
    package { 'epel-release': }
  } # RedHat
}

case $::osfamily {
  'redhat': {
    package { 'epel-release': }
  } # RedHat
}

class { 'icinga2':
  manage_repo => true,
}
