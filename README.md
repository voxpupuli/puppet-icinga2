# Icinga2 Puppet Module
![Icina Logo](images/icinga_logo.png)


#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with icinga2](#setup)
    * [What icinga2 affects](#what-icinga2-affects)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Public Classes](#public-classes)
    * [Public defined types](#public-defined-types)
    * [Private defined types](#private-defined-types)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

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


## Reference

### Public Classes

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