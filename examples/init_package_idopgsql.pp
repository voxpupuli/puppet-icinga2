include ::icinga2::repo

package { ['icinga2', 'icinga2-ido-pgsql']:
  ensure => latest,
  notify => Class['icinga2'],
}

class{ 'icinga2':
  manage_packages => false,
}

class{ 'icinga2::feature::idopgsql':
  host          => '127.0.0.1',
  user          => 'icinga2',
  password      => 'icinga2',
  database      => 'icinga2',
  import_schema => true,
}
