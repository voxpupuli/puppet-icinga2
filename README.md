#puppet-icinga2
- - -

This module installs and configures the [Icinga 2 monitoring system](https://www.icinga.org/icinga2/). It can also install and configure [NRPE](http://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE--2D-Nagios-Remote-Plugin-Executor/details) on client systems that are being monitored by an Icinga 2 server. 

The module has only been tested on [CentOS 6.5](http://www.centos.org/download/) and Ubuntu [12.04](http://releases.ubuntu.com/12.04/) and [14.04](http://releases.ubuntu.com/14.04/). Red Hat and other EL derivatives, like Fedora, should work, but have not been tested.

Currently, this module does not install or configure any web UIs for Icinga 2. This module also does not install or configure a mail transfer agent (MTA) to send outgoing alert emails.

While NRPE is required for Icinga 2 to check non-network-reachble things on client machines (CPU, load average, etc.), this module itself doesn't have any dependencies between the server component (the `icinga2::server` class) and client component (the `icinga2::nrpe` class). Either one can be used independently of the other.

###Requirements

For Ubuntu systems, this module requires the [Puppet Labs apt module](https://github.com/puppetlabs/puppetlabs-apt).

On EL-based systems (CentOS, Red Hat Enterprise Linux, Fedora, etc.), the [EPEL package repository](https://fedoraproject.org/wiki/EPEL) is required.

####Server requirements

Icinga 2 requires either a [MySQL](http://www.mysql.com/) or a [Postgres](http://www.postgresql.org/) database.

Currently, this module does not set up any databases. You'll have to create one before installing Icinga 2 via the module.

If you would like to set up your own database, either of the Puppet Labs [MySQL](https://github.com/puppetlabs/puppetlabs-mysql) or [Postgres](https://github.com/puppetlabs/puppetlabs-postgresql) modules can be used. 

Database connection parameters can be specified by the `db_host`, `db_port`, `db_name`, `db_user` and `db_password` parameters.

The example below shows the [Puppet Labs Postgres module](https://github.com/puppetlabs/puppetlabs-postgresql) being used to install Postgres and create a database and database user for Icinga 2:

<pre>
  class { 'postgresql::server': }

  postgresql::server::db { 'icinga2_data':
    user     => 'icinga2',
    password => postgresql_password('icinga2', 'password'),
  }
</pre>

For production use, you'll probably want to get the database password via a [Hiera lookup](http://docs.puppetlabs.com/hiera/1/puppet.html) so the password isn't sitting in your site manifests in plain text.

To configure Icinga with the password you set up for the Postgres Icinga user, use the `server_db_password` parameter (shown here with a Hiera lookup):

<pre>
  class { 'icinga2::server':
    server_db_password => hiera('icinga_db_password_key_here')
  }
</pre>

###Usage

####Server usage

To install Icinga 2 with a Postgres database, first set up the database.

Once the database is set up, use the `icinga2::server` class with the database connection parameters to specify 

<pre>
#Install Icinga 2:
class { 'icinga2::server': 
  server_db_type => 'pgsql',
  db_host => 'localhost'
  db_port => '5432'
  db_name => 'icinga2_data'
  db_user => 'icinga2'
  db_password => 'password',
}
</pre>

When the `server_db_type` parameter is set, the right IDO database connection packages are automatically installed and the schema is loaded.

**Note:** For production use, you'll probably want to get the database password via a [Hiera lookup](http://docs.puppetlabs.com/hiera/1/puppet.html) so the password isn't sitting in your site manifests in plain text:

<pre>
#Install Icinga 2:
class { 'icinga2::server': 
  server_db_type => 'pgsql',
  db_host => 'localhost'
  db_port => '5432'
  db_name => 'icinga2_data'
  db_user => 'icinga2'
  db_password => hiera('icinga_db_password_key_here'),
}
</pre>

**Note:** If you will be installing NRPE or the Nagios plugins packages with the `icinga2::nrpe` class on a node that also has the `icinga2::server` class applied, be sure to set the `$server_install_nagios_plugins` parameter in your call to `icinga2::server` to `false`:

<pre>
#Install Icinga 2:
class { 'icinga2::server': 
  ...
  server_install_nagios_plugins => false,
  ...
 }
</pre>

This will stop the `icinga2::server` class from trying to install the plugins pacakges, since the `icinga2::nrpe` class will already be installing them and will prevent a resulting duplicate resource error.


####Client usage

To install NRPE and allow the local machine and Icinga 2 servers (or Icinga 1 or plain old Nagios servers) with various IP addresess to connect:

<pre>
class { 'icinga2::nrpe':
  nrpe_allowed_hosts => ['10.0.1.79', '10.0.1.80', '10.0.1.85', '127.0.0.1'],
}
</pre>

**Note:** If you would like to install NRPE on a node that also has the `icinga2::server` class applied, be sure to set the `$server_install_nagios_plugins` parameter in your call to `icinga2::server` to `false`:

<pre>
#Install Icinga 2:
class { 'icinga2::server': 
  server_db_type => 'pgsql',
  server_install_nagios_plugins => false,
 }
</pre>

This will stop the `icinga2::server` class from trying to install the plugins pacakges, since the `icinga2::nrpe` class will already be installing them and will prevent a resulting duplicate resource error.

####Object type usage

#####`icinga2::object::host`

Coming soon...