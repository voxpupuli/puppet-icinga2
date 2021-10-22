$password = Sensitive('super(secret')

include ::mysql::server

mysql::db { 'icinga2':
  user     => 'icinga2',
  password => $password,
  host     => 'localhost',
  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER'],
}

class { '::icinga2':
  manage_repos => true,
}

notice($password)

class{ '::icinga2::feature::idomysql':
  user          => 'icinga2',
  password      => $password,
  database      => 'icinga2',
  import_schema => true,
  require       => Mysql::Db['icinga2'],
  cleanup       => {
    hostchecks_age    => '3m',
    servicechecks_age => '36h',
  },
}
