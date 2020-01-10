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

exec { 'icinga2-idopgsql-create-plpgsql':
  user    => 'postgres',
  path    => $::path,
  command => "psql icinga2 -w -c 'CREATE LANGUAGE plpgsql'",
  unless  => 'psql icinga2 -A -t -c "SELECT lanname FROM pg_catalog.pg_language" |grep plpgsql',
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
