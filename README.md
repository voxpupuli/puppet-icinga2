# Icinga2 Puppet Module

![Icina Logo](https://www.icinga.org/wp-content/uploads/2014/06/icinga_logo.png)

#### Table of Contents

1. [Overview][Overview]
2. [Module Description - What the module does and why it is useful][Module description]
3. [Setup - The basics of getting started with icinga2][Setup]
    * [What Icinga2 affects][]
4. [Usage - Configuration options and additional functionality][Usage]
5. [Reference - An under-the-hood peek at what the module is doing and how][Reference]
    * [Public Classes][]
    * [Private Classes][]
    * [Public defined types][]
    * [Private defined types][]
6. [Limitations - OS compatibility, etc.][Limitations]
7. [Development - Guide for contributing to the module][Development]

## Overview

Icinga2 is a widely used open source monitoring software. This Puppet module helps installing and managing configuration
of Icinga2 on multiple operating sytems. 

>> This Module is a rewrite of [puppet-icinga2] and will replace it in the future.

## Module Description
This module installs and configures Icinga2 on your Linux or Windows hosts. By default it will use packages provided by
your distributions repository, respectively chocolatey on Windows. The module can be enabled to use [packages.icinga.org]
as primary repository, which will give you the ability to install the latest Icinga2 release. All features and objects
available in Icinga2 can be enabled and configured with this module.

## Setup

### What the Icinga2 Puppet module affects

* Packages Installation
* Service 
* Objects Configuration
* Feature Configuration
* Apply Rules
* MySQL/PostgreSQL Database Schema Import 
* Repository Management 
* Certification Authority

### Dependencies
This module depends on:

* [puppetlabs/stdlib]
* [puppetlabs/concat]

Depending on your setup following modules may also be required:

* [puppetlabs/apt]
* [puppetlabs/chocolatey]

## Usage

### Installing Icinga2
The default class `icinga2` will install and configure a basic installation of Icinga2 on your system. By default it will
enable the features `checker`, `mainlog` and `notification`. As default installation source the distributions repository will
used. On Windows systems we use chocolatey. To get the latest version of Icinga2 you need to enable the `manage_repo`
parameter, which will allow the module to add the official [packages.icinga.org] repository to your host.

``` puppet
  class { 'icinga2':
    manage_repo => true
  }
```

### Enable Features
Each Icinga2 feature can be enabled or disabled by using the according classes. In addition to that, there is a set of
default features that are enabled by default: `[ 'checker', 'mainlog', 'notification' ]`

The default set of features can be changed by setting the `features` parameter: 
```
class { 'icinga2':
  manage_repo => true,
  features    => ['checker', 'mainlog', 'command']
}
```

To add enable features and change their default settings, use the feature classes:
```
class { 'icinga2::feature::graphite':
  host                   => '10.10.0.15',
  port                   => 2003,
  enable_send_thresholds => true,
  enable_send_metadata   => true
}
```

### Enable IDO
The IDO feature can be enabled either in combination with MySQL or PostgreSQL. Depending on your database you need to
enable the feature `icinga2::feature::idomysql` or `icinga2::feature::idopgsql`. Both features are capable of importing
the base schema into the database, however this is disabled by default. Updating the database schema to another version
is currently not supported.

```
class{ 'icinga2::feature::idomysql':
  user => "icinga2",
  password => "icinga2",
  database => "icinga2",
  import_schema => true
}
```

### Custom configuration files
Sometimes it's necessary to cover very special configurations that you cannot handle with this module. In this case you
can use the `icinga2::config::file` tag on your file ressource. This module collects all file ressource types with this
tag and triggers a reload of Icinga2 on a file change.

``` puppet
  include icinga2
  file { '/etc/icinga2/conf.d/for-loop.conf':
    ensure => file,
    tag    => 'icinga2::config::file',
  }
```

## Reference

- [**Public classes**](#public-classes)
    - [Class: icinga2](#class-icinga2)
    - [Class: icinga2::feature::checker](#class-icinga2feature-checker)
    - [Class: icinga2::feature::mainlog](#class-icinga2feature-mainlog)
    - [Class: icinga2::feature::notification](#class-icinga2feature-notification)
    - [Class: icinga2::feature::command](#class-icinga2feature-command)
    - [Class: icinga2::feature::compatlog](#class-icinga2-feature-compat)
    - [Class: icinga2::feature::graphite](#class-icinga2-feature-graphite)
    - [Class: icinga2::feature::livestatus](#class-icinga2-feature-livestatus)
    - [Class: icinga2::feature::opentsdb](#class-icinga2-feature-opentsdb)
    - [Class: icinga2::feature::perfdata](#class-icinga2-feature-perfdata)
    - [Class: icinga2::feature::statusdata](#class-icinga2-feature-statusdata)
    - [Class: icinga2::feature::syslog](#class-icinga2-feature-syslog)
    - [Class::icinga2::feature::debuglog](#class-icinga2-feature-debuglog)
    - [Class::icinga2::feature::gelf](#class-icinga2-feature-gelf)
    - [Class::icinga2::feature::idomysql](#class-icinga2featureido-mysql)
- [**Private classes**](#private-classes)
    - [Class: icinga2::repo](#class-icinga2repo)
    - [Class: icinga2::install](#class-icinga2install)
    - [Class: icinga2::config](#class-icinga2config)
    - [Class: icinga2::service](#class-icinga2service)
- [**Public defined types**](#public-defined-types)
- [**Private defined types**](#private-defined-types)
    - [Defined type: icinga2::feature](#defined-type-icinga2feature)

### Public Classes

#### Class: `icinga2`
The default class of this modoule. It handles the basic installation and configuration of Icinga2. When you declare this
class, puppet will do the following:

* Install Icinga2
* Place a default configuration for the Icinga2 daemon
* Keep the default configuration of the Icinga2 package
* Start Icinga2 and enable the service

This class can be declared without adjusting any parameter:

``` puppet
class { 'icinga2': }
```

**Parameters within `icinga2`:**

##### `ensure`
Defines if the service should be `running` or `stopped`. Default is `running`

##### `enable`
If set to `true` the Icinga2 service will start on boot. Default is `true`.

##### `manage_repo`
When set to `true` this module will install the [packages.icinga.org] repository. With this official repo
you can get the latest version of Icinga. When set to `false` the operating systems default will be used. As the Icinga
Project does not offer a Chocolatey repository, you will get a warning if you enable this parameter on Windows. Default
is `false`

##### `manage_service`
Lets you decide if the Icinga2 daemon should be reloaded when configuration files have changed. Default is `true`

##### `features`
A list of features to enable by default. Default is `[checker, mainlog, notification]`

##### `purge_features`
Define if configuration files for features not managed by Puppet should be purged. Default is true.

##### `constants`
Hash of constants. Defaults are set in the params class. Your settings will be merged with the defaults.

##### `plugins`
A list of the ITL plugins to load. Default to `[ 'plugins', 'plugins-contrib', 'windows-plugins', 'nscp' ]`.

##### `confd`
This is the directory where Icinga2 stores it's object configuration by default. To disable this, set the parameter
to `false`. It's also possible to assign your own directory. This directory is relative to etc/icinga2 and must be
managed outside of this module as file resource with tag icinga2::config::file. By default this parameter is `true`.

#### Class: `icinga2::feature::checker`
Enables or disables the `checker` feature. 

**Parameters of `icinga2::feature::checker`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `checker` should be enabled. Default is `present`.

#### Class: `icinga2::feature::mainlog`
Enables or disables the `mainlog` feature.

**Parameters of `icinga2::feature::mainlog`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `mainlog` should be enabled. Default is `present`.

##### `severity`
Sets the severity of the `mainlog` feature. Can be set to:

* `information`
* `notice`
* `warning`
* `debug`

Default is `information`

##### `path`
Absolute path to the logging file. Default depends on platform:

* Linux: `/var/log/icinga2/icinga2.log`
* Windows: `C:/ProgramData/icinga2/var/log/icinga2/icinga2.log`

#### Class: `icinga2::feature::notification`
Enables or disables the `notification` feature.

**Parameters of `icinga2::feature::notification`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `notification` should be enabled. Default is `present`.

#### Class: `icinga2::feature::command`
Enables or disables the `command` feature.

**Parameters of `icinga2::feature::command`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `command` should be enabled. Default is `present`.

##### `commandpath`
Absolute path to the command pipe. Default depends on platform:
 
* Linux: `/var/run/icinga2/cmd/icinga2.cmd`
* Windows: `C:/ProgramData/icinga2/var/run/icinga2/cmd/icinga2.cmd`

#### Class: `icinga2::feature::compatlog`
Enables or disables the `compatlog` feature.

**Parameters of `icinga2::feature::compatlog`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `compatlog` should be enabled. Default is `present`.

##### `commandpath`
Absolute path to the command pipe. Default depends on platform:
 
* Linux: `/var/run/icinga2/cmd/icinga2.cmd`
* Windows: `C:/ProgramData/icinga2/var/run/icinga2/cmd/icinga2.cmd`

##### `log_dir`
Absolute path to the log directory. Default depends on platform:

* Linux: `/var/log/icinga2/compat`
* Windows: `C:/ProgramData/icinga2/var/log/icinga2/compat`

##### `rotation_method`
Sets how often should the log file be rotated. Valid options are:

* `HOURLY`
* `DAILY`
* `WEEKLY`
* `MONTHLY` 

Default is `DAILY`

#### Class: `icinga2::feature::graphite`
Enables or disables the `graphite` feature.

**Parameters of `icinga2::feature::graphite`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `graphite` should be enabled. Default is `present`.

##### `host`
Graphite Carbon host address. Default is `127.0.0.1`.

##### `port`
Graphite Carbon port. Default is `2003`.

##### `host_name_template`
Template for metric path of hosts. Default is `icinga2.$host.name$.host.$host.check_command$`.

##### `service_name_template`
Template for metric path of services. Default is `icinga2.$host.name$.services.$service.name$.$service.check_command$`.

##### `enable_send_thresholds`
Send threholds as metrics. Default is false.

##### `enable_send_metadata`
Send metadata as metrics. Default is false.

#### Class: `icinga2::feature::livestatus`
Enables or disables the `livestatus` feature.

**Parameters of `icinga2::feature::livestatus`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `livestatus` should be enabled. Default is `present`.

##### `socket_type`
Specifies the socket type. Can be either 'tcp' or 'unix'. Default is 'unix'

##### `bind_host`
IP address to listen for connections. Only valid when socket_type is `tcp`. Default is `127.0.0.1`

##### `bind_port`
Port to listen for connections. Only valid when socket_type is `tcp`. Default is `6558`

##### `socket_path`
Specifies the path to the UNIX socket file. Only valid when socket_type is `unix`. Default depends on platform:
 
* Linux: `/var/run/icinga2/cmd/livestatus`
* Windows: `C:/ProgramData/icinga2/var/run/icinga2/cmd/livestatus`

##### `compat_log_path`
Required for historical table queries. Requires `CompatLogger` feature to be enabled. Default depends platform:

Linux: `var/icinga2/log/icinga2/compat`
Windows: `C:/ProgramData/icinga2/var/log/icinga2/compat`

#### Class: `icinga2::feature::opentsdb`
Enables or disables the `opentsdb` feature.

**Parameters of `icinga2::feature::opentsdb`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `opentsdb` should be enabled. Default is `present`.

##### `host`
OpenTSDB host address. Default is `127.0.0.1`

##### `port`
OpenTSDB port. Default is `4242`

#### Class: `icinga2::feature::perfdata`
Enables or disables the `perfdata` feature.

**Parameters of `icinga2::feature::perfdata`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `perfdata` should be enabled. Default is `present`.

##### `ost_perfdata_path`
Absolute path to the perfdata file for hosts. Default depends on platform:
* Linux: `/var/spool/icinga2/host-perfdata`
* Windows: `C:/ProgramData/icinga2/var/spool/icinga2/host-perfdata`

##### `service_perfdata_path`
Absolute path to the perfdata file for services. Default depends on platform:
* Linux: `/var/spool/icinga2/service-perfdata`
* Windows: `C:/ProgramData/icinga2/var/spool/icinga2/service-perfdata`

###### `host_temp_path`
Path to the temporary host file. Defaults depends on platform:
* Linux: `/var/spool/icinga2/tmp/host-perfdata` 
* Windows: `C:/ProgramData/icinga2/var/spool/icinga2/tmp/host-perfdata`

##### `service_temp_path`
Path to the temporary service file. Defaults depends on platform:
* Linux: `/var/spool/icinga2/tmp/host-perfdata` 
* Windows: `C:/ProgramData/icinga2/var/spool/icinga2/tmp/host-perfdata`

##### `rotation_interval`
Rotation interval for the files specified in {host,service}_perfdata_path. Can be written in minutes or seconds,
i.e. 1m or 15s. Defaults is 30s.

#### Class: `icinga2::feature::statusdata`
Enables or disables the `statusdata` feature.

**Parameters of `icinga2::feature::statusdata`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `statusdata` should be enabled. Default is `present`.

##### `status_path`
Absolute path to the status.dat file. Default depends on platform:
* Linux: `/var/cache/icinga2/status.dat`
* Windows: `C:/ProgramData/icinga2/var/cache/icinga2/status.dat`

##### `object_path`
Absolute path to the object.cache file. Default depends on platform:
* Linux: `/var/cache/icinga2/object.cache`
* Windows: `C:/ProgramData/icinga2/var/cache/icinga2/object.cache`

##### `update_interval`
Interval in seconds to update both status files. You can also specify it in minutes with the letter m or in seconds
with s. Default is `30s`

#### Class: `icinga2::feature::syslog`
Enables or disables the `syslog` feature.

**Parameters of `icinga2::feature::syslog`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `syslog` should be enabled. Default is `present`.

##### `severity`
Set severity level for logging to syslog. Available options are:

* `information`
* `notice`
* `warning`
* `debug`

Default is `warning`

#### Class: `icinga2::feature::debuglog`
Enables or disables the `debuglog` feature.

**Parameters of `icinga2::feature::debuglog`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `debuglog` should be enabled. Default is `present`.

##### `path`
Absolute path to the log file. Default depends on platform:
* Linux: `/var/log/icinga2/debug.log`
* Windows: `C:/ProgramData/icinga2/var/log/icinga2/debug.log`

#### Class: `icinga2::feature::gelf`
Enables or disables the `gelf` feature.

**Parameters of `icinga2::feature::gelf`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `gelf` should be enabled. Default is `present`.

##### `host`
GELF receiver host address. Default is `127.0.0.1`

##### `port`
GELF receiver port. Default is `12201`

##### `source`
Source name for this instance. Default is `icinga2`

##### `enable_send_perfdata`
Enable performance data for *CHECK RESULT* events. Default is `false`.

#### Class: `icinga2::feature::idomysql`
Enables or disables the `gelf` feature.

**Parameters of `icinga2::feature::idomysql`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature `ido-mysql` should be enabled. Default is `present`.

##### `host`
MySQL database host address. Defaults to `127.0.0.1`

##### `port`
MySQL database port. Defaults to `3306`

##### `socket_path`
MySQL socket path.

##### `user`
MySQL database user with read/write permission to the icinga database. Defaults to `icinga`

##### `password`
MySQL database user's password. Defaults to `icinga`

##### `database`
MySQL database name. Defaults to `icinga`

##### `enable_ssl`
Use SSL. Defaults to false. Change to true in case you want to use any of the SSL options.

##### `table_prefix`
MySQL database table prefix. Defaults to `icinga_`

##### `instance_name`
Unique identifier for the local Icinga 2 instance. Defaults to `default`

##### `instance_description`
Description for the Icinga 2 instance.

##### `enable_ha`
Enable the high availability functionality. Only valid in a cluster setup. Defaults to `true`

##### `failover_timeout`
Set the failover timeout in a HA cluster. Must not be lower than 60s. Defaults to `60s`

##### `cleanup`
Hash with items for historical table cleanup.

##### `categories`
Array of information types that should be written to the database.

##### `import_schema`
Whether to import the MySQL schema or not. Defaults to `false`

### Private Classes

#### Class: `icinga2::repo`
Installs the [packages.icinga.org] repository. Depending on your operating system [puppetlabs/apt] or
[puppetlabs/chocolatey] are required.

#### Class: `icinga2::install`
Handles the installation of the Icinga2 package.

#### Class: `icinga2::config`
Installs basic configuration files required to run Icinga2.

#### Class: `icinga2::service`
Starts/stops and enables/disables the service.

### Public defined types

### Private defined types

#### Defined type: `icinga2::feature`
This defined type is used by all feature defined types as basis. It can generally enable or disable features.

**Parameters of `icinga2::feature`:**

##### `ensure`
Either `present` or `absent`. Defines if the feature should be enabled. Default is `present`.

##### `feature`
Name of the feature. This name is used for the corresponding configuration file.

## Limitations
This module has been tested on:

* Debian 7, 8
* Ubuntu 14.04, 16.04
* CentOS/RHEL 6, 7
* Windows Server 2012

Other operating systems or versions may work but have not been tested.

## Development
A roadmap of this project is located at https://dev.icinga.org/projects/puppet-icinga2-rewrite/roadmap. Please consider
this roadmap when you start contributing to the project.

### Contributing
When contributing several steps such as pull requests and proper testing implementations are required.
Find a detailed step by step guide in [CONTRIBUTING.md].

### Testing
Testing is essential in our workflow to ensure a good quality. We use RSpec as well as Serverspec to test all components
of this module. For a detailed description see [TESTING.md].

## Release Notes
When releasing new versions we refer to [SemVer 1.0.0] for version numbers. All steps required when creating a new
release are described in [RELEASE.md]

See also [CHANGELOG.md]

## Authors
[AUTHORS] is generated on each release.

[Overview]: #overview
[Module description]: #module-description
[Setup]: #setup
[What Icinga2 affects]: #what-icinga2-affects
[Usage]: #usage
[Reference]: #reference
[Public Classes]: #public-classes
[Private Classes]: #private-classes
[Public Defined Types]: #public-defined-types
[Private Defined Types]: #private-defined-types
[Limitations]: #limitations
[Development]: #development

[puppetlabs/stdlib]: https://github.com/puppetlabs/puppetlabs-stdlib
[puppetlabs/concat]: https://github.com/puppetlabs/puppetlabs-concat
[puppetlabs/apt]: https://github.com/puppetlabs/puppetlabs-apt
[puppetlabs/chocolatey]: https://github.com/puppetlabs/puppetlabs-chocolatey
[puppet-icinga2]: https://github.com/icinga/puppet-icinga2
[packages.icinga.org]: https://packages.icinga.org
[SemVer 1.0.0]: http://semver.org/spec/v1.0.0.html

[CONTRIBUTING.md]: CONTRIBUTING.md
[TESTING.md]: TESTING.md
[RELEASE.md]: RELEASE.md
[CHANGELOG.md]: CHANGELOG.md
[AUTHORS]: AUTHORS

