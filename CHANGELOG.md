#Changelog
- - -

###v0.6.2 (January 29th, 2015)

* Feature: [PR-58](https://github.com/Icinga/puppet-icinga2/pull/58) and [dev.icinga.org issue #8156](https://dev.icinga.org/issues/8156): Added the ability to use hashes directly in host `vars` parameters (instead of rendering hashes into a series of `vars.` lines in the rendered object file).
* Feature: [PR-63](https://github.com/Icinga/puppet-icinga2/pull/63) and [dev.icinga.org issue #7232](https://dev.icinga.org/issues/7232): Added an Endpoint object defined type.
* Feature: [PR-62](https://github.com/Icinga/puppet-icinga2/pull/62) and [dev.icinga.org issue #7230](https://dev.icinga.org/issues/7230): Added an IcingaStatusWriter object defined type.
* Feature: [PR-61](https://github.com/Icinga/puppet-icinga2/pull/61) and [dev.icinga.org issue #7229](https://dev.icinga.org/issues/7229): Added a FileLogger object defined type.
* Feature: [PR-70](https://github.com/Icinga/puppet-icinga2/pull/70) and [dev.icinga.org issue #8153](https://dev.icinga.org/issues/8153): Change validation of interval parameters.
* Feature: [PR-68](https://github.com/Icinga/puppet-icinga2/pull/68) and [dev.icinga.org issue #7346](https://dev.icinga.org/issues/7346): Added OS support for Red Hat.
* Feature: [dev.icinga.org issue #7231](https://dev.icinga.org/issues/7231): Added an `ApiListener` object defined type.
* Feature: [PR-76](https://github.com/Icinga/puppet-icinga2/pull/76) and [dev.icinga.org issue #8154](https://dev.icinga.org/issues/8154): Ensure ordering of hashes in ERB templates
* Bug: [PR-75](https://github.com/Icinga/puppet-icinga2/pull/75): Use `$ipaddress` as the default fact for IP addresses in `icinga2::object::host` definitions; `$ipaddress_eth0` won't work on systems with systemd that use consistent network device naming.
* Bug: [PR-74](https://github.com/Icinga/puppet-icinga2/pull/74): Remove the empty `icinga2` and `icinga2::obect` classes.
* Feature: [PR-77](https://github.com/Icinga/puppet-icinga2/pull/77/) and [dev.icinga.org issue #8239](https://dev.icinga.org/issues/8239): Added the ability to specify the contents of check plugins inline.
* Bug: [PR-81](https://github.com/Icinga/puppet-icinga2/pull/81): Fixed typo in the ERB template for `Notification` objects.
* Feature: [PR-83](https://github.com/Icinga/puppet-icinga2/pull/83): Added Red Hat support.
* Feature: [PR-60](https://github.com/Icinga/puppet-icinga2/pull/60) and [dev.icinga.org issue #7228](https://dev.icinga.org/issues/7228): Added a NotificationComponent object defined type.
* Feature: [PR-59](https://github.com/Icinga/puppet-icinga2/pull/59) and [dev.icinga.org issue #7227](https://dev.icinga.org/issues/7227): Added a CheckerComponent object defined type.
* Bug: [PR-88](https://github.com/Icinga/puppet-icinga2/pull/88): Fix unquoted string in the ERB template for apply objects that apply services to hosts.
* Feature: [PR-85](https://github.com/Icinga/puppet-icinga2/pull/85): Improve notifications of the NRPE daemon when config files or command definition files are changed.

###v0.6.1 (December 2nd, 2014)

* Feature: [PR-54](https://github.com/Icinga/puppet-icinga2/pull/54) and [dev.icinga.org issue #7225](https://dev.icinga.org/issues/7225): Added a CompatLogger object defined type.
* Feature: [PR-55](https://github.com/Icinga/puppet-icinga2/pull/55) and [dev.icinga.org issue #7226](https://dev.icinga.org/issues/7226): Added a CheckResultReader object defined type.
* Feature: Added a parameter that controls whether to purge unmanaged files in `/etc/icinga2/objects/`
* Feature: [dev.icinga.org issue #7856](https://dev.icinga.org/issues/7856): Added a parameter to each object defined type that can controle whether the Icinga 2 service gets refreshed; it can be set to false if the module is being used to just generate object definition files and isn't managing the service

###v0.6.0 (November 19th, 2014)

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
* Feature: [PR-35](https://github.com/Icinga/puppet-icinga2/pull/35): Added the ability to use a static file or custom ERB template for check command objects
* Feature: [PR-36](https://github.com/Icinga/puppet-icinga2/pull/36) and [dev.icinga.org issue #7216](https://dev.icinga.org/issues/7216): Added a [Notification](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-notification) object defined type.
* Feature: [PR-37](https://github.com/Icinga/puppet-icinga2/pull/37) and [dev.icinga.org issue #7217](https://dev.icinga.org/issues/7217): Added a [TimePeriod](http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-timeperiod) object defined type.
* Feature: [PR-39](https://github.com/Icinga/puppet-icinga2/pull/39) and [dev.icinga.org issue #7673](https://dev.icinga.org/issues/7673): Added the ability to purge non-Puppet managed NRPE config files.
* Feature: [PR-41](https://github.com/Icinga/puppet-icinga2/pull/41) and [dev.icinga.org issue #7674](https://dev.icinga.org/issues/7674): Added CentOS 5 server and NRPE client support.
* Fix: [PR-40](https://github.com/Icinga/puppet-icinga2/pull/40) and [dev.icinga.org issue #7675](https://dev.icinga.org/issues/7675): Escape single quotes around the `PGPASSWORD` environment variable so that single quotes can be used in the Postgres password
* Fix: [PR-42](https://github.com/Icinga/puppet-icinga2/pull/42): Fix anchor links in the README
* Feature: [PR-43](https://github.com/Icinga/puppet-icinga2/pull/43) and [dev.icinga.org issue #7676](https://dev.icinga.org/issues/7676): Added a defined type that can create objects that apply notifications to hosts
* Feature: [PR-44](https://github.com/Icinga/puppet-icinga2/pull/44) and [dev.icinga.org issue #7677](https://dev.icinga.org/issues/7677): Added a defined type that can create objects that apply notifications to services
* Feature: [PR-45](https://github.com/Icinga/puppet-icinga2/pull/45) and [dev.icinga.org issue #7220](https://dev.icinga.org/issues/7220): Added a defined type for PerfDataWriter objects
* Feature: [PR-47](https://github.com/Icinga/puppet-icinga2/pull/47) and [dev.icinga.org issue #7220](https://dev.icinga.org/issues/7220): Added a defined type for PerfDataWriter objects
* Feature: [PR-48](https://github.com/Icinga/puppet-icinga2/pull/48) and [dev.icinga.org issue #7222](https://dev.icinga.org/issues/7222): Added a defined type for LiveStatusListener objects
* Feature: [PR-49](https://github.com/Icinga/puppet-icinga2/pull/49) and [dev.icinga.org issue #7223](https://dev.icinga.org/issues/7223): Added a defined type for StatusDataWriter objects
* Feature: [PR-50](https://github.com/Icinga/puppet-icinga2/pull/50) and [dev.icinga.org issue #7224](https://dev.icinga.org/issues/7224): Added a defined type for ExternalCommandListener objects
* Fix: [dev.icinga.org issue #7715](https://dev.icinga.org/issues/7715): Allow trailing whitespace after some parameters so that the parameters following it don't get squashed onto the same line.
* Fix: [dev.icinga.org issue #7716](https://dev.icinga.org/issues/7716): Add a `target_file_ensure` parameter to each object file that gets passed through to the underlying file resource's `ensure =>` parameter.

###v0.5 (August 17th, 2014)

* Added a defined type for the `User` Icinga 2 object type

###v0.4 (August 2nd, 2014)

* Added object definitions for service objects and apply objects that
  apply services to hosts
* Added a `Modulefile` and a `metadata.json`

###v0.3 (July 26th, 2014)

* Added an object definition for the **host** object type
