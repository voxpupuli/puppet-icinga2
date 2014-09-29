puppet-icinga2
==========

Table of Contents
-----------------

1. [Overview - What is the Icinga 2 module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with the Icinga 2 module](#setup)
4. [Usage - How to use the module for various tasks](#usage)
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

Coming soon...

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

Coming soon...

[Contributors](id:contributors)
------------

Coming soon...