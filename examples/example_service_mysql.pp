# Example service MySQL
#
# == Service: mysql
#
# [*mysql_hostname*]
#   If set to an external address, the agent will check an external database.  Usefull to check
#   connectivity between two replications.
#
# == Service: mysql_health
#
# [*command_endpoint*]
#   If set to name, the check source will be the agent itself.  This means the agent needs to be
#   hosting the database itself.
#
# [*mysql_health_name*]
#   It is best to contain the query within single quotes ('') followed by a hypend (-) and colon (:).
#   Then contain the query as normal within double quotes ("") and escape (\) anything that would break the string.
#
#   Example:
#   mysql_health_name => '-:"SELECT COUNT(*) FROM t1;"'
#
class { '::icinga2':
  manage_repos => true,
  confd        => 'example.d',
}

file { '/etc/icinga2/example.d':
  ensure  => directory,
  tag     => 'icinga2::config::file',
  purge   => true,
  recurse => true,
}

#
# MySQL
#
class { '::mysql::server':
  root_password           => 'secret',
  remove_default_accounts => true,
}

mysql::db { 'icinga2':
  user     => 'icinga2',
  password => 'icinga2',
  host     => 'localhost',
  grant    => [
    'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP',
    'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER'
  ],
}

#
# Hosts
#
::icinga2::object::host { 'generic-host':
  template           => true,
  target             => '/etc/icinga2/example.d/templates.conf',
  check_interval     => '1m',
  retry_interval     => '30s',
  max_check_attempts => 3,
  check_command      => 'hostalive',
}

::icinga2::object::host { 'NodeName':
  target   => '/etc/icinga2/example.d/hosts.conf',
  import   => ['generic-host'],
  address  => '127.0.0.1',
  address6 => '::1',
  vars     => {
    client_endpoint => name,
    mysql           => {
      db_connection => {
        mysql_hostname => 'localhost',
        mysql_username => 'icinga2',
        mysql_password => 'icinga2',
      },
    },
    mysql_health    => {
      db_size => {
        mysql_health_mode     => 'sql',
        mysql_health_name     => '-:"SELECT SUM(date_length + index_length) / 1024 / 1024 AS \'db size\' FROM information_schema.tables WHERE table_schema = \'+ db_name +\';"',
        mysql_health_name2    => 'db_size',
        mysql_health_units    => 'MB',
        mysql_health_username => 'icinga2',
        mysql_health_password => 'icinga2',
      },
    },
  },
}

#
# Services
#
::icinga2::object::service { 'generic-service':
  template           => true,
  target             => '/etc/icinga2/example.d/templates.conf',
  check_interval     => '1m',
  retry_interval     => '30s',
  max_check_attempts => 5,
}

::icinga2::object::service { 'mysql':
  target        => '/etc/icinga2/example.d/services.conf',
  apply         => 'mysql => config in host.vars.mysql',
  import        => ['generic-service'],
  check_command => '-:"mysql"',
  assign        => ['host.vars.mysql'],
  vars          => 'vars + config',
}

::icinga2::object::service { 'mysql_health':
  target        => '/etc/icinga2/example.d/services.conf',
  apply         => 'mysql_health => config in host.vars.mysql_health',
  import        => ['generic-service'],
  check_command => '-:"mysql_health"',
  assign        => ['host.vars.mysql_health'],
  vars          => 'vars + config',
}
