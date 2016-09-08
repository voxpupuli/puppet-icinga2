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
- [**Private classes**](#private-classes)
    - [Class: icinga2::repo](#class-icinga2repo)
    - [Class: icinga2::install](#class-icinga2install)
    - [Class: icinga2::config](#class-icinga2config)
    - [Class: icinga2::service](#class-icinga2service)


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

##### `constants`
Hash of constants. Defaults are set in the params class. Your settings will be merged with the defaults.

##### `plugins`
A list of the ITL plugins to load. Default to `[ 'plugins', 'plugins-contrib', 'windows-plugins', 'nscp' ]`.

##### `confd`
This is the directory where Icinga2 stores it's object configuration by default. To disable this, set the parameter
to `false`. It's also possible to assign your own directory. This directory is relative to etc/icinga2 and must be
managed outside of this module as file resource with tag icinga2::config::file. By default this parameter is `true`.


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
[AUTHORS.md] is generated on each release.

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
[AUTHORS.md]: AUTHORS.md

