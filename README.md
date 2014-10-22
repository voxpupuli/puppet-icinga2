puppet-icinga2
==========

Table of Contents
-----------------

1. [Overview - What is the Icinga 2 module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with the Icinga 2 module](#setup)
4. [Usage - How to use the module for various tasks](#usage)
    * [Object type usage](#object_type_usage)
    * [Objects](#objects)
5. [Reference - The classes and defined types available in this module](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Contributors - List of module contributors](#contributors)

[Overview](id:overview)
--------

This module installs and configures the [Icinga 2 monitoring system](https://www.icinga.org/icinga2/). It can also install and configure [NRPE](http://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE--2D-Nagios-Remote-Plugin-Executor/details) on client systems that are being monitored by an Icinga 2 server.

[Module Description](id:module-description)
-------------------

Coming soon...

[Setup](id:setup)
-----

This module should be used with Puppet 3.6 or later. It may work with earlier versions of Puppet 3 but it has not been tested.

This module requires Facter 2.2 or later, specifically because it uses the `operatingsystemmajrelease` fact.

This module requires the [Puppet Labs stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib).

For Ubuntu systems, this module requires the [Puppet Labs apt module](https://github.com/puppetlabs/puppetlabs-apt).

On EL-based systems (CentOS, Red Hat Enterprise Linux, Fedora, etc.), the [EPEL package repository](https://fedoraproject.org/wiki/EPEL) is required.

If you would like to use the `icinga2::object` defined types as [exported resources](https://docs.puppetlabs.com/guides/exported_resources.html), you'll need to have your Puppet master set up with PuppetDB. See the Puppet Labs documentation for more info: [Docs: PuppetDB](https://docs.puppetlabs.com/puppetdb/)

###Server requirements

Icinga 2 requires either a [MySQL](http://www.mysql.com/) or a [Postgres](http://www.postgresql.org/) database.

Currently, this module does not set up any databases. You'll have to create one before installing Icinga 2 via the module.

If you would like to set up your own database, either of the Puppet Labs [MySQL](https://github.com/puppetlabs/puppetlabs-mysql) or [Postgres](https://github.com/puppetlabs/puppetlabs-postgresql) modules can be used.

The example below shows the [Puppet Labs Postgres module](https://github.com/puppetlabs/puppetlabs-postgresql) being used to install Postgres and create a database and database user for Icinga 2:

<pre>
  class { 'postgresql::server': }

  postgresql::server::db { 'icinga2_data':
    user     => 'icinga2',
    password => postgresql_password('icinga2', 'password'),
  }
</pre>

For production use, you'll probably want to get the database password via a [Hiera lookup](http://docs.puppetlabs.com/hiera/1/puppet.html) so the password isn't sitting in your site manifests in plain text.

[Usage](id:usage)
-----

###General Usage

####`icinga2::conf`

This defined type creates custom files in the `/etc/icinga2/conf.d` directory.

The `icinga2::conf` type has `target_dir`, `target_file_name`, `target_file_owner`, `target_file_group` and `target_file_mode` parameters just like the `icinga2::object` types. 

The content of the file can be managed with two parameters:

* `template` is an ERB tmplate to use for the content (ie. `site/icinga2/baseservices.conf.erb`)
* `source` is the file server source URL for a static file (ie. `puppet:///modules/site/icinga2/baseservices.conf`)

To dynamically manage the variables of your template, use the `options_hash` parameter. It can be given a hash of data that is accessible in the template.

Example usage:

<pre>
icinga2::conf { 'baseservices':
  template     => 'site/icinga2/baseservices.conf.erb',
  options_hash => {
    enable_notifications => true,
    check_interval       => '5',
    groups               => [ 'all-servers' , 'linux-servers' ],
  }
}
</pre>

###Server usage

To install Icinga 2, first set up a MySQL or Postgres database.

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

You'll also need to add an IDO connection object that has the same database settings and credentials as what you entered for your `icinga2::server` class.

You can do this by applying either the `icinga2::object::idomysqlconnection` or `icinga2::object::idopgsqlconnection` class to your Icinga 2 server, depending on which database you're using.

An example `icinga2::object::idopgsqlconnection` class is below:

<pre>
icinga2::object::idopgsqlconnection { 'postgres_connection':
   target_dir => '/etc/icinga2/features-enabled',
   target_file_name => 'ido-pgsql.conf',
   host             => '127.0.0.1',
   port             => 5432,
   user             => 'icinga2',
   password         => 'password',
   database         => 'icinga2_data',
   categories => ['DbCatConfig', 'DbCatState', 'DbCatAcknowledgement', 'DbCatComment', 'DbCatDowntime', 'DbCatEventHandler' ],
}
</pre>

In a future version, the module will automatically create the IDO connection objects.

**Using the Debmon repository on Debian systems**

If you would like to use the [Debmon repository](http://debmon.org/packages) for Debian 7 systems, set `use_debmon_repo` to true when you call the `icinga2::server` class:

<pre>
class { 'icinga2::server':
  server_db_type => 'pgsql',
  # default to false
  use_debmon => true,
  db_host => 'localhost'
  db_port => '5432'
  db_name => 'icinga2_data'
  db_user => 'icinga2'
  db_password => 'password',
}
</pre>

**NRPE and Nagios plugin packages**

If you will be installing NRPE or the Nagios plugins packages with the `icinga2::nrpe` class on a node that also has the `icinga2::server` class applied, be sure to set the `$server_install_nagios_plugins` parameter in your call to `icinga2::server` to `false`:

<pre>
#Install Icinga 2:
class { 'icinga2::server':
  ...
  server_install_nagios_plugins => false,
  ...
 }
</pre>

This will stop the `icinga2::server` class from trying to install the plugins packages, since the `icinga2::nrpe` class will already be installing them and will prevent a resulting duplicate resource error.

**`mail` binaries**

If you would like to install packages to make a `mail` command binary available so that Icinga 2 can send out notifications, set the `install_mail_utils_package` parameter to **true**:

<pre>
  class { 'icinga2::server':
    ...
    install_mail_utils_package => true,
    ...
  }
</pre>

If you would like you manage enabled and disabled features for Icinga 2 you can set the `server_enabled_features` and `server_enabled_features` parameters to an array of features.

**Note: If a feature is listed in both the enabled and disabled features arrays, the feature will be disabled**

````
class { 'icinga2::server':
  ...
  server_enabled_features  => ['checker','notification'],
  server_disabled_features => ['graphite','livestatus'],
}
````

###NRPE usage

To install NRPE and allow the local machine and Icinga 2 servers (or Icinga 1 or plain old Nagios servers) with various IP addresess to connect:

<pre>
class { 'icinga2::nrpe':
  nrpe_allowed_hosts => ['10.0.1.79', '10.0.1.80', '10.0.1.85', '127.0.0.1'],
}
</pre>

By default the NRPE daemon will not allow clients to specify arguments to the commands that are executed.  To enable NRPE to allow client argument processing you can call the icinga2::nrpe class with the **allow_command_argument_processing** parameter.

Valid parameter values are: 0=do not allow arguments, 1=allow command arguments

**WARNING! - ENABLING THIS OPTION IS A SECURITY RISK!**

````
class { 'icinga2::nrpe':
  allow_command_argument_processing => 1,
}
````

**Note:** If you would like to install NRPE on a node that also has the `icinga2::server` class applied, be sure to set the `$server_install_nagios_plugins` parameter in your call to `icinga2::server` to `false`:

<pre>
#Install Icinga 2:
class { 'icinga2::server':
  server_db_type => 'pgsql',
  server_install_nagios_plugins => false,
 }
</pre>

This will stop the `icinga2::server` class from trying to install the plugins pacakges, since the `icinga2::nrpe` class will already be installing them and will prevent a resulting duplicate resource error.

### Check Plugins

Agents installed on nodes (such as NRPE ) that Icinga is performing Active checks against often require additional or custom check plugins. In order to deploy these check pluings on a node you can call the checkplugin defined resource.

The checkplugin defined resource can distribute files via both content (templates) and source (files).  By default the checkpluin resource will assume your distribution method is content (template) and that your template resides in the icinga2 module

To reference a template that resides in another module you can update the $checkplugin_template_module  parameter with the module your template resides

````
$checkplugin_template_module => 'SomeModule',
````

Example 1: Distribute check plugin that is a template
````
icinga2::checkplugin { 'check_diskstats':
  checkplugin_template => 'checkplugins/check_diskstats.erb',
}
````

Example 2: Distribute check plugin that is a static file
````
icinga2::checkplugin { 'check_diskstats':
  checkplugin_file_distribution_method => 'source',
  checkplugin_source_file              => 'puppet:///modules/checkplugins/check_diskstats',
}
````

###[Object type usage](id:object_type_usage)

This module includes several defined types that can be used to automatically generate Icinga 2 format object definitions. They function in a similar way to [the built-in Nagios types that are included in Puppet](http://docs.puppetlabs.com/guides/exported_resources.html#exported-resources-with-nagios).

####Exported resources

Like the built-in Nagios types, the Icinga 2 objects in this module can be exported to PuppetDB as virtual resources and collected on your Icinga 2 server.

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
  target_file_mode  => '0644'
}
</pre>

####`undef` and default object values

Most of the object parameters *in the Puppet module* are set to **undef**.

This means that they will not be added to the rendered object definition files.

**However**, this doesn't mean that the values are undefined in Icinga 2. Icinga 2 itself has built-in default values for many object parameters and falls back to them if one isn't present in an object definition. See the docs for individual object types in [Configuring Icinga 2](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/toc#!/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2) for more info about which object parameters have what default values.

####[Objects](id:objects)

Object types:

* [icinga2::object::apply_service_to_host](#object_apply_service_to_host)
* [icinga2::object::checkcommand](#object_checkcommand)
* [icinga2::object::eventcommand](id:object_eventcommand)
* [icinga2::object::host](id:object_host)
* [icinga2::object::hostgroup](id:object_hostgroup)
* [icinga2::object::idomysqlconnection](id:object_idomysqlconnection)
* [icinga2::object::idopgsqlconnection](id:object_idopgsqlconnection)
* [icinga2::object::notificationcommand](id:object_notificationcommand)
* [icinga2::object::service](id:object_service)
* [icinga2::object::servicegroup](id:object_servicegroup)
* [icinga2::object::syslogger](id:object_syslogger)
* [icinga2::object::user](id:object_user)
* [icinga2::object::usergroup](id:object_usergroup)

####[`icinga2::object::apply_service_to_host`](id:object_apply_service_to_host)

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

####[`icinga2::object::checkcommand`](id:object_checkcommand)

The `checkcommand` defined type can create `checkcommand` objects.

Example:

<pre>
#Create an HTTP check command:
icinga2::object::checkcommand { 'check_http':
  command => ['"/check_http"'],
  arguments     => {'"-H"'             => '"$http_vhost$"',
    '"-I"'          => '"$http_address$"',
    '"-u"'          => '"$http_uri$"',
    '"-p"'          => '"$http_port$"',
    '"-S"'          => {
      'set_if' => '"$http_ssl$"'
    },
    '"--sni"'       => {
      'set_if' => '"$http_sni$"'
    },
    '"-a"'          => {
      'value'       => '"$http_auth_pair$"',
      'description' => '"Username:password on sites with basic authentication"'
    },
    '"--no-body"'   => {
      'set_if' => '"$http_ignore_body$"'
    },
    '"-r"' => '"$http_expect_body_regex$"',
    '"-w"' => '"$http_warn_time$"',
    '"-c"' => '"$http_critical_time$"',
    '"-e"' => '"$http_expect$"'
  },
  vars => {
    'vars.http_address' => '"$address$"',
    'vars.http_ssl'     => 'false',
    'vars.http_sni'     => 'false'
  }
}
</pre>

Available parameters are:

* `template_to_import`
* `command`
* `cmd_path`
* `arguments`
* `env`
* `vars`
* `timeout`
* `target_dir`
* `target_file_name`
* `target_file_owner`
* `target_file_group`
* `target_file_mode`

####`icinga2::object::eventcommand`

The `eventcommand` defined type can create `eventcommand` objects.

<pre>
#Create the http restart command:
icinga2::object::eventcommand { 'restart-httpd-event':
  command => [ '"/opt/bin/restart-httpd.sh"' ]
}

</pre>

This object use the same parameter defined to `checkcommand`.

####[`icinga2::object::host`](id:object_host)

This defined type creates host objects.

Example:

<pre>
@@icinga2::object::host { $::fqdn:
  display_name => $::fqdn,
  ipv4_address => $::ipaddress_eth1,
  groups => ["linux_servers", 'mysql_servers', 'postgres_servers', 'clients', 'smtp_servers', 'ssh_servers', 'http_servers', 'imap_servers'],
  vars => {
    os              => 'linux',
    virtual_machine => 'true',
    distro          => $::operatingsystem,
  },
  target_dir => '/etc/icinga2/objects/hosts',
  target_file_name => "${fqdn}.conf"
}
</pre>

Notes on specific parameters:

* `groups`: must be specified as a [Puppet array](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#arrays), even if there's only one element
* `vars`: must be specified as a [Puppet hash](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#hashes), with the Icinga 2 variable as the **key** and the variable's value as the **value**

**Note:** The `ipv6_address` parameter is set to **undef** by default. This is because `facter` can return either IPv4 or IPv6 addresses for the `ipaddress_ethX` facts. The default value for the `ipv6_address` parameter is set to **undef** and not `ipaddress_eth0` so that an IPv4 address isn't unintentionally set as the value for `address6` in the rendered host object definition.

If you would like to use an IPv6 address, make sure to set the `ipv6_address` parameter to the `ipaddress_ethX` fact that will give you the right IPv6 address for the machine:

<pre>
@@icinga2::object::host { $::fqdn:
  display_name => $::fqdn,
  ipv6_address => $::ipaddress_eth1,
....
}
</pre>

####[`icinga2::object::hostgroup`](id:object_hostgroup)

Coming soon...

####[`icinga2::object::idomysqlconnection`](id:object_idomysqlconnection)

This defined type creates an **IdoMySqlConnection** objects.

Though you can create the file anywhere and with any name via the `target_dir` and `target_file_name` parameters, you should set the `target_dir` parameter to `/etc/icinga2/features-enabled`, as that's where Icinga 2 will look for DB connection objects by default.

Example usage:

<pre>
icinga2::object::idomysqlconnection { 'mysql_connection':
   target_dir       => '/etc/icinga2/features-enabled',
   target_file_name => 'ido-mysql.conf',
   host             => '127.0.0.1',
   port             => 3306,
   user             => 'icinga2',
   password         => 'password',
   database         => 'icinga2_data',
   categories       => ['DbCatConfig', 'DbCatState', 'DbCatAcknowledgement', 'DbCatComment', 'DbCatDowntime', 'DbCatEventHandler' ],
}
</pre>

Some parameters require specific data types to be given:

* `port`: needs to be a [number](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#numbers), not a quoted string
* `cleanup`: If changed from the default value, needs to be given as a [hash](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#hashes) with the keys being the cleanup item names and the maximum age as a number (not a quoted string); default values are set to the default values shown in the [Cleanup Items section of the IdomysqlConnection object documentation](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-idomysqlconnection)
* `categories`: needs to be given as an [array](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#arrays) with [single-quoted strings](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#single-quoted-strings) as the elements; default values are set to the default values shown in the [Data Categories section of the IdomysqlConnection object documentation](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-idomysqlconnection)

All other parameters are given as [single-quoted strings](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#single-quoted-strings).

This defined type supports all of the parameters that **IdoMySqlConnection** objects have available.

See [IdoMySqlConnection](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-idomysqlconnection) on [docs.icinga.org](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/toc) for a full list of parameters.

####[`icinga2::object::idopgsqlconnection`](id:object_idopgsqlconnection)

This defined type creates an **IdoPgSqlConnection** objects.

Though you can create the file anywhere and with any name via the `target_dir` and `target_file_name` parameters, you should set the `target_dir` parameter to `/etc/icinga2/features-enabled`, as that's where Icinga 2 will look for DB connection objects by default.

Example usage:

<pre>
icinga2::object::idopgsqlconnection { 'postgres_connection':
   target_dir => '/etc/icinga2/features-enabled',
   target_file_name => 'ido-pgsql.conf',
   host             => '127.0.0.1',
   port             => 5432,
   user             => 'icinga2',
   password         => 'password',
   database         => 'icinga2_data',

   categories => ['DbCatConfig', 'DbCatState', 'DbCatAcknowledgement', 'DbCatComment', 'DbCatDowntime', 'DbCatEventHandler' ],
}
</pre>

Some parameters require specific data types to be given:

* `port`: needs to be a [number](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#numbers), not a quoted string
* `cleanup`: If changed from the default value, needs to be given as a [hash](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#hashes) with the keys being the cleanup item names and the maximum age as a number (not a quoted string); default values are set to the default values shown in the [Cleanup Items section of the IdopgsqlConnection object documentation](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-idopgsqlconnection)
* `categories`: needs to be given as an [array](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#arrays) with [single-quoted strings](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#single-quoted-strings) as the elements; default values are set to the default values shown in the [Data Categories section of the IdopgsqlConnection object documentation](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-idopgsqlconnection)

All other parameters are given as [single-quoted strings](https://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#single-quoted-strings).

This defined type supports all of the parameters that **IdoMySqlConnection** objects have available.

See [IdoPgSqlConnection](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-idopgsqlconnection) on [docs.icinga.org](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/toc) for a full list of parameters.

####`icinga2::object::notificationcommand`

The `notificationcommand` defined type can create `notificationcommand` objects.

<pre>
#Create the mail notification command:
icinga2::object::notificationcommand { 'mail-service-notification':
  command   => ['"/icinga2/scripts/mail-notification.sh"'],
  cmd_path  => 'SysconfDir',
  env       => {
    'NOTIFICATIONTYPE'  => '"$notification.type$"',
    'SERVICEDESC' => '"$service.name$"',
    'HOSTALIAS' => '"$host.display_name$"',
    'HOSTADDRESS' => '"$address$"',
    'SERVICESTATE' => '"$service.state$"',
    'LONGDATETIME' => '"$icinga.long_date_time$"',
    'SERVICEOUTPUT' => '"$service.output$"',
    'NOTIFICATIONAUTHORNAME' => '"$notification.author$"',
    'NOTIFICATIONCOMMENT' => '"$notification.comment$"',
    'HOSTDISPLAYNAME' => '"$host.display_name$"',
    'SERVICEDISPLAYNAME' => '"$service.display_name$"',
    'USEREMAIL' => '"$user.email$"'
  }
}

</pre>

This oobject use the same parameter defined to `checkcommand`.

####[`icinga2::object::service`](id:object_service)

Coming soon...

####[`icinga2::object::servicegroup`](id:object_servicegroup)

This defined type creates an **ServiceGroup** objects.

Example usage:

<pre>
icinga2::object::servicegroup { 'web_services':
  display_name => 'web services',
  target_dir => '/etc/icinga2/objects/servicegroups',
}
</pre>

See [ServiceGroup](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-servicegroup) on [docs.icinga.org](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/toc) for a full list of parameters.

####[`icinga2::object::sysloglogger`](id:object_syslogger)

This defined type creates **SyslogLogger** objects.

`severity` can be set to **debug**, **notice**, **information**, **warning** or **critical**. 

Example usage:

<pre>
icinga2::object::sysloglogger { 'syslog-warning':
  severity => 'warning',
  target_dir => '/etc/icinga2/features-enabled',
}
</pre>

See [SyslogLogger](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-servicegroup) on [docs.icinga.org](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-sysloglogger) for more info.

####[`icinga2::object::user`](id:object_user)

Coming soon...

####[`icinga2::object::usergroup`](id:object_usergroup)

You can use this defined type to create user groups. Example:

<pre>
#Create an admins user group:
icinga2::object::hostgroup { 'admins':
  display_name => 'admins',
  target_dir => '/etc/icinga2/objects/usergroups',
}
</pre>

####[`icinga2::object::graphitewriter`](id:object_graphitewriter)

This defined type creates an **GraphiteWriter** object

Though you can create the file anywhere and with any name via the target_dir and target_file_name parameters, you should set the target_dir parameter to /etc/icinga2/features-enabled, as that's where Icinga 2 will look for graphitewriter connection objects by default.

Example Usage:

````
icinga2::object::graphitewriter { 'graphite_relay':
  target_dir       => '/etc/icinga2/features-enabled',
  target_file_name => 'graphite.conf',
  graphite_host    => '127.0.0.1',
  graphite_port    => 2003,
}
````

[Reference](id:reference)
---------

Classes:

Coming soon...

Defined types:

Coming soon...

[Limitations](id:limitations)
------------

Coming soon...

[Development](id:contributors)
------------

###Contributing

To submit a pull request via Github, fork [Icinga/puppet-icinga2](https://github.com/Icinga/puppet-icinga2) and make your changes in a feature branch off of the master branch. 

If your changes require any discussion, create an account on [https://www.icinga.org/register/](https://www.icinga.org/register/). Once you have an account, log onto [dev.icinga.org](https://dev.icinga.org/). Create an issue under the **Icinga Tools** project and add it to the **Puppet** category.

If applicable for the changes you're making, add documentation to the `README.md` file.

###Support

Check the project website at http://www.icinga.org for status updates and
https://support.icinga.org if you want to contact us.

[Contributors](id:contributors)
------------

Coming soon...
