class { 'icinga2':
  manage_repo => true,
}

class { '::icinga2::feature::syslog':
  severity => 'critical',
  facility => 'LOG_LOCAL7',
}
