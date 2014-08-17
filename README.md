#puppet-icinga2
- - -

This module installs and configures the [Icinga 2 monitoring system](https://www.icinga.org/icinga2/). It can also install and configure [NRPE](http://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE--2D-Nagios-Remote-Plugin-Executor/details) on client systems that are being monitored by an Icinga 2 server. 

The module has only been tested on [CentOS 6.5](http://www.centos.org/download/) and Ubuntu [12.04](http://releases.ubuntu.com/12.04/) and [14.04](http://releases.ubuntu.com/14.04/). Red Hat and other EL derivatives, like Fedora, should work, but have not been tested.

Currently, this module does not install or configure any web UIs for Icinga 2. This module also does not install or configure a mail transfer agent (MTA) to send outgoing alert emails.

While NRPE is required for Icinga 2 to check non-network-reachble things on client machines (CPU, load average, etc.), this module itself doesn't have any dependencies between the server component (the `icinga2::server` class) and client component (the `icinga2::nrpe` class). Either one can be used independently of the other.

##Requirements

For Ubuntu systems, this module requires the [Puppet Labs apt module](https://github.com/puppetlabs/puppetlabs-apt).

On EL-based systems (CentOS, Red Hat Enterprise Linux, Fedora, etc.), the [EPEL package repository](https://fedoraproject.org/wiki/EPEL) is required.

###Server requirements

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

##Usage

###Server usage

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

###Client usage

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

###Object type usage

This module includes several defined types that can be used to automatically generate Icinga 2 format object definitions. They function in a similar way to [the built-in Nagios types that are included in Puppet](http://docs.puppetlabs.com/guides/exported_resources.html#exported-resources-with-nagios).

####Exported resources

Like the built-in Nagios types, they can be exported to PuppetDB as virtual resources and collected on your Icinga 2 server.

Nodes that are being monitored can have the `@@` virtual resources applied to them:

<pre>
@@icinga2::object::host { $::fqdn:
  display_name => $::fqdn,
  ipv4_address => $::ipaddress_eth0,
  groups => ['linux_servers', 'mysql_servers'],
  vars => {
    os              => 'linux',
    virtual_machine => 'true',
    distro          => $::operatingsystem,
  },
  target_dir => '/etc/icinga2/objects/hosts',
  target_file_name => "${fqdn}.conf"
}
</pre>

Then, on your Icinga 2 server, you can collect the exported virtual resources (notice the camel casing in the class name):

<pre>
#Collect all @@icinga2::object::host resources from PuppetDB that were exported by other machines:
Icinga2::Object::Host <<| |>> { }
</pre>

Unlike the built-in Nagios types, the file owner, group and mode of the automatically generated files can be controlled via the `target_file_owner`, `target_file_group` and `target_file_mode` parameters:

<pre>
@@icinga2::object::host { $::fqdn:
  display_name => $::fqdn,
  ipv4_address => $::ipaddress_eth0,
  groups => ['linux_servers', 'mysql_servers'],
  vars => {
    os              => 'linux',
    virtual_machine => 'true',
    distro          => $::operatingsystem,
  },
  target_dir        => '/etc/icinga2/objects/hosts',
  target_file_name  => "${fqdn}.conf"
  target_file_owner => 'root',
  target_file_group => 'root',
  target_file_mode  => '644'
}
</pre>

####`undef` and default object values

Most of the object parameters *in the Puppet module* are set to **undef**. 

This means that they will not be added to the rendered object definition files.

**However**, this doesn't mean that the values are undefined in Icinga 2. Icinga 2 itself has built-in default values for many object parameters and falls back to them if one isn't present in an object definition. See the docs for individual object types in [Configuring Icinga 2](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/toc#!/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2) for more info about which object parameters have what default values. 

####`icinga2::object::host`

**Note:** The `ipv6_address` parameter is set to **undef** by default. This is because `facter` can return either IPv4 or IPv6 addresses for the `ipaddress_ethX` facts. The default value for the `ipv6_address` parameter is set to **undef** and not `ipaddress_eth0` so that an IPv4 address isn't unintentionally set as the value for `address6` in the rendered host object definition.

If you would like to use an IPv6 address, make sure to set the `ipv6_address` parameter to the `ipaddress_ethX` fact that will give you the right IPv6 address for the machine:

<pre>
@@icinga2::object::host { $::fqdn:
  display_name => $::fqdn,
  ipv6_address => $::ipaddress_eth1,
....
}
</pre>

####`icinga2::object::apply_service_to_host`

The `apply_service_to_host` defined type can create `apply` objects to apply services to hosts:

<pre>
#Create an apply that checks the number of zombie processes:
icinga2::object::apply_service_to_host { 'check_zombie_procs':
  display_name => 'Zombie procs',
  check_command => 'nrpe',
  vars => {
    nrpe_command => 'check_zombie_procs',
  },
  assign_where => '"linux_servers" in host.groups',
  ignore_where => 'host.name == "localhost"',
  target_dir => '/etc/icinga2/objects/applys'
}
</pre>

This defined type has the same available parameters that the `icinga2::object::service` defined type does.

The `assign_where` and `ignore_where` parameter values are meant to be provided as strings. Since Icinga 2 requires that string literals be double-quoted, the whole string in your Puppet site manifests will have to be single-quoted (leaving the double quotes intact inside):

<pre>
assign_where => '"linux_servers" in host.groups',
</pre>

If you would like to use Puppet or Facter variables in an `assign_where` or `ignore_where` parameter's value, you'll first need to double-quote the whole value for [Puppet's variable interpolation](http://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#double-quoted-strings) to work. Then, you'll need to escape the double quotes that surround the Icinga 2 string literals inside:

<pre>
assign_where => "\"linux_servers\" in host.${facter_variable}"",
</pre>