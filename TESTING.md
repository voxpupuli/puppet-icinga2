# TESTING
# TESTING

## Prerequisites
Before starting any test, you should make sure you have installed the Puppet PDK and Bolt,
also Vagrant and VirtualBox have to be installed for acceptance tests.

Required gems are installed with `bundler`:
```
cd puppet-icinga2
pdk bundle install
```

Or just do an update:
```
cd puppet-icinga2
pdk bundle update
```

## Validation tests
Validation tests will check all manifests, templates and ruby files against syntax violations and style guides .

Run validation tests:
```
cd puppet-icinga2
pdk validate
```

## Unit tests
For unit testing we use [RSpec]. All classes, defined resource types and functions should have appropriate unit tests.

Run unit tests:
```
cd puppet-icinga2
pdk test unit
```

Or dedicated tests:
```
pdk test unit --tests=spec/classes/icinga2_spec.rb,spec/classes/api_spec.rb
```


## Acceptence tests
With integration tests this module is tested on multiple platforms to check the complete installation process. We define
these tests with [Beaker] and run them on VMs by using [Vagrant].

### Run tests
All available Beaker acceptance tests are listed in the `spec/acceptance` directory.

Run all integraion tests:
```
cd puppet-icinga2
pdk bundle exec rake beaker
```

Run integration tests for a single platform:
```
cd puppet-icinga2
pdk bundle exec rake beaker:centos-6-x64
```

To choose a specific Puppet version for your tests set the environment variable, e.g.
```
BEAKER_PUPPET_AGENT_VERSION="6.4.2"
```

Debugging: Does not destroy a virtual machine after a test fails is done by setting:

```
BEAKER_destroy=no
```

Logging in virtual machine, e.g.
```
cd puppet-icinga2
pdk bundle exec rake beaker:ssh:centos-6-x64
```

or in the default machine:

```
cd puppet-icinga2
pdk bundle exec rake beaker:ssh:default
```

