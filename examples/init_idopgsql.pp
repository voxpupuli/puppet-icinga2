$password = Sensitive('super(secret')

include ::postgresql::server

postgresql::server::db { 'icinga2':
  user     => 'icinga2',
  password => postgresql::postgresql_password('icinga2', $password.unwrap),
}

class{ 'icinga2':
  manage_repos => true,
}

notice($password)

class{ 'icinga2::feature::idopgsql':
  user          => 'icinga2',
  password      => $password,
  database      => 'icinga2',
  import_schema => true,
  require       => Postgresql::Server::Db['icinga2'],
}
