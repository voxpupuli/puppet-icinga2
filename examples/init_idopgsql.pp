case $::osfamily {
  'redhat': {
    package { 'epel-release': }
  } # RedHat
}

include ::postgresql::server

postgresql::server::db { 'icinga2':
  user     => 'icinga2',
  password => postgresql_password('icinga2', 'supersecret'),
}

class{ 'icinga2':
  manage_repo => true,
}

class{ 'icinga2::feature::idopgsql':
  user          => "icinga2",
  password      => "supersecret",
  database      => "icinga2",
  import_schema => true,
  require       => Postgresql::Server::Db['icinga2'],
}
