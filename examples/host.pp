include icinga2

icinga2::object::host { 'linux-host2':
  target             => '/etc/icinga2/conf.d/hosts2.conf',
  template           => true,
  check_command      => 'hostalive',
  max_check_attempts => 3,
  check_interval     => '1m',
  retry_interval     => '30s',

  vars => {
    os => 'Linux',
  },
}

icinga2::object::host { 'host.example.org':
  target  => '/etc/icinga2/conf.d/hosts2.conf',
  import  => [ 'linux-host2' ],
  vars    => {
    vhosts => {
      icinga2 => {
	http_url => '/icinga',
      },
    },
  },
  address => '127.0.0.1',
}
