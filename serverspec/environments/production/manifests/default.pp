node /(debian|rhel|ubuntu|sles)/  {
  class { 'icinga2':
    manage_repo => true,
  }
}

node /freebsd/  {
  class { 'icinga2': }
}
