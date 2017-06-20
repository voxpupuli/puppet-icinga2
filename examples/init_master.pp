class { '::icinga2':
  manage_repo => true,
  constants   => {
    'ZoneName'   => 'master',
    'TicketSalt' => '5a3d695b8aef8f18452fc494593056a4',
  }
}

class { '::icinga2::pki::ca': }

class { '::icinga2::feature::api':
  pki             => 'none',
  zones           => {
    'master' => {
      'endpoints' => [ 'NodeName' ],
    },
  }
}
