include icinga2

class { '::icinga2::feature::syslog':
  severity => 'critical',
  facility => 'LOG_LOCAL7',
}
