class { '::icinga2':
  manage_repos => true,
}

class { '::icinga2::feature::icingadb':
  password => Sensitive('super(secret'),
  #password => 'super(secret',
}
