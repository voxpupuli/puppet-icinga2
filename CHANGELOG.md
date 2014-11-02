#Changelog
- - -

###v0.5.1 (unreleased)

* Added a defined type for `ServiceGroup` objects
* Bug [#7189](https://dev.icinga.org/issues/7189): Fixed `liddir` typo in some manifests
* Bug [#7190](https://dev.icinga.org/issues/7190): Fully qualify uses of the `operatingsystem` Facter fact
* Added CentOS 7 support
* Feature [#7264](https://dev.icinga.org/issues/7264): Added Debian 7 support
* Feature: Added the ability to use the Debmon repository on Debian 7 systems: [PR-17](https://github.com/Icinga/puppet-icinga2/pull/17)
* Feature: Added the ability to make NRPE accept command arguments; turned off by default for obvious security reasons: [PR-22](https://github.com/Icinga/puppet-icinga2/pull/22)
* Feature: Added the ability to enable/disable Icinga 2 components via parameters: [PR-23](https://github.com/Icinga/puppet-icinga2/pull/23) 
* Feature: Added a `GraphiteWriter` object defined type: [PR-24](https://github.com/Icinga/puppet-icinga2/pull/24)
* Feature: Added the ability to upload or create custom check plugins on an Icinga 2 server (as opposed to just for NRPE clients): [PR-27](https://github.com/Icinga/puppet-icinga2/pull/27)
* Bug [#7308](https://dev.icinga.org/issues/7308): Allow multiple `assign_where` and `ignore_where` conditions
* Feature: [PR-28](https://github.com/Icinga/puppet-icinga2/pull/28) and issue [#7219](https://dev.icinga.org/issues/7219): Added Dependecy and Apply Dependency objects
* Feature: [PR-29](https://github.com/Icinga/puppet-icinga2/pull/29) and issue [#7213](https://dev.icinga.org/issues/7213): Added a CheckCommand object defined type
* Feature: [PR-32](https://github.com/Icinga/puppet-icinga2/pull/32): Added a NotificationCommand object.
* Feature: [PR-33](https://github.com/Icinga/puppet-icinga2/pull/33): Added an EventCommand object.

###v0.5 (August 17th, 2014)

* Added a defined type for the `User` Icinga 2 object type

###v0.4 (August 2nd, 2014)

* Added object definitions for service objects and apply objects that
  apply services to hosts
* Added a `Modulefile` and a `metadata.json`

###v0.3 (July 26th, 2014)

* Added an object definition for the **host** object type
