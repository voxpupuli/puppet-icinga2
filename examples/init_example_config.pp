class { '::icinga2':
  manage_repo => true,
  confd       => 'example.d',
}

file { '/etc/icinga2/example.d':
  ensure => directory,
  tag    => 'icinga2::config::file',
}

::icinga2::object::host { 'generic-host':
  template           => true,
  target             => '/etc/icinga2/example.d/templates.conf',
  check_interval     => '1m',
  retry_interval     => '30s',
  max_check_attempts => 3,
  check_command      => 'hostalive',
}

::icinga2::object::service { 'generic-service':
  template           => true,
  target             => '/etc/icinga2/example.d/templates.conf',
  check_interval     => '1m',
  retry_interval     => '30s',
  max_check_attempts => 5,
}

::icinga2::object::host { 'host1.example.org':
  target         => '/etc/icinga2/example.d/hosts.conf',
  import         => [ 'generic-host' ],
  address        => '127.0.0.1',
  vars           => {
    os           => 'Linux',
    http_vhosts  => {
      httpd      => {
        http_uri => '/',
      },
    },
    procs             => {
      httpd           => {
        procs_command => 'httpd',
      },
    },
  },
}

::icinga2::object::service { 'ping4':
  target        => '/etc/icinga2/example.d/services.conf',
  apply         => true,
  import        => [ 'generic-service' ],
  check_command => 'ping4',
  assign        => [ 'host.address' ],
}

::icinga2::object::service { 'ssh':
  target        => '/etc/icinga2/example.d/services.conf',
  apply         => true,
  import        => [ 'generic-service' ],
  check_command => 'ssh',
  assign        => [ '(host.address || host.address6) && host.vars.os == Linux' ],
}

::icinga2::object::service { 'http':
  target        => '/etc/icinga2/example.d/services.conf',
  apply         => 'vhost => config in host.vars.http_vhosts',
  import        => [ 'generic-service' ],
  check_command => 'http',
  vars          => 'vars + config',
}

::icinga2::object::service { 'proc-':
  target        => '/etc/icinga2/example.d/services.conf',
  apply         => 'proc => config in host.vars.procs',
  prefix        => true,
  import        => [ 'generic-service' ],
  check_command => 'procs',
  display_name  => 'proc  + proc',
  vars          => 'vars + config',
  assign        => [ 'host.vars.os == Linux' ],
}
