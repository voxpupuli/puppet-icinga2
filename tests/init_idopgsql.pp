class{ 'icinga2':
  manage_repo => true,
}

class{ 'icinga2::feature::idopgsql':
  host => "127.0.0.1",
  user => "icinga2",
  password => "icinga2",
  database => "icinga2",
  import_schema => true
}
