node /(debian|rhel|ubuntu|sles)/  {
  class { '::icinga2':
    constants => {
      'TicketSalt'   => '5a3d695b8aef8f18452fc494593056a4',
    }
  }

  class{ '::icinga2::feature::idomysql':
    user          => 'icinga2',
    password      => 'icinga2',
    database      => 'icinga2',
    import_schema => true,
  }
  
}

node /freebsd/  {
  class { 'icinga2': }
}
