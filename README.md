#puppet-icinga2
- - -

This module installs and configures the [Icinga 2 monitoring system](https://www.icinga.org/icinga2/). It can also install and configure [NRPE](http://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE--2D-Nagios-Remote-Plugin-Executor/details) on client systems that are being monitored by an Icinga 2 server. 

The module has only been tested on CentOS 6.5 and Ubuntu 12.04 and 14.04. Red Hat and other EL derivatives, like Fedora, should work, but have not been tested.

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
	db_password => 'password'
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
	db_password => hiera('icinga_db_password_key_here')
  }
</pre>

####Client usage

Coming soon...