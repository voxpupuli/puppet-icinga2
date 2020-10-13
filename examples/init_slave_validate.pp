$master_cert = 'master.localdomain'
$master_ip   = '192.168.5.12'

# get it on CA host 'openssl x509 -noout -fingerprint -sha256 -inform pem -in /var/lib/icinga2/certs/master.localdomain.crt'
$fingerprint = 'D8:98:82:1B:14:8A:6A:89:4B:7A:40:32:50:68:01:D8:98:82:1B:14:8A:6A:89:4B:7A:40:32:99:3D:96:72:72'

class { '::icinga2':
  manage_repos => true,
  constants    => {
    'NodeName' => 'slave.localdomain',
  },
}

class { '::icinga2::feature::api':
  pki             => 'icinga2',
  ca_host         => $master_ip,
  ticket_salt     => '5a3d695b8aef8f18452fc494593056a4',
  accept_config   => true,
  accept_commands => true,
  endpoints       => {
    'NodeName'       => {},
    "${master_cert}" => {
      'host' => $master_ip,
    }
  },
  zones           => {
    'ZoneName' => {
      'endpoints' => [ 'NodeName' ],
      'parent'    => 'master',
    },
    'master' => {
      'endpoints' => [ $master_cert ],
    },
  },
  fingerprint     => $fingerprint,
}
