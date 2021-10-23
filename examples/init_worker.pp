$server_cert = 'server.localdomain'
$server_ip   = '192.168.5.23'

class { '::icinga2':
  manage_repos => true,
  constants    => {
    'NodeName' => 'worker.localdomain',
  },
}

class { '::icinga2::feature::api':
  pki             => 'icinga2',
  ca_host         => $server_ip,
  ticket_salt     => Sensitive('5a3d695b8aef8f18452fc494593056a4'),
  accept_config   => true,
  accept_commands => true,
  endpoints       => {
    'NodeName'       => {},
    "${server_cert}" => {
      'host' => $server_ip,
    }
  },
  zones           => {
    'ZoneName' => {
      'endpoints' => [ 'NodeName' ],
      'parent'    => 'main',
    },
    'main'     => {
      'endpoints' => [ $server_cert ],
    },
  }
}
