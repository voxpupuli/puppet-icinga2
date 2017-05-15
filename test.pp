include ::icinga2

concat { '/etc/icinga2/conf.d/my_hosts.conf':
  ensure => present,
}

concat::fragment { 'host':
  target => '/etc/icinga2/conf.d/my_hosts.conf',
  content => 'object Host "test" {
  include "generic-host"
  address = "127.0.0.1"
}"',
}
