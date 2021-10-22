class { 'icinga2':
  manage_repos => true,
}

class{ 'icinga2::feature::influxdb2':
  ensure       => present,
  organization => 'ICINGA',
  bucket       => 'icinga2',
#  auth_token   => 'super(secret',
  auth_token   => Sensitive('super(secret'),
}
