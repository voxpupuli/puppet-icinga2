[![Build Status](https://travis-ci.org/Icinga/puppet-icinga2.svg?branch=master)](https://travis-ci.org/Icinga/puppet-icinga2)

# Icinga 2 Puppet Module

![Icinga Logo](https://www.icinga.com/wp-content/uploads/2014/06/icinga_logo.png)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with icinga2](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Installing Icinga](#installing-icinga)
    * [Clustering Icinga](#clustering-icinga)
    * [Config Objects](#config-objects)
    * [Reading objects from hiera](#Reading-objects-from-hiera)
    * [Apply Rules](#apply-rules)
    * [Custom configuration](#custom-configuration)
5. [How Configuration is parsed](#how-configuration-is-parsed)
6. [Reference](#reference)
7. [Release Notes](#release-notes)

## Overview

Icinga 2 is a widely used open source monitoring software. This Puppet module helps with installing and managing
configuration of Icinga 2 on multiple operating systems.

### What's new in version 3.4.0

The internal used function `icinga_attributes` was moved to `icinga2::icinga2_attributes` with parameter changes. All direct calls of these functions are replaced with a new wrapper function `icinga2::parse`. This function has the same parameters like the old one `icinga2_attributes`.

### What's new in version 3.2.0

Important: Read the Known Issues section about [Environment Bleed](#environment-bleed) at the end of this document!

Add Icinga 2.13.0 support includes the new influxdb2 feature.

Some parameters for secrets like passwords or tokens in features or objects now allow the datatype 'Sensetive'.
Strings set to constants or as custom variables can also use Sensitive. They are not parsed by the simple config
parser. When you're using hashes or arrays in constants or custom variables the whole data structure can be
secured by Sensitive.


### What's new in version 3.0.0

* The current version now uses the icinga :: repos class from the new `icinga` module for the configuration of
repositories including EPEL on RedHat and Backports on Debian. (see https://github.com/icinga/puppet-icinga)
* `manage_repos` will replace `manage_repo` in the future
* `manage_packages` will replace `manage_package` in the future
* Since Icinga v2.12.0 the fingerprint to validate certificates is a sha256 instead of a sha1. Both is supported now.

## Module Description

This module installs and configures Icinga 2 on your Linux or Windows hosts.

By default it uses packages provided by your distribution's repository or
[Chocolatey] on Windows.

The module can also be configured to use [packages.icinga.com] as the primary repository, which enables you to install
Icinga 2 versions that are newer than the ones provided by your distribution's vendor. All features and objects
available in Icinga 2 can be enabled and configured with this module.

## Setup

### What the Icinga 2 Puppet module supports

* Installation of packages
* Configuration of features
* Configuration of objects (also apply rules)
* Service
* MySQL / PostgreSQL Database Schema Import
* Repository Management
* Certification Authority

### Dependencies

This module supports:

* [puppet] >= 4.10 < 8.0.0

And depends on:

* [puppetlabs/stdlib] >= 5.0.0 < 8.0.0
    * If Puppet 6 is used a stdlib 5.1 or higher is required, see https://github.com/Icinga/puppet-icinga2/issues/505
* [puppetlabs/concat] >= 2.1.0 < 8.0.0
* [icinga/icinga] >= 1.0.0 < 3.0.0
    * needed if `manage_repos` is set to `true`
* [puppetlabs/chocolatey]
    * needed if agent os is windows and if either `manage_package` or `manage_packages` is set to `true`
### Limitations

The use of Icinga's own CA is recommended. If you still want to use the Puppet certificates, please note that Puppet 7 uses an intermediate CA by default and Icinga cannot handle its CA certificate, see [Icinga Issue](https://github.com/Icinga/icinga2/pull/8859).

This module has been tested on:

* Debian 10, 11
* Ubuntu 18.04, 20.04
* CentOS/RHEL 7, 8
* AlmaLinux/Rocky 8
* Fedora 32
* Windows Server 2019

Other operating systems or versions may work but have not been tested.

## Usage

### Installing Icinga

The default class `icinga2` installs and configures a basic installation of Icinga 2. The features `checker`, `mainlog`
and `notification` are enabled by default.

By default, your distribution's packages are used to install Icinga 2. On Windows systems we use the [Chocolatey]
package manager.

Use the `manage_repos` parameter to configure repositories by default the official and stable [packages.icinga.com]. To configure your own
repositories, or use the official testing or nightly snapshot stage, see https://github.com/icinga/puppet-icinga.

``` puppet
class { '::icinga2':
  manage_repos => true,
}
```

If you want to manage the version of Icinga 2, you have to disable the package management of this module and handle
packages in your own Puppet code. The attribute `manage_repos` is disabled by default and you have to manage
a repository within icinga in front of the package resource. You can combine this one with the section before about repositories.

``` puppet
# class of extra module icinga/icinga
include ::icinga::repos

package { 'icinga2':
  ensure => latest,
  notify => Class['icinga2'],
}

class { '::icinga2':
  manage_packages => false,
}
```

Note: Be careful with this option: Setting `manage_packages` to false means that this module will not install any package at
all, including IDO packages!


### Clustering Icinga

Icinga 2 can run in three different roles:

* in a master zone which is on top of the hierarchy
* in a satellite zone which is a child of a satellite or master zone
* a standalone client node/zone which works as an agent connected to master and/or satellite zones

To learn more about Icinga 2 Clustering, follow the official docs on [distributed monitoring]. The following examples show
how these roles can be configured using this Puppet module.

#### Master

A Master zone has no parent and is usually also the place where you enable the IDO and notification features. A master
sends configurations over the Icinga 2 protocol to satellites and/or clients.

More detailed examples can be found in the [examples] directory.

This example creates the configuration for a master that has one satellite connected. A global zone is created for
templates, and all features of a typical master are enabled.

``` puppet
class { '::icinga2':
  confd     => false,
  constants => {
    'ZoneName'   => 'master',
    'TicketSalt' => '5a3d695b8aef8f18452fc494593056a4',
  },
}

class { '::icinga2::feature::api':
  pki             => 'none',
  accept_commands => true,
  # when having multiple masters, you have to enable:
  accept_config => true,
  endpoints       => {
    'master.example.org'    => {},
    'satellite.example.org' => {
      'host' => '172.16.2.11'
    },
  },
  zones           => {
    'master' => {
      'endpoints' => ['master.example.org'],
    },
    'dmz'    => {
      'endpoints' => ['satellite.example.org'],
      'parent'    => 'master',
    },
  }
}

# to enable a CA on this instance you have to declare. Only one instance is allowed to be a CA:
include ::icinga2::pki::ca

icinga2::object::zone { 'global-templates':
  global => true,
}
```

#### Satellite

A satellite has a parent zone and one or multiple child zones. Satellites are usually created to distribute the
monitoring load or to reach delimited zones in the network. A satellite either executes checks itself or delegates them
to a client.

The satellite has fewer features enabled, but executes checks similar to a master. It connects to a master zone, and to
a satellite or client below in the hierarchy. As parent acts either the master zone, or another satellite zone.

``` puppet
class { '::icinga2':
  confd     => false,
  # setting dedicated feature list to disable notification
  features  => ['checker','mainlog'],
  constants => {
    'ZoneName' => 'dmz',
  },
}

class { '::icinga2::feature::api':
  accept_config   => true,
  accept_commands => true,
  ca_host         => '172.16.1.11',
  ticket_salt     => '5a3d695b8aef8f18452fc494593056a4',
  # to increase your security set fingerprint to validate the certificate of ca_host
  # fingerprint     => 'D8:98:82:1B:14:8A:6A:89:4B:7A:40:32:50:68:01:D8:98:82:1B:14:8A:6A:89:4B:7A:40:32:99:3D:96:72:72',
  endpoints       => {
    'satellite.example.org' => {},
    'master.example.org'    => {
      'host' => '172.16.1.11',
    },
  },
  zones           => {
    'master' => {
      'endpoints' => ['master.example.org'],
    },
    'dmz'    => {
      'endpoints' => ['satellite.example.org'],
      'parent'    => 'master',
    },
  }
}

icinga2::object::zone { 'global-templates':
  global => true,
}
```

#### Agent

Icinga 2 runs as a client usually on each of your servers. It receives config or commands from a satellite or master
zones and runs the checks that have to be executed locally.

The client is connected to the satellite, which is the direct parent zone.

``` puppet
class { '::icinga2':
  confd     => false,
  features  => ['mainlog'],
}

class { '::icinga2::feature::api':
  accept_config   => true,
  accept_commands => true,
  ticket_salt     => '5a3d695b8aef8f18452fc494593056a4',
  # to increase your security set fingerprint to validate the certificate of ca_host
  # fingerprint     => 'D8:98:82:1B:14:8A:6A:89:4B:7A:40:32:50:68:01:D8:98:82:1B:14:8A:6A:89:4B:7A:40:32:99:3D:96:72:72',
  endpoints       => {
    'NodeName'              => {},
    'satellite.example.org' => {
      'host' => '172.16.2.11',
    },
  },
  zones           => {
    'ZoneName' => {
      'endpoints' => ['NodeName'],
      'parent'    => 'dmz',
    },
    'dmz'      => {
      'endpoints' => ['satellite.example.org'],
    },
  }
}

icinga2::object::zone { 'global-templates':
  global => true,
}
```

The parameter `fingerprint` is optional and new since v2.1.0. It's used to validate the certificate of the CA host.
You can get the fingerprint via `openssl x509 -noout -fingerprint -sha256 -inform pem -in master.crt` on the master host. (Icinga2 versions before 2.12.0 require '-sha1' as digest algorithm.)


### Config Objects

With this module you can create almost every object that Icinga 2 knows about. When creating objects some parameters are
required. This module sets the same requirements as Icinga 2 does. When creating an object you must set a target for the
configuration.

Here are some examples for some object types:

#### Host
``` puppet
icinga2::object::host { 'srv-web1.fqdn.com':
  display_name  => 'srv-web1.fqdn.com',
  address       => '127.0.0.1',
  address6      => '::1',
  check_command => 'hostalive',
  target        => '/etc/icinga2/conf.d/srv-web1.fqdn.com.conf',
}
```

#### Service
``` puppet
icinga2::object::service { 'uptime':
  host_name      => 'srv-web1.fqdn.com',
  display_name   => 'Uptime',
  check_command  => 'check_uptime',
  check_interval => '600m',
  groups         => ['uptime', 'linux'],
  target         => '/etc/icinga2/conf.d/uptime.conf',
}
```

#### Hostgroup
``` puppet
icinga2::object::hostgroup { 'monitoring-hosts':
  display_name => 'Linux Servers',
  groups       => [ 'linux-servers' ],
  target       => '/etc/icinga2/conf.d/groups2.conf',
  assign       => [ 'host.vars.os == linux' ],
}
```

### Reading objects from hiera

The following example shows how icinga2 objects can be read from
a hiera datastore. See also examples/objects_from_hiera.pp.

```
class { 'icinga2':
  manage_repos => true,
}

$defaults = lookup('monitoring::defaults', undef, undef, {})

lookup('monitoring::objects').each |String $object_type, Hash $content| {
  $content.each |String $object_name, Hash $object_config| {
    ensure_resource(
      $object_type,
      $object_name,
      deep_merge($defaults[$object_type], $object_config))
  }
}
```

The datastore could be like:

```
---
monitoring::objects:
  'icinga2::object::host':
    centos7.localdomain:
      address: 127.0.0.1
      vars:
        os: Linux
  'icinga2::object::service':
    ping4:
      check_command: ping4
      apply: true
      assign:
        - host.address
    ssh:
      check_command: ssh
      apply: true
      assign:
        - host.address && host.vars.os == Linux

monitoring::defaults:
  'icinga2::object::host':
    import:
      - generic-host
    target: /etc/icinga2/conf.d/hosts.conf
  'icinga2::object::service':
    import:
      - generic-service
    target: /etc/icinga2/conf.d/services.conf
```


### Apply Rules

Some objects can be applied to other objects. To create a simple apply rule you
must set the `apply` parameter to `true`. If this parameter is set to a string,
this string will be used to build an `apply for` loop. A service object always
targets a host object. All other objects need to explicitly set an
`apply_target`

Apply a SSH service to all Linux hosts:

```
icinga2::object::service { 'SSH':
  target        => '/etc/icinga2/conf.d/test.conf',
  apply         => true,
  assign        => [ 'host.vars.os == Linux' ],
  ignore        => [ 'host.vars.os == Windows' ],
  display_name  => 'Test Service',
  check_command => 'ssh',
}
```

Apply notifications to services:

```
icinga2::object::notification { 'testnotification':
  target       => '/etc/icinga2/conf.d/test.conf',
  apply        => true,
  apply_target => 'Service',
  assign       => [ 'host.vars.os == Linux' ],
  ignore       => [ 'host.vars.os == Windows' ],
  user_groups  => ['icingaadmins']
}
```

Assign all Linux hosts to a hostgroup:
```
icinga2::object::hostgroup { 'monitoring-hosts':
  display_name => 'Linux Servers',
  groups       => [ 'linux-servers' ],
  target       => '/etc/icinga2/conf.d/groups2.conf',
  assign       => [ 'host.vars.os == linux' ],
}
```

A loop to create HTTP services for all vHosts of a host object:
```
icinga2::object::service { 'HTTP':
  target        => '/etc/icinga2/conf.d/http.conf',
  apply         => 'http_vhost => config in host.vars_http_vhost',
  assign        => [ 'host.vars.os == Linux' ],
  display_name  => 'HTTP Service',
  check_command => 'http',
}
```

### Custom Configuration

Sometimes it's necessary to cover very special configurations, that you cannot handle with this module. In this case you can use the `icinga2::config::file` tag on your file resource. The module collects all file resource types with this tag and triggers a reload of Icinga 2 on a file change.

```
include ::icinga2

file { '/etc/icinga2/conf.d/for-loop.conf':
  ensure => file,
  source => '...',
  tag    => 'icinga2::config::file',
}
```

## How Configuration is parsed

To generate a valid Icinga 2 configuration all object attributes are parsed. This simple parsing algorithm takes a
decision for each attribute, whether part of the string is to be quoted or not, and how an array or dictionary is to be
formatted.

Parsing of a single attribute can be disabled by tagging it with -: at the front of the string.
```
   attr => '-:"unparsed string with quotes"'
```
An array, a hash or a string can be assigned to an object attribute. True and false are also valid values.

Hashes and arrays are created recursively, and all parts – such as single items of an array, keys and its values
are parsed separately as strings.

Strings are parsed in chunks, by splitting the original string into separate substrings at specific keywords (operators)
such as `+`, `-`, `in`, `&&`, `||`, etc.

**NOTICE**: This splitting only works for keywords that are surrounded by whitespace, e.g.:
```
   attr => 'string1 + string2 - string3'
```

The algorithm will loop over the parameter and start by splitting it into 'string1' and 'string2 - string3'.
'string1' will be passed to the sub function 'value_types' and then the algorithm will continue parsing the rest of the
string ('string2 - string3'), splitting it, passing it to value_types, etc.

Brackets are parsed for expressions:
```
  attr => '3 * (value1 - value2) / 2'
```

The parser also detects function calls and will parse all parameters separately.
```
  attr => 'function(param1, param2, ...)'
```

True and false can be used as either booleans or strings.
```
  attrs => true or  attr => 'true'
```

In Icinga you can write your own lambda functions with {{ ... }}. For Puppet use:
```
  attrs => '{{ ... }}'
```

The parser analyzes which parts of the string have to be quoted and which do not.

As a general rule, all fragments are quoted except for the following:

* Boolean: `true`, `false`
* Numbers: `3` or `2.5`
* Time Intervals: `3m` or `2.5h`  (s = seconds, m = minutes, h = hours, d = days)
* Functions: `{{ ... }}` or function `()` `{}`
* All constants, which are declared in the constants parameter in main class `icinga2`
    * `NodeName`
* Names of attributes that belong to the same type of object:
    * e.g. `name` and `check_command` for a host object
* All attributes or variables (custom attributes) from the host, service or user contexts:
    * `host.name`, `service.check_command`, `user.groups`, ...

Assignment with += and -=:
 
Now it's possible to build an Icinga DSL code snippet like 
```
  vars += config
```
simply use a string with the prefix '+ ', e.g.
```
  vars => '+ config',
```
The blank between + and the proper string 'config' is imported for the parser because numbers 
```
  attr => '+ -14',
```
are also possible now. For numbers -= can be built, too:
```
  attr => '- -14',
```
Arrays can also be marked to merge with '+' or reduce by '-' as the first item of the array:
```
  attr => [ '+', item1, item2, ... ]
```
Result: attr += [ item1, item2, ... ]
```
  attr => [ '-', item1, item2, ... ]
```
Result: attr -= [ item1, item2, ... ]

That all works for attributes and custom attributes!

Finally dictionaries can be merged when a key '+' is set:
```
  attr => {
    '+'    => true,
    'key1' => 'val1',
  }
```
Result:
```
  attr += {
    "key1" = "val1"
  }
```
If 'attr' is a custom attribute this just works since level 3 of the dictionary:
```
  vars => {
    'level1' => {
      'level2' => {
        'level3' => {
          '+' => true,
          ...
        },
      },
    },
  },
```
Parsed to:
```
  vars.level1["level2"] += level3
```
Now it's also possible to add multiple custom attributes:
```
  vars => [
    {
      'a' => '1',
      'b' => '2', 
    },
    'config',
    { 
      'c' => { 
        'd' => { 
          '+' => true,
          'e' => '5',
        },
      },
    },
  ],
```
And you'll get:
```
  vars.a = "1"
  vars.b = "2"
  vars += config
  vars.c["d"] += {
    "e" = "5"
  }
```
Note: Using an Array always means merge '+=' all items to vars.

##### What isn't supported?

It's not currently possible to use dictionaries in a string WITH nested array or hash, like
```
  attr1 => 'hash1 + { item1 => value1, item2 => [ value1, value2 ], ... ]'
  attr2 => 'hash2 + { item1 => value1, item2 => { ... },... }'
```

## Reference

See [REFERENCE.md](https://github.com/Icinga/puppet-icinga2/blob/master/REFERENCE.md)

## Known Issues

### Environment Bleed

Due to a long known bug in puppet known as environment bleed, upgrading this module from versions <3.2.0 to a version >=3.2.0 may present some issues. The handling of new datatypes introduced in the 3.2.0 update of this module may result in configuration file contents with the following line:
```
password = "Sensitive [value redacted]"
```
This may affect configuration files which are influenced by the following puppet code pieces:
- icinga2::feature::api::ticket\_salt
- icinga2::feature::api::ticket\_id
- icinga2::feature::elasticsearch::password
- icinga2::feature::icingadb::password
- icinga2::feature::idomysql::password
- icinga2::feature::idopgsql::password
- icinga2::feature::influxdb::password
- icinga2::feature::influxdb::basic\_auth['password']
- icinga2::feature::influxdb2::auth\_token
- icinga2::object::apiuser::password

This may be fixed by doing the following steps in order:
1. Update all environments containing this module to the latest version
2. Regenerate all resource types in case you are using environment isolation
	- 2.1 Delete old resource types for each environment
		```
		rm -rf /etc/puppetlabs/code/environment/xxx/.resource\_types/
		```
	- 2.2 Generate new resource types for each environment
		```
		puppet generate types --environment xxx
		```
3. Restart the puppetserver service

## Release Notes

When releasing new versions we refer to [SemVer 1.0.0] for version numbers. All steps required when creating a new
release are described in [RELEASE.md](https://github.com/Icinga/puppet-icinga2/blob/master/RELEASE.md)

See also [CHANGELOG.md](https://github.com/Icinga/puppet-icinga2/blob/master/CHANGELOG.md)

[distributed monitoring]: http://docs.icinga.com/icinga2/latest/doc/module/icinga2/chapter/distributed-monitoring
[puppetlabs/stdlib]: https://github.com/puppetlabs/puppetlabs-stdlib
[puppetlabs/concat]: https://github.com/puppetlabs/puppetlabs-concat
[puppetlabs/apt]: https://github.com/puppetlabs/puppetlabs-apt
[puppetlabs/chocolatey]: https://github.com/puppetlabs/puppetlabs-chocolatey
[puppet/zypprepo]: https://forge.puppet.com/puppet/zypprepo
[puppetlabs/mysql]: https://github.com/puppetlabs/puppetlabs-mysql
[puppetlabs/puppetlabs-postgresql]: https://github.com/puppetlabs/puppetlabs-postgresql
[puppet-icinga2]: https://github.com/icinga/puppet-icinga2
[packages.icinga.com]: https://packages.icinga.com
[Chocolatey]: https://chocolatey.org
[SemVer 1.0.0]: http://semver.org/spec/v1.0.0.html

[CONTRIBUTING.md]: CONTRIBUTING.md
[TESTING.md]: TESTING.md
[RELEASE.md]: RELEASE.md
[CHANGELOG.md]: CHANGELOG.md
[AUTHORS]: AUTHORS
