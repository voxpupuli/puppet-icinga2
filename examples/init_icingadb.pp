class { 'icinga2':
  manage_repos => true,
}

include icinga2::pki::ca

class { 'icinga2::feature::api':
  pki => none,
}

class { 'icinga2::feature::icingadb':
  host       => 'db.icinga.com',
  port       => 6381,
  password   => Sensitive('supersecret'),
  enable_tls => true,
#  tls_noverify => true,
}
