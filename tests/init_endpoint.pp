class { 'icinga2':
  manage_repo => true,
}

icinga2::object::endpoint { 'test':
  host => 'NodeName',
  port => '5665',
  log_duration => '1.5h',
}
