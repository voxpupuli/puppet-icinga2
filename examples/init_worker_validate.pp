$server_cert = 'server.localdomain'
$server_ip   = '192.168.5.23'

# get it on CA host 'openssl x509 -noout -fingerprint -sha256 -inform pem -in /var/lib/icinga2/certs/server.localdomain.crt'
$fingerprint = 'D8:98:82:1B:14:8A:6A:89:4B:7A:40:32:50:68:01:D8:98:82:1B:14:8A:6A:89:4B:7A:40:32:99:3D:96:72:72'

class { '::icinga2':
  manage_repos => true,
  constants    => {
    'NodeName' => 'worker.localdomain',
  },
}

class { '::icinga2::feature::api':
  pki             => 'icinga2',
  ca_host         => $server_ip,
  ticket_salt     => '5a3d695b8aef8f18452fc494593056a4',
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
  },
  fingerprint     => $fingerprint,
}
