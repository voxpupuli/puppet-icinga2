class { '::icinga2':
  manage_repos => true,
  constants    => {
    'NodeName'   => 'server.localdomain',
    'ZoneName'   => 'main',
    'TicketSalt' => Sensitive('5a3d695b8aef8f18452fc494593056a4'),
  }
}

class { '::icinga2::feature::api':
  pki   => 'none',
  zones => {
    'main' => {
      'endpoints' => [ 'NodeName' ],
    },
  }
}

class { '::icinga2::pki::ca': }

