class { 'icinga2':
  manage_repos => true,
}

class { '::icinga2::feature::influxdb':
  password   => Sensitive('super(secret'),
  basic_auth => {
    username => 'icinga2',
    password => Sensitive('super(secret'),
  },
}
