node /(debian|rhel|ubuntu|sles|oracle)/  {
  class { '::icinga2':
    manage_repo => true,
  }  

  class { '::icinga2::pki::ca': }

  class { '::icinga2::feature::api':
    pki => 'none',
  }

  icinga2::object::apiuser { 'icinga':
    target      => '/etc/icinga2/conf.d/apiuser.conf',
    password    => 'icinga',
    permissions => [ "*" ],
  }

  package { 'curl': }
}

node /freebsd/  {
  class { '::icinga2': }

  class { '::icinga2::pki::ca': }

  class { '::icinga2::feature::api':
    pki => 'none',
  }

  icinga2::object::apiuser { 'icinga':
    target      => '/usr/local/etc/icinga2/conf.d/apiuser.conf',
    password    => 'icinga',
    permissions => [ "*" ],
  }

  package { 'curl': }
}
