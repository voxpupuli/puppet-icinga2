# Change Log

## [v3.4.0](https://github.com/icinga/puppet-icinga2/tree/v3.4.0) (2022-06-27)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v3.3.1...v3.4.0)

**Implemented enhancements:**

- Tune icinga::icinga2\_attributes function call [\#704](https://github.com/Icinga/puppet-icinga2/issues/704)

## [v3.3.1](https://github.com/icinga/puppet-icinga2/tree/v3.3.1) (2022-06-08)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v3.3.0...v3.3.1)

**Fixed bugs:**

- Refactor Hepler Function uitils.attributes from puppet\_x context to puppet [\#702](https://github.com/Icinga/puppet-icinga2/issues/702)

## [v3.3.0](https://github.com/icinga/puppet-icinga2/tree/v3.3.0) (2022-05-30)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v3.2.2...v3.3.0)

**Implemented enhancements:**

- Finish refactoring function API 4.x [\#695](https://github.com/Icinga/puppet-icinga2/issues/695)

**Fixed bugs:**

- MySQL and MariaDB use different commandline options for TLS [\#700](https://github.com/Icinga/puppet-icinga2/issues/700)

**Closed issues:**

- Support Rocky and AlmaLinux [\#701](https://github.com/Icinga/puppet-icinga2/issues/701)

**Merged pull requests:**

- Enabling basic CI jobs on GitHub actions [\#698](https://github.com/Icinga/puppet-icinga2/pull/698) ([bastelfreak](https://github.com/bastelfreak))

## [v3.2.2](https://github.com/icinga/puppet-icinga2/tree/v3.2.2) (2022-01-18)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v3.2.1...v3.2.2)

**Fixed bugs:**

- feature:api: Allow TLSv1.3 as minimal TLS Version [\#696](https://github.com/Icinga/puppet-icinga2/pull/696) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Cleanup puppet-lint/regenerate REFERENCE.md [\#697](https://github.com/Icinga/puppet-icinga2/pull/697) ([bastelfreak](https://github.com/bastelfreak))

## [v3.2.1](https://github.com/icinga/puppet-icinga2/tree/v3.2.1) (2021-12-17)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v3.2.0...v3.2.1)

**Fixed bugs:**

- Constant in a sensitive data string are quoted [\#694](https://github.com/Icinga/puppet-icinga2/issues/694)
- added soft-dependency for puppetlabs-chocolatey [\#692](https://github.com/Icinga/puppet-icinga2/pull/692) ([zilchms](https://github.com/zilchms))
- Added known issues regarding environment bleed to documentation [\#693](https://github.com/Icinga/puppet-icinga2/pull/693) ([zilchms](https://github.com/zilchms))

**Closed issues:**

- Chocolatey missing in dependencies [\#691](https://github.com/Icinga/puppet-icinga2/issues/691)
- Please do not force-push in HEAD branch [\#690](https://github.com/Icinga/puppet-icinga2/issues/690)

## [v3.2.0](https://github.com/icinga/puppet-icinga2/tree/v3.2.0) (2021-10-23)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v3.1.3...v3.2.0)

**Implemented enhancements:**

- Accept Datatype Sensitive for Secrets [\#689](https://github.com/Icinga/puppet-icinga2/issues/689)
- Update testing doc to use pdk validate command [\#686](https://github.com/Icinga/puppet-icinga2/issues/686)
- Add new feature windowseventlog [\#684](https://github.com/Icinga/puppet-icinga2/issues/684)
- Add TLS support to feature idopgsql [\#683](https://github.com/Icinga/puppet-icinga2/issues/683)
- Add new data type for ido cleanups [\#682](https://github.com/Icinga/puppet-icinga2/issues/682)
- Add param connect\_timeout and TLS support to feature icingadb [\#681](https://github.com/Icinga/puppet-icinga2/issues/681)
- Add object type icingaapplication [\#680](https://github.com/Icinga/puppet-icinga2/issues/680)
- Add TLS support to feature gelf [\#679](https://github.com/Icinga/puppet-icinga2/issues/679)
- Add param insecure\_noverify to feature elasticsearch [\#678](https://github.com/Icinga/puppet-icinga2/issues/678)
- Add param connect\_timeout to feature api  [\#677](https://github.com/Icinga/puppet-icinga2/issues/677)
- Add missing params basic\_auth, ssl\_insecure\_noverify to feature influxdb [\#676](https://github.com/Icinga/puppet-icinga2/issues/676)
- Write new feature influxdb2 [\#675](https://github.com/Icinga/puppet-icinga2/issues/675)
- Use new hash style for facts [\#672](https://github.com/Icinga/puppet-icinga2/pull/672) ([cocker-cc](https://github.com/cocker-cc))

**Fixed bugs:**

- Keys are shown in Reports for features elasticsearch, idomysql and influxdb [\#687](https://github.com/Icinga/puppet-icinga2/issues/687)
- Cannot create MySQL database tables if enable\_ssl is set without any other ssl parameter [\#685](https://github.com/Icinga/puppet-icinga2/issues/685)
- Update to use pdk 2.x without fails [\#671](https://github.com/Icinga/puppet-icinga2/issues/671)

**Closed issues:**

- Check docu for deprecated parameters [\#673](https://github.com/Icinga/puppet-icinga2/issues/673)
- Using puppet PKI is unsupported on newer Puppetmaster [\#669](https://github.com/Icinga/puppet-icinga2/issues/669)

## [v3.1.3](https://github.com/icinga/puppet-icinga2/tree/v3.1.3) (2021-06-18)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v3.1.2...v3.1.3)

**Fixed bugs:**

- Attribute severity of object SyslogLogger no longer appears to be optional [\#666](https://github.com/Icinga/puppet-icinga2/issues/666)

## [v3.1.2](https://github.com/icinga/puppet-icinga2/tree/v3.1.2) (2021-05-12)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v3.1.1...v3.1.2)

**Fixed bugs:**

- logonaccount breaks service on puppet \< 6 [\#664](https://github.com/Icinga/puppet-icinga2/issues/664)

## [v3.1.1](https://github.com/icinga/puppet-icinga2/tree/v3.1.1) (2021-05-01)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v3.1.0...v3.1.1)

**Fixed bugs:**

- Add Integer to Icinga2::Interval type alias [\#663](https://github.com/Icinga/puppet-icinga2/pull/663) ([UiP9AV6Y](https://github.com/UiP9AV6Y))

**Closed issues:**

- Add Integer to Icinga2::Interval type alias [\#662](https://github.com/Icinga/puppet-icinga2/issues/662)

## [v3.1.0](https://github.com/icinga/puppet-icinga2/tree/v3.1.0) (2021-04-24)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- Add manage\_packages to replace manage\_packages [\#661](https://github.com/Icinga/puppet-icinga2/issues/661)
- Change owner of config file to icinga [\#660](https://github.com/Icinga/puppet-icinga2/issues/660)
- Add some words to reserve list  [\#659](https://github.com/Icinga/puppet-icinga2/issues/659)
- Allow to send cert req without ticket [\#653](https://github.com/Icinga/puppet-icinga2/issues/653)
- Add new parameter logon\_account [\#650](https://github.com/Icinga/puppet-icinga2/issues/650)
- Manage owner, group and permission of config files [\#648](https://github.com/Icinga/puppet-icinga2/issues/648)

**Fixed bugs:**

- Added Dictionary to reserved list [\#655](https://github.com/Icinga/puppet-icinga2/pull/655) ([hp197](https://github.com/hp197))
- Changed Integer parameters into Icinga2::Interval [\#654](https://github.com/Icinga/puppet-icinga2/pull/654) ([hp197](https://github.com/hp197))

**Closed issues:**

- Support conditional blocks inside objects [\#652](https://github.com/Icinga/puppet-icinga2/issues/652)

**Merged pull requests:**

- docs: Add comma to clustering example [\#646](https://github.com/Icinga/puppet-icinga2/pull/646) ([fionera](https://github.com/fionera))

## [v3.0.0](https://github.com/icinga/puppet-icinga2/tree/v3.0.0) (2020-10-13)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.4.1...v3.0.0)

**Implemented enhancements:**

- Replace class repo with new class from module icinga [\#613](https://github.com/Icinga/puppet-icinga2/issues/613)
- Add new param manage\_repos to replace manage\_repo in the future [\#643](https://github.com/Icinga/puppet-icinga2/pull/643) ([lbetz](https://github.com/lbetz))
- add-unit-tests-for-types [\#641](https://github.com/Icinga/puppet-icinga2/pull/641) ([lbetz](https://github.com/lbetz))
- fix \#623 change data types of all certificates and keys [\#640](https://github.com/Icinga/puppet-icinga2/pull/640) ([lbetz](https://github.com/lbetz))
- Accepts SHA1 and SHA256 fingerprint digests [\#632](https://github.com/Icinga/puppet-icinga2/pull/632) ([thorstenk](https://github.com/thorstenk))

**Fixed bugs:**

- Parameter icon\_image value must not be an absolute path [\#619](https://github.com/Icinga/puppet-icinga2/issues/619)
- Attribute parser breaks passwords [\#616](https://github.com/Icinga/puppet-icinga2/issues/616)
- setting env vars in \#618 do not work on Windows [\#642](https://github.com/Icinga/puppet-icinga2/pull/642) ([lbetz](https://github.com/lbetz))
- Missing parameters [\#630](https://github.com/Icinga/puppet-icinga2/pull/630) ([jas01](https://github.com/jas01))
- Add environment variables for icinga user and group to execs [\#618](https://github.com/Icinga/puppet-icinga2/pull/618) ([joernott](https://github.com/joernott))

**Closed issues:**

- Accept SHA256 fingerprints \(since Icinga2 2.12.0\) [\#631](https://github.com/Icinga/puppet-icinga2/issues/631)
- Setting up certificates does not work if user != icinga [\#617](https://github.com/Icinga/puppet-icinga2/issues/617)
- Add unit test for type logseverity [\#639](https://github.com/Icinga/puppet-icinga2/issues/639)
- Add unit test for type logfacility [\#638](https://github.com/Icinga/puppet-icinga2/issues/638)
- Add unit test for type interval [\#636](https://github.com/Icinga/puppet-icinga2/issues/636)
- Add unit test for type fingerprint  [\#635](https://github.com/Icinga/puppet-icinga2/issues/635)
- Change all TLS certificates and keys to datatype Stdlib::Base64 [\#623](https://github.com/Icinga/puppet-icinga2/issues/623)

**Merged pull requests:**

- correct fixtures and metadata [\#634](https://github.com/Icinga/puppet-icinga2/pull/634) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- changes to fix breaking tests [\#633](https://github.com/Icinga/puppet-icinga2/pull/633) ([SimonHoenscheid](https://github.com/SimonHoenscheid))

## [v2.4.1](https://github.com/icinga/puppet-icinga2/tree/v2.4.1) (2020-05-05)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.4.0...v2.4.1)

**Fixed bugs:**

- Lost pull request \#611 [\#615](https://github.com/Icinga/puppet-icinga2/issues/615)

## [v2.4.0](https://github.com/icinga/puppet-icinga2/tree/v2.4.0) (2020-04-24)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.3.4...v2.4.0)

**Implemented enhancements:**

- Add new icingadb feature  [\#612](https://github.com/Icinga/puppet-icinga2/issues/612)
- Rework examples and docs [\#423](https://github.com/Icinga/puppet-icinga2/issues/423)
- install icinga2-selinux  [\#602](https://github.com/Icinga/puppet-icinga2/pull/602) ([b3n4kh](https://github.com/b3n4kh))

**Fixed bugs:**

- Fix rubocop LineLength \# see https://rubocop.readthedocs.io/en/latest… [\#611](https://github.com/Icinga/puppet-icinga2/pull/611) ([thomas-merz](https://github.com/thomas-merz))

## [v2.3.4](https://github.com/icinga/puppet-icinga2/tree/v2.3.4) (2020-03-25)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.3.3...v2.3.4)

**Implemented enhancements:**

- Remove Support for some platforms [\#610](https://github.com/Icinga/puppet-icinga2/issues/610)
- Allow to parse a simple hash in strings [\#588](https://github.com/Icinga/puppet-icinga2/issues/588)
- Allow to parse an array in strings [\#587](https://github.com/Icinga/puppet-icinga2/issues/587)
- rework icinga2::repo class to a public class [\#609](https://github.com/Icinga/puppet-icinga2/pull/609) ([lbetz](https://github.com/lbetz))
- Influxdb can be reachable via any port [\#607](https://github.com/Icinga/puppet-icinga2/pull/607) ([b3n4kh](https://github.com/b3n4kh))
- Debian10 support [\#604](https://github.com/Icinga/puppet-icinga2/pull/604) ([lbetz](https://github.com/lbetz))
- Enhancement/allow to get attributes from function result [\#603](https://github.com/Icinga/puppet-icinga2/pull/603) ([lbetz](https://github.com/lbetz))
- RHEL 8 support [\#600](https://github.com/Icinga/puppet-icinga2/pull/600) ([lbetz](https://github.com/lbetz))
- Porting functions to the modern Puppet 4.x API [\#598](https://github.com/Icinga/puppet-icinga2/pull/598) ([binford2k](https://github.com/binford2k))

**Fixed bugs:**

- add missing EPEL repo on RedHat [\#599](https://github.com/Icinga/puppet-icinga2/pull/599) ([lbetz](https://github.com/lbetz))

## [v2.3.3](https://github.com/icinga/puppet-icinga2/tree/v2.3.3) (2020-03-16)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.3.2...v2.3.3)

**Fixed bugs:**

- Private keys: no diff, no backup [\#606](https://github.com/Icinga/puppet-icinga2/pull/606) ([Thomas-Gelf](https://github.com/Thomas-Gelf))

**Closed issues:**

- REOPEN: does not handle database host correctly [\#572](https://github.com/Icinga/puppet-icinga2/issues/572)

## [v2.3.2](https://github.com/icinga/puppet-icinga2/tree/v2.3.2) (2019-12-18)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.3.1...v2.3.2)

**Fixed bugs:**

- Missing default in case statement for pki in feature::api [\#596](https://github.com/Icinga/puppet-icinga2/pull/596) ([lbetz](https://github.com/lbetz))

## [v2.3.1](https://github.com/icinga/puppet-icinga2/tree/v2.3.1) (2019-12-17)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.3.0...v2.3.1)

**Fixed bugs:**

- Add Backports Repo on Debian [\#595](https://github.com/Icinga/puppet-icinga2/issues/595)
- Rework and correct documentation of Clustering Icinga 2 [\#584](https://github.com/Icinga/puppet-icinga2/issues/584)

**Closed issues:**

- Cannot complete agent / client add via puppet [\#585](https://github.com/Icinga/puppet-icinga2/issues/585)

## [v2.3.0](https://github.com/icinga/puppet-icinga2/tree/v2.3.0) (2019-07-26)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.2.0...v2.3.0)

**Implemented enhancements:**

- Add new attributes to feature api [\#581](https://github.com/Icinga/puppet-icinga2/issues/581)
- Add new constants and keywords [\#579](https://github.com/Icinga/puppet-icinga2/issues/579)
- Add info of new constant MaxConcurrentChecks to feature checker [\#578](https://github.com/Icinga/puppet-icinga2/issues/578)
- New HA-aware Features [\#576](https://github.com/Icinga/puppet-icinga2/issues/576)

**Fixed bugs:**

- Remove OpenBSD from official support list [\#583](https://github.com/Icinga/puppet-icinga2/issues/583)
- Add missed flapping attributes to objects host and service [\#580](https://github.com/Icinga/puppet-icinga2/issues/580)

## [v2.2.0](https://github.com/icinga/puppet-icinga2/tree/v2.2.0) (2019-07-14)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.1.1...v2.2.0)

**Implemented enhancements:**

- Remove deprecated data\_provider [\#568](https://github.com/Icinga/puppet-icinga2/issues/568)
- Convert to pdk [\#528](https://github.com/Icinga/puppet-icinga2/issues/528)
- add new type for custom attributes to support also arrays [\#574](https://github.com/Icinga/puppet-icinga2/pull/574) ([lbetz](https://github.com/lbetz))
- add feature to merge arrays and hashes by the parser [\#573](https://github.com/Icinga/puppet-icinga2/pull/573) ([lbetz](https://github.com/lbetz))
- Extent parser to build += assignments [\#569](https://github.com/Icinga/puppet-icinga2/pull/569) ([lbetz](https://github.com/lbetz))
- Add constants for Gentoo AMD64 [\#567](https://github.com/Icinga/puppet-icinga2/pull/567) ([ekohl](https://github.com/ekohl))
- convert module to PDK [\#564](https://github.com/Icinga/puppet-icinga2/pull/564) ([SimonHoenscheid](https://github.com/SimonHoenscheid))

**Fixed bugs:**

- Downgrade restore of vars [\#575](https://github.com/Icinga/puppet-icinga2/issues/575)
- Pin versions for travis of required puppet modules for puppet 4 [\#570](https://github.com/Icinga/puppet-icinga2/issues/570)
- fix \#570 Pin versions for travis of required puppet modules for puppet [\#571](https://github.com/Icinga/puppet-icinga2/pull/571) ([lbetz](https://github.com/lbetz))
- Fix Puppet4 build [\#565](https://github.com/Icinga/puppet-icinga2/pull/565) ([SimonHoenscheid](https://github.com/SimonHoenscheid))

**Closed issues:**

- Allow to specify both vars + config as custom vars using hash [\#566](https://github.com/Icinga/puppet-icinga2/issues/566)

## [v2.1.1](https://github.com/icinga/puppet-icinga2/tree/v2.1.1) (2019-05-24)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.1.0...v2.1.1)

**Implemented enhancements:**

- Rework travis batch and enable check for puppet 6 [\#560](https://github.com/Icinga/puppet-icinga2/issues/560)

**Fixed bugs:**

- Fix and update TESTING documentation [\#561](https://github.com/Icinga/puppet-icinga2/issues/561)
- Set default of all optional parameters in globals to undef [\#559](https://github.com/Icinga/puppet-icinga2/issues/559)
- Fact kernel on windows has to be lower case [\#556](https://github.com/Icinga/puppet-icinga2/issues/556)
- Fix some lint issues in api, idomysql, globals [\#553](https://github.com/Icinga/puppet-icinga2/issues/553)
- Fix tests for Puppet 6 [\#550](https://github.com/Icinga/puppet-icinga2/issues/550)
- Fix spec tests of icinga objects [\#549](https://github.com/Icinga/puppet-icinga2/issues/549)
- Fix spec tests for class pki [\#548](https://github.com/Icinga/puppet-icinga2/issues/548)
- Fix spec tests for feature idopgsql [\#547](https://github.com/Icinga/puppet-icinga2/issues/547)
- Fix spec tests for feature idomysql [\#546](https://github.com/Icinga/puppet-icinga2/issues/546)
- Fix spec test of feature api [\#545](https://github.com/Icinga/puppet-icinga2/issues/545)
- fix typo in README.md [\#544](https://github.com/Icinga/puppet-icinga2/pull/544) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Icinga2 custom config dir \(not /etc/...\) [\#543](https://github.com/Icinga/puppet-icinga2/issues/543)

## [v2.1.0](https://github.com/icinga/puppet-icinga2/tree/v2.1.0) (2019-04-30)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.0.2...v2.1.0)

**Implemented enhancements:**

- The puppet module does not validate the master's X.509 certificate [\#360](https://github.com/Icinga/puppet-icinga2/issues/360)
- Set the object file owner to root [\#533](https://github.com/Icinga/puppet-icinga2/pull/533) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Path on Windows does not work [\#542](https://github.com/Icinga/puppet-icinga2/issues/542)
- Documentation of default values for InfluxWriter is outdated [\#537](https://github.com/Icinga/puppet-icinga2/issues/537)
- The puppet module does not validate the master's X.509 certificate [\#360](https://github.com/Icinga/puppet-icinga2/issues/360)

## [v2.0.2](https://github.com/icinga/puppet-icinga2/tree/v2.0.2) (2019-03-14)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.0.1...v2.0.2)

**Implemented enhancements:**

- add initial support for OpenBSD [\#539](https://github.com/Icinga/puppet-icinga2/pull/539) ([trefzer](https://github.com/trefzer))
- Add values for the Gentoo family [\#534](https://github.com/Icinga/puppet-icinga2/pull/534) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Unable to define endpoint with custom port number [\#530](https://github.com/Icinga/puppet-icinga2/issues/530)

**Merged pull requests:**

- fix typos in documentation [\#529](https://github.com/Icinga/puppet-icinga2/pull/529) ([aschaber1](https://github.com/aschaber1))

## [v2.0.1](https://github.com/icinga/puppet-icinga2/tree/v2.0.1) (2019-02-12)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v2.0.0...v2.0.1)

**Fixed bugs:**

- Syntax error custom data type logfacility [\#527](https://github.com/Icinga/puppet-icinga2/issues/527)

## [v2.0.0](https://github.com/icinga/puppet-icinga2/tree/v2.0.0) (2019-02-12)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.4.0...v2.0.0)

**Implemented enhancements:**

- Set default of host to localhost for feature idopgsql [\#526](https://github.com/Icinga/puppet-icinga2/issues/526)
- Add an example for idomysql via SSL [\#524](https://github.com/Icinga/puppet-icinga2/issues/524)
- Add some custom data types [\#521](https://github.com/Icinga/puppet-icinga2/issues/521)
- Remove repos info to data in module hiera [\#519](https://github.com/Icinga/puppet-icinga2/issues/519)
- Puppet 6 Support [\#505](https://github.com/Icinga/puppet-icinga2/issues/505)
- API change to icinga2 CA as default  [\#495](https://github.com/Icinga/puppet-icinga2/issues/495)
- Path to key, cert and cacert are not configurable anymore [\#493](https://github.com/Icinga/puppet-icinga2/issues/493)
- Move to module data [\#490](https://github.com/Icinga/puppet-icinga2/issues/490)
- Remove define resource compatlogger [\#488](https://github.com/Icinga/puppet-icinga2/issues/488)
- Rework rspec tests [\#486](https://github.com/Icinga/puppet-icinga2/issues/486)
- Remove include of params from object class [\#485](https://github.com/Icinga/puppet-icinga2/issues/485)
- Change location of the CA and the cert [\#484](https://github.com/Icinga/puppet-icinga2/issues/484)
- Change storing of certificate for influxdb feature [\#483](https://github.com/Icinga/puppet-icinga2/issues/483)
- Change storing of certificate for elasticsearch feature  [\#482](https://github.com/Icinga/puppet-icinga2/issues/482)
- Remove management of repository.d in install.pp [\#479](https://github.com/Icinga/puppet-icinga2/issues/479)
- Default of parameter import of icinga2::object::notificationcommand is outdated [\#478](https://github.com/Icinga/puppet-icinga2/issues/478)
- Rework dependency list of modules [\#476](https://github.com/Icinga/puppet-icinga2/issues/476)
- Remove default apply\_target from service object [\#475](https://github.com/Icinga/puppet-icinga2/issues/475)
- Default of parameter import of icinga2::object::eventcommand is outdated [\#468](https://github.com/Icinga/puppet-icinga2/issues/468)
- Default of parameter import of icinga2::object::checkcommand is outdated [\#467](https://github.com/Icinga/puppet-icinga2/issues/467)
- Rework param data types of icinga2::feature::syslog [\#465](https://github.com/Icinga/puppet-icinga2/issues/465)
- Rework param data types of icinga2::feature::statusdata [\#464](https://github.com/Icinga/puppet-icinga2/issues/464)
- Rework param data types of icinga2::feature::perfdata [\#463](https://github.com/Icinga/puppet-icinga2/issues/463)
- Rework param data types of icinga2::feature::opentsdb [\#462](https://github.com/Icinga/puppet-icinga2/issues/462)
- Rework param data types of icinga2::feature::livestatus [\#461](https://github.com/Icinga/puppet-icinga2/issues/461)
- Rework param data types of icinga2::feature::influxdb [\#460](https://github.com/Icinga/puppet-icinga2/issues/460)
- Rework param data types of icinga2::feature::idopgsql [\#459](https://github.com/Icinga/puppet-icinga2/issues/459)
- Rework param data types of icinga2::feature::idomysql [\#458](https://github.com/Icinga/puppet-icinga2/issues/458)
- Rework param data types of icinga2::feature::graphite [\#457](https://github.com/Icinga/puppet-icinga2/issues/457)
- Rework param datatypes of icinga2::feature::gelf [\#456](https://github.com/Icinga/puppet-icinga2/issues/456)
- Rework param data types of icinga2::feature::elasticsearch [\#455](https://github.com/Icinga/puppet-icinga2/issues/455)
- Rework param datatype of icinga2::feature::compatlog [\#454](https://github.com/Icinga/puppet-icinga2/issues/454)
- Rework param data types of icinga2::feature::api [\#453](https://github.com/Icinga/puppet-icinga2/issues/453)
- Remove icinga2::pki::ca  [\#452](https://github.com/Icinga/puppet-icinga2/issues/452)
- Add crl\_path to feature api [\#432](https://github.com/Icinga/puppet-icinga2/issues/432)
- Import IDO DB schema for mysql over SSL isn't supported [\#414](https://github.com/Icinga/puppet-icinga2/issues/414)
- Updated to support puppetlabs/chocolatey 3.0.0? [\#363](https://github.com/Icinga/puppet-icinga2/issues/363)
- Use beaker for acceptence tests and replace boxes with bento [\#356](https://github.com/Icinga/puppet-icinga2/issues/356)
- Separate unit tests for functions [\#355](https://github.com/Icinga/puppet-icinga2/issues/355)
- Add IDO PostreSQL integration tests [\#278](https://github.com/Icinga/puppet-icinga2/issues/278)
- Replace deprecated stdlib functions [\#275](https://github.com/Icinga/puppet-icinga2/issues/275)
- Add elasticsearch feature [\#418](https://github.com/Icinga/puppet-icinga2/pull/418) ([dnsmichi](https://github.com/dnsmichi))

**Fixed bugs:**

- Cannot use localhost as host in feature idomysql [\#525](https://github.com/Icinga/puppet-icinga2/issues/525)
- IdoMysqlConnection: Optional parameters are forced by module [\#523](https://github.com/Icinga/puppet-icinga2/issues/523)
- ElasticsearchWriter: Optional parameters are forced by module [\#522](https://github.com/Icinga/puppet-icinga2/issues/522)
- fix unit test functions/attributes\_spec.rb [\#517](https://github.com/Icinga/puppet-icinga2/issues/517)
- rework unit test for objects\_spec.rb  [\#516](https://github.com/Icinga/puppet-icinga2/issues/516)
- Evaluation Error: Error while evaluating a Function Call, Class\[Icinga2::Globals\]: [\#504](https://github.com/Icinga/puppet-icinga2/issues/504)
- Incomplete list of supported operatingssystems  [\#501](https://github.com/Icinga/puppet-icinga2/issues/501)
- pki::ca require dependency to config class [\#498](https://github.com/Icinga/puppet-icinga2/issues/498)
- Unknown variable \_ssl\_key [\#497](https://github.com/Icinga/puppet-icinga2/issues/497)
- Unknown variable ido\_mysql\_package on debian [\#496](https://github.com/Icinga/puppet-icinga2/issues/496)
- Missing documentation of class icinga::globals [\#494](https://github.com/Icinga/puppet-icinga2/issues/494)
- InfluxWriter: Optional parameters are forced by module [\#491](https://github.com/Icinga/puppet-icinga2/issues/491)
- Duplicate key HOSTDISPLAYNAME in example\_config.pp [\#480](https://github.com/Icinga/puppet-icinga2/issues/480)
- Attribute vars of all object types can be also a string [\#474](https://github.com/Icinga/puppet-icinga2/issues/474)
- Attribute vars of object type service can be also a string [\#473](https://github.com/Icinga/puppet-icinga2/issues/473)
- Parameter prefix of icinga2::object::service is not a boolean only [\#472](https://github.com/Icinga/puppet-icinga2/issues/472)
- Parameter prefix of icinga2::object::notification is not a boolean only [\#470](https://github.com/Icinga/puppet-icinga2/issues/470)
- Parameter host\_name icinga2::object::host is not optional [\#469](https://github.com/Icinga/puppet-icinga2/issues/469)
- Debian 9/Stretch support [\#466](https://github.com/Icinga/puppet-icinga2/issues/466)
- Parameter order of concat resource has to be a string [\#451](https://github.com/Icinga/puppet-icinga2/issues/451)
- Incorrect example for icinga2::object::apiuser [\#448](https://github.com/Icinga/puppet-icinga2/issues/448)
- Using a reference to icinga variable in icinga2::object::notification $interval [\#443](https://github.com/Icinga/puppet-icinga2/issues/443)
- Replace gpgkey handling for suse [\#397](https://github.com/Icinga/puppet-icinga2/issues/397)
- Fix syntax error [\#487](https://github.com/Icinga/puppet-icinga2/pull/487) ([paladox](https://github.com/paladox))

**Closed issues:**

- OS facts clutter with recent ruby versions in spec tests [\#518](https://github.com/Icinga/puppet-icinga2/issues/518)
- Deprecated features in 2.9: statusdata & compatlog [\#481](https://github.com/Icinga/puppet-icinga2/issues/481)

**Merged pull requests:**

- example of check\_mysql and check\_mysql\_health [\#387](https://github.com/Icinga/puppet-icinga2/pull/387) ([rowanruseler](https://github.com/rowanruseler))
- Replace validate\_\* with data types [\#350](https://github.com/Icinga/puppet-icinga2/pull/350) ([baurmatt](https://github.com/baurmatt))

## [v1.4.0](https://github.com/icinga/puppet-icinga2/tree/v1.4.0) (2019-01-18)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.3.7...v1.4.0)

**Implemented enhancements:**

- Feature Request: Allow to pass ticket\_id to API Feature [\#512](https://github.com/Icinga/puppet-icinga2/issues/512)
- New parameter 'ticket\_id' for API feature [\#514](https://github.com/Icinga/puppet-icinga2/pull/514) ([benningm](https://github.com/benningm))
- Facility configuration for Syslog + New severity for syslog [\#502](https://github.com/Icinga/puppet-icinga2/pull/502) ([liveder](https://github.com/liveder))
- Add multiline support for lambda functions and unparsed strings. [\#422](https://github.com/Icinga/puppet-icinga2/pull/422) ([n00by](https://github.com/n00by))

**Fixed bugs:**

- Fix init\_spec test [\#515](https://github.com/Icinga/puppet-icinga2/issues/515)
- Problem with ownership NETWORK on non-english Windows  [\#511](https://github.com/Icinga/puppet-icinga2/issues/511)
- API configuration on Windows systems [\#510](https://github.com/Icinga/puppet-icinga2/issues/510)
- Allow dots in data structures of object attributes  [\#509](https://github.com/Icinga/puppet-icinga2/issues/509)
- Some comments when using on Windows [\#499](https://github.com/Icinga/puppet-icinga2/issues/499)
- Windows : owner and group [\#437](https://github.com/Icinga/puppet-icinga2/issues/437)
- Quote and escape string values correctly [\#471](https://github.com/Icinga/puppet-icinga2/pull/471) ([marcofl](https://github.com/marcofl))
- Depend on Apt::Update instead of Apt::Source [\#446](https://github.com/Icinga/puppet-icinga2/pull/446) ([jkroepke](https://github.com/jkroepke))

**Merged pull requests:**

- Fixed markup error in Readme.md [\#508](https://github.com/Icinga/puppet-icinga2/pull/508) ([dagobert](https://github.com/dagobert))
- Quoting mistake in doc [\#507](https://github.com/Icinga/puppet-icinga2/pull/507) ([dagobert](https://github.com/dagobert))
- Fixed requirements [\#506](https://github.com/Icinga/puppet-icinga2/pull/506) ([dagobert](https://github.com/dagobert))

## [v1.3.7](https://github.com/icinga/puppet-icinga2/tree/v1.3.7) (2018-11-29)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.3.6...v1.3.7)

**Fixed bugs:**

- Attribute prefix for services is not documented [\#430](https://github.com/Icinga/puppet-icinga2/issues/430)
- ido-pgsql db import fails on debian [\#500](https://github.com/Icinga/puppet-icinga2/issues/500)

## [v1.3.6](https://github.com/icinga/puppet-icinga2/tree/v1.3.6) (2018-04-25)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.3.5...v1.3.6)

**Implemented enhancements:**

- Add support for SLC6 Linux [\#441](https://github.com/Icinga/puppet-icinga2/pull/441) ([HristoMohamed](https://github.com/HristoMohamed))
- Support manage\_repo on XenServer [\#436](https://github.com/Icinga/puppet-icinga2/pull/436) ([jcharaoui](https://github.com/jcharaoui))

**Fixed bugs:**

- Changes on concat resource for objects does not trigger a refresh on puppet3 [\#434](https://github.com/Icinga/puppet-icinga2/issues/434)
- don't quote null  [\#433](https://github.com/Icinga/puppet-icinga2/issues/433)

**Merged pull requests:**

- Bug/do not quote null 433 [\#435](https://github.com/Icinga/puppet-icinga2/pull/435) ([lbetz](https://github.com/lbetz))

## [v1.3.5](https://github.com/icinga/puppet-icinga2/tree/v1.3.5) (2018-01-24)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.3.4...v1.3.5)

**Implemented enhancements:**

- icinga2 binary is wrong on rhel5 [\#409](https://github.com/Icinga/puppet-icinga2/issues/409)
- Add feature Elasticsearch [\#408](https://github.com/Icinga/puppet-icinga2/issues/408)
- Add feature elasticsearch [\#399](https://github.com/Icinga/puppet-icinga2/issues/399)
- Added cloudlinux to supported operating systems. Is nearly identical … [\#424](https://github.com/Icinga/puppet-icinga2/pull/424) ([thekoma](https://github.com/thekoma))

**Fixed bugs:**

- Setting up icinga2 with a different port than default for idodb leads to an error  [\#411](https://github.com/Icinga/puppet-icinga2/issues/411)
- fix \#411 Setting up Icinga 2 with a different port than default for i… [\#413](https://github.com/Icinga/puppet-icinga2/pull/413) ([lbetz](https://github.com/lbetz))
- fix for repository.d directory on master-systems [\#412](https://github.com/Icinga/puppet-icinga2/pull/412) ([matthiasritter](https://github.com/matthiasritter))

**Merged pull requests:**

- trivial copy edits [\#420](https://github.com/Icinga/puppet-icinga2/pull/420) ([wkalt](https://github.com/wkalt))
- Fix confd example path [\#417](https://github.com/Icinga/puppet-icinga2/pull/417) ([dnsmichi](https://github.com/dnsmichi))
- fix \#409 icinga2 binary is wrong on rhel5 [\#410](https://github.com/Icinga/puppet-icinga2/pull/410) ([lbetz](https://github.com/lbetz))

## [v1.3.4](https://github.com/icinga/puppet-icinga2/tree/v1.3.4) (2017-11-22)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.3.3...v1.3.4)

**Fixed bugs:**

- repository.d missing after install [\#403](https://github.com/Icinga/puppet-icinga2/issues/403)
- Boolean 'false' custom variables do not appear in configuration [\#400](https://github.com/Icinga/puppet-icinga2/issues/400)
- $bin\_dir path incorrect for FreeBSD in params.pp [\#396](https://github.com/Icinga/puppet-icinga2/issues/396)

**Closed issues:**

- missing /etc/pki directory [\#393](https://github.com/Icinga/puppet-icinga2/issues/393)

**Merged pull requests:**

- fix \#400 boolean false custom variables do not appear in configuration [\#406](https://github.com/Icinga/puppet-icinga2/pull/406) ([lbetz](https://github.com/lbetz))
- Bug/repository.d missing after install 403 [\#404](https://github.com/Icinga/puppet-icinga2/pull/404) ([lbetz](https://github.com/lbetz))
- fix \#396 incorrect bin\_dir path for FreeBSD [\#401](https://github.com/Icinga/puppet-icinga2/pull/401) ([lbetz](https://github.com/lbetz))

## [v1.3.3](https://github.com/icinga/puppet-icinga2/tree/v1.3.3) (2017-10-24)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.3.2...v1.3.3)

**Fixed bugs:**

- Icinga2 binary not found on Redhat/Centos 6 family [\#390](https://github.com/Icinga/puppet-icinga2/issues/390)

**Merged pull requests:**

- fix \#390 icinga2 binary not found on rhel6 [\#391](https://github.com/Icinga/puppet-icinga2/pull/391) ([lbetz](https://github.com/lbetz))

## [v1.3.2](https://github.com/icinga/puppet-icinga2/tree/v1.3.2) (2017-10-11)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.3.1...v1.3.2)

**Fixed bugs:**

- SLES should use service pack repository [\#386](https://github.com/Icinga/puppet-icinga2/issues/386)

## [v1.3.1](https://github.com/icinga/puppet-icinga2/tree/v1.3.1) (2017-10-05)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.3.0...v1.3.1)

**Implemented enhancements:**

- Fix small typos [\#358](https://github.com/Icinga/puppet-icinga2/issues/358)
- Review and update puppetlabs-concat dependency [\#351](https://github.com/Icinga/puppet-icinga2/issues/351)
- Documentation to set up mysql grants is incorrect. [\#347](https://github.com/Icinga/puppet-icinga2/issues/347)
- Check attributes of all objects [\#219](https://github.com/Icinga/puppet-icinga2/issues/219)
- Align documentation for duplicate repository [\#353](https://github.com/Icinga/puppet-icinga2/issues/353)
- Update documentation about += operator [\#352](https://github.com/Icinga/puppet-icinga2/issues/352)
- Example and documentation for syncing hiera data to icinga objects [\#342](https://github.com/Icinga/puppet-icinga2/issues/342)
- Add owner-, groupship and permissions to file resources [\#291](https://github.com/Icinga/puppet-icinga2/issues/291)
- Support Puppet 5 and test it in travis [\#330](https://github.com/Icinga/puppet-icinga2/pull/330) ([lazyfrosch](https://github.com/lazyfrosch))

**Fixed bugs:**

- Error: Could not find command 'icinga2' on SLES-11 [\#374](https://github.com/Icinga/puppet-icinga2/issues/374)
- When passing non-fqdn name for the NodeName the certificate is still generated with cn set to fqdn [\#328](https://github.com/Icinga/puppet-icinga2/issues/328)
- Install package before creating config files [\#378](https://github.com/Icinga/puppet-icinga2/issues/378)
- Icinga2 binary not found on Debian and FreeBSD [\#371](https://github.com/Icinga/puppet-icinga2/issues/371)
- Could not find command Icinga2 on windows [\#367](https://github.com/Icinga/puppet-icinga2/issues/367)
- Error: Parameter user failed on Exec\[icinga2 pki create key\]: Unable to execute commands as other users on Windows at manifestsfeature/api.pp:317 [\#366](https://github.com/Icinga/puppet-icinga2/issues/366)
- Unit tests broken for facter 2.5 [\#338](https://github.com/Icinga/puppet-icinga2/issues/338)
- protection of private classes is wrong [\#333](https://github.com/Icinga/puppet-icinga2/issues/333)
- ticketsalt only should be stored on ca nodes [\#325](https://github.com/Icinga/puppet-icinga2/issues/325)
- key and cert permissions on windows [\#282](https://github.com/Icinga/puppet-icinga2/issues/282)

**Closed issues:**

- Implement conditional statements/loops parameter for icinga2::object::\* [\#354](https://github.com/Icinga/puppet-icinga2/issues/354)
- document manage\_package with manage\_repo [\#381](https://github.com/Icinga/puppet-icinga2/issues/381)

**Merged pull requests:**

- Remove soft depedencies from metadata.json [\#385](https://github.com/Icinga/puppet-icinga2/pull/385) ([noqqe](https://github.com/noqqe))
- fix \#378 install package before creating config files [\#380](https://github.com/Icinga/puppet-icinga2/pull/380) ([lbetz](https://github.com/lbetz))
- fix \#371, add binary path to icinga2 for Debian, SuSE and FreeBSD [\#372](https://github.com/Icinga/puppet-icinga2/pull/372) ([lbetz](https://github.com/lbetz))
- fix \#325, ticket\_salt ist stored to api.conf only if pki = none|ca [\#370](https://github.com/Icinga/puppet-icinga2/pull/370) ([lbetz](https://github.com/lbetz))
- fix \#367, \#366 and remove management of conf\_dir [\#369](https://github.com/Icinga/puppet-icinga2/pull/369) ([lbetz](https://github.com/lbetz))
- Examples: Fix notification commands for 2.7 [\#368](https://github.com/Icinga/puppet-icinga2/pull/368) ([dnsmichi](https://github.com/dnsmichi))
- Fixed typos [\#357](https://github.com/Icinga/puppet-icinga2/pull/357) ([rgevaert](https://github.com/rgevaert))
- fix \#338 update facterdb dependency to 0.3.12 [\#349](https://github.com/Icinga/puppet-icinga2/pull/349) ([lbetz](https://github.com/lbetz))
- Update protection of private classes from direct use [\#336](https://github.com/Icinga/puppet-icinga2/pull/336) ([lbetz](https://github.com/lbetz))
- Fix dependency issues with apt repository [\#334](https://github.com/Icinga/puppet-icinga2/pull/334) ([baurmatt](https://github.com/baurmatt))
- Update documentation examples for mysql::db [\#346](https://github.com/Icinga/puppet-icinga2/pull/346) ([rgevaert](https://github.com/rgevaert))

## [v1.3.0](https://github.com/icinga/puppet-icinga2/tree/v1.3.0) (2017-06-26)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.2.1...v1.3.0)

**Implemented enhancements:**

- README.md: clarify meaning of `confd=\>true` [\#314](https://github.com/Icinga/puppet-icinga2/pull/314) ([sourcejedi](https://github.com/sourcejedi))

**Fixed bugs:**

- PR \#293 does not work correctly [\#304](https://github.com/Icinga/puppet-icinga2/issues/304)
- fix certname in api and pki::ca class to constant NodeName [\#319](https://github.com/Icinga/puppet-icinga2/issues/319)
- ordering-api-with-pki-after-package [\#311](https://github.com/Icinga/puppet-icinga2/issues/311)
- Only last empty hash is stored [\#308](https://github.com/Icinga/puppet-icinga2/issues/308)
- module requirements broken. [\#305](https://github.com/Icinga/puppet-icinga2/issues/305)
- ido-mysql install fails while using official icinga packages [\#302](https://github.com/Icinga/puppet-icinga2/issues/302)
- concat resource with tag does not trigger a refresh [\#300](https://github.com/Icinga/puppet-icinga2/issues/300)
- ido packages are managed before repository [\#299](https://github.com/Icinga/puppet-icinga2/issues/299)
- RSpec Puppetlabs modules incompatible to Puppet 3 [\#286](https://github.com/Icinga/puppet-icinga2/issues/286)
- Disable feature checker doesn't trigger a refresh [\#285](https://github.com/Icinga/puppet-icinga2/issues/285)
- SLES Lib directory is not architecture specific [\#283](https://github.com/Icinga/puppet-icinga2/issues/283)
- Fix examples/init\_confd.pp [\#313](https://github.com/Icinga/puppet-icinga2/pull/313) ([sourcejedi](https://github.com/sourcejedi))
- README.md: fix typo `notifiy` [\#312](https://github.com/Icinga/puppet-icinga2/pull/312) ([sourcejedi](https://github.com/sourcejedi))
- debian::dbconfig: Move to autoload location and lint it [\#322](https://github.com/Icinga/puppet-icinga2/pull/322) ([lazyfrosch](https://github.com/lazyfrosch))

**Merged pull requests:**

- Update checker.pp, arrow alignment [\#316](https://github.com/Icinga/puppet-icinga2/pull/316) ([rowanruseler](https://github.com/rowanruseler))
- Update fragment.pp [\#315](https://github.com/Icinga/puppet-icinga2/pull/315) ([rowanruseler](https://github.com/rowanruseler))
- Add GitHub issue template [\#310](https://github.com/Icinga/puppet-icinga2/pull/310) ([dnsmichi](https://github.com/dnsmichi))
- Specify older fixtures for Puppet 3 tests [\#287](https://github.com/Icinga/puppet-icinga2/pull/287) ([lazyfrosch](https://github.com/lazyfrosch))
- Update SLES lib directory [\#284](https://github.com/Icinga/puppet-icinga2/pull/284) ([dgoetz](https://github.com/dgoetz))
- Replace darin/zypprepo with puppet/zypprepo [\#306](https://github.com/Icinga/puppet-icinga2/pull/306) ([noqqe](https://github.com/noqqe))
- Remove deprecated apt options [\#293](https://github.com/Icinga/puppet-icinga2/pull/293) ([jkroepke](https://github.com/jkroepke))

## [v1.2.1](https://github.com/icinga/puppet-icinga2/tree/v1.2.1) (2017-04-12)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.2.0...v1.2.1)

**Implemented enhancements:**

- Create integration tests for MySQL IDO feature [\#207](https://github.com/Icinga/puppet-icinga2/issues/207)
- Add condition to be sure that icinga2 base class is parsed first [\#280](https://github.com/Icinga/puppet-icinga2/issues/280)
- Remove checker feature from examples for agents [\#279](https://github.com/Icinga/puppet-icinga2/issues/279)
- Remove sles-12 reference from Gemfile [\#274](https://github.com/Icinga/puppet-icinga2/issues/274)
- Add tests for custom facts [\#273](https://github.com/Icinga/puppet-icinga2/issues/273)
- Create integration tests for API feature [\#206](https://github.com/Icinga/puppet-icinga2/issues/206)

**Fixed bugs:**

- Fix schema import for FreeBSD [\#277](https://github.com/Icinga/puppet-icinga2/issues/277)
- Fix ::icinga2::pki::ca for FreeBSD [\#276](https://github.com/Icinga/puppet-icinga2/issues/276)
- Fix arrow\_on\_right\_operand\_line lint [\#272](https://github.com/Icinga/puppet-icinga2/issues/272)
- case statement without default in feature api [\#266](https://github.com/Icinga/puppet-icinga2/issues/266)
- case statement without default in idomysql feature [\#265](https://github.com/Icinga/puppet-icinga2/issues/265)
- case statement without default in influx feature [\#264](https://github.com/Icinga/puppet-icinga2/issues/264)
- Fix strings containing only a variable [\#263](https://github.com/Icinga/puppet-icinga2/issues/263)
- Replace selectors inside resource blocks [\#262](https://github.com/Icinga/puppet-icinga2/issues/262)

**Merged pull requests:**

- fix time periods example [\#271](https://github.com/Icinga/puppet-icinga2/pull/271) ([deric](https://github.com/deric))
- Update icingamaster.yaml because yaml-lint failes [\#270](https://github.com/Icinga/puppet-icinga2/pull/270) ([matthiasritter](https://github.com/matthiasritter))

## [v1.2.0](https://github.com/icinga/puppet-icinga2/tree/v1.2.0) (2017-03-16)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.1.1...v1.2.0)

**Implemented enhancements:**

- Add concurrent check parameter to checker object [\#260](https://github.com/Icinga/puppet-icinga2/issues/260)
- use a tag to disable parsing for a single attribute value [\#254](https://github.com/Icinga/puppet-icinga2/issues/254)
- replace service restart with reload [\#250](https://github.com/Icinga/puppet-icinga2/issues/250)
- Update docs of example4 with hint for Puppet 4 [\#234](https://github.com/Icinga/puppet-icinga2/issues/234)
- Add service name to service apply loops [\#227](https://github.com/Icinga/puppet-icinga2/issues/227)

**Fixed bugs:**

- consider-type-of-attribute [\#256](https://github.com/Icinga/puppet-icinga2/issues/256)

## [v1.1.1](https://github.com/icinga/puppet-icinga2/tree/v1.1.1) (2017-03-08)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.1.0...v1.1.1)

**Implemented enhancements:**

- add example of the whole example config [\#252](https://github.com/Icinga/puppet-icinga2/issues/252)
- enable\_ha for notification feature [\#242](https://github.com/Icinga/puppet-icinga2/issues/242)
- Enhance docs on how to enable and use features [\#235](https://github.com/Icinga/puppet-icinga2/issues/235)

**Fixed bugs:**

- set groups default to undef for object servicegroup [\#251](https://github.com/Icinga/puppet-icinga2/issues/251)
- hash key with empty hash as value is parsed wrong [\#247](https://github.com/Icinga/puppet-icinga2/issues/247)
- attribute keys are missed for parsing [\#246](https://github.com/Icinga/puppet-icinga2/issues/246)
- Create signed certificate with custom CA [\#239](https://github.com/Icinga/puppet-icinga2/issues/239)
- Can't pass function via variable [\#238](https://github.com/Icinga/puppet-icinga2/issues/238)
- ido schema import dependency [\#237](https://github.com/Icinga/puppet-icinga2/issues/237)
- Using pki =\> "ca" can either cause incomplete deps or circular reference [\#236](https://github.com/Icinga/puppet-icinga2/issues/236)

**Closed issues:**

- Can't enable feature::idomysql without importing schema [\#241](https://github.com/Icinga/puppet-icinga2/issues/241)

**Merged pull requests:**

- enable setting of bind\_host and bind\_port for feature::api [\#243](https://github.com/Icinga/puppet-icinga2/pull/243) ([aschaber1](https://github.com/aschaber1))

## [v1.1.0](https://github.com/icinga/puppet-icinga2/tree/v1.1.0) (2017-02-20)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.0.2...v1.1.0)

**Implemented enhancements:**

- Deploy to puppet forge via travis [\#43](https://github.com/Icinga/puppet-icinga2/issues/43)

**Fixed bugs:**

- Parse issue when attribute is a nested hash with an array value [\#223](https://github.com/Icinga/puppet-icinga2/issues/223)
- icinga2 feature api fails when pki=icinga2 and ca is the local node [\#218](https://github.com/Icinga/puppet-icinga2/issues/218)
- Error installing module from forge for non r10k users [\#217](https://github.com/Icinga/puppet-icinga2/issues/217)
- Apply Notification "users" and "user\_groups" as variable [\#208](https://github.com/Icinga/puppet-icinga2/issues/208)

**Merged pull requests:**

- Fix parse issues when attribute is a nested hash with an array value [\#225](https://github.com/Icinga/puppet-icinga2/pull/225) ([lbetz](https://github.com/lbetz))
- Remove Puppet 4 Warning - delete :undef symbols in attr hash [\#222](https://github.com/Icinga/puppet-icinga2/pull/222) ([Reamer](https://github.com/Reamer))
- Allow other time units in notification and scheduleddowntime [\#220](https://github.com/Icinga/puppet-icinga2/pull/220) ([jkroepke](https://github.com/jkroepke))
- Add initial FreeBSD support [\#210](https://github.com/Icinga/puppet-icinga2/pull/210) ([xaque208](https://github.com/xaque208))

## [v1.0.2](https://github.com/icinga/puppet-icinga2/tree/v1.0.2) (2017-01-24)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v1.0.1...v1.0.2)

**Implemented enhancements:**

- Add Oracle Linux Support [\#216](https://github.com/Icinga/puppet-icinga2/issues/216)

**Fixed bugs:**

- add permission alter to idomysql docs [\#214](https://github.com/Icinga/puppet-icinga2/issues/214)
- Update serverspec vagrantfile to Debian 8.7 [\#212](https://github.com/Icinga/puppet-icinga2/issues/212)

**Merged pull requests:**

- Revert "Merge branch 'feature/workaround-for-puppetdb-14031'" [\#215](https://github.com/Icinga/puppet-icinga2/pull/215) ([bobapple](https://github.com/bobapple))
- travis: Enable deploy to Puppetforge [\#213](https://github.com/Icinga/puppet-icinga2/pull/213) ([lazyfrosch](https://github.com/lazyfrosch))
- Add support for OracleLinux [\#200](https://github.com/Icinga/puppet-icinga2/pull/200) ([TwizzyDizzy](https://github.com/TwizzyDizzy))

## [v1.0.1](https://github.com/icinga/puppet-icinga2/tree/v1.0.1) (2017-01-19)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.8.1...v1.0.1)

**Implemented enhancements:**

- \[dev.icinga.com \#14031\] Workaround for PuppetDB [\#198](https://github.com/Icinga/puppet-icinga2/issues/198)
- \[dev.icinga.com \#13923\] Remove 'Icinga Development Team' as single author from header [\#197](https://github.com/Icinga/puppet-icinga2/issues/197)
- \[dev.icinga.com \#13921\] Add alternative example of exported resources [\#196](https://github.com/Icinga/puppet-icinga2/issues/196)
- \[dev.icinga.com \#12659\] Upload module to Puppet Forge [\#100](https://github.com/Icinga/puppet-icinga2/issues/100)
- Fix Puppet version requirement in metadata.json [\#205](https://github.com/Icinga/puppet-icinga2/issues/205)

**Merged pull requests:**

- Improve wording for a few parts of the README.md file [\#201](https://github.com/Icinga/puppet-icinga2/pull/201) ([gunnarbeutner](https://github.com/gunnarbeutner))
- Extended example 3 README to mention Puppet parser bug [\#45](https://github.com/Icinga/puppet-icinga2/pull/45) ([kwisatz](https://github.com/kwisatz))
- Improving README [\#44](https://github.com/Icinga/puppet-icinga2/pull/44) ([lazyfrosch](https://github.com/lazyfrosch))

## [v0.8.1](https://github.com/icinga/puppet-icinga2/tree/v0.8.1) (2017-01-11)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.8.0...v0.8.1)

**Fixed bugs:**

- \[dev.icinga.com \#13919\] Fix imports object template [\#195](https://github.com/Icinga/puppet-icinga2/issues/195)
- \[dev.icinga.com \#13917\] Remove hash validation of vars attribut [\#194](https://github.com/Icinga/puppet-icinga2/issues/194)

**Merged pull requests:**

- Parallelisation problems with Travis on Ruby 2.1 [\#42](https://github.com/Icinga/puppet-icinga2/pull/42) ([lazyfrosch](https://github.com/lazyfrosch))

## [v0.8.0](https://github.com/icinga/puppet-icinga2/tree/v0.8.0) (2017-01-04)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.7.2...v0.8.0)

**Implemented enhancements:**

- \[dev.icinga.com \#13875\] Add TLS options for api feature [\#191](https://github.com/Icinga/puppet-icinga2/issues/191)
- \[dev.icinga.com \#13873\] Get fixtures for specs from Puppet Forge [\#190](https://github.com/Icinga/puppet-icinga2/issues/190)
- \[dev.icinga.com \#13501\] Add support for Parallel Spec Tests [\#156](https://github.com/Icinga/puppet-icinga2/issues/156)

**Fixed bugs:**

- \[dev.icinga.com \#13877\] Fix SUSE repo [\#192](https://github.com/Icinga/puppet-icinga2/issues/192)
- \[dev.icinga.com \#13871\] Remove json, json\_pure dependency for Ruby \>= 2 [\#189](https://github.com/Icinga/puppet-icinga2/issues/189)
- \[dev.icinga.com \#13867\] Travis-CI test with Puppet \< 4 [\#188](https://github.com/Icinga/puppet-icinga2/issues/188)
- \[dev.icinga.com \#13863\] Make puppet lint happy [\#187](https://github.com/Icinga/puppet-icinga2/issues/187)
- \[dev.icinga.com \#13799\] change attribute checkcommand to checkcommand\_name in object checkcommand [\#176](https://github.com/Icinga/puppet-icinga2/issues/176)
- \[dev.icinga.com \#13797\] change attribute apiuser to apiuser\_name in object apiuser [\#175](https://github.com/Icinga/puppet-icinga2/issues/175)
- \[dev.icinga.com \#13795\] change attribute zone to zone\_name in object zone [\#174](https://github.com/Icinga/puppet-icinga2/issues/174)
- \[dev.icinga.com \#13793\] change attribute endpoint to endpoint\_name in object endpoint [\#173](https://github.com/Icinga/puppet-icinga2/issues/173)
- \[dev.icinga.com \#13791\] change attribute hostname to host\_name in object host [\#172](https://github.com/Icinga/puppet-icinga2/issues/172)

**Merged pull requests:**

- feature/api: Add TLS detail settings [\#41](https://github.com/Icinga/puppet-icinga2/pull/41) ([lazyfrosch](https://github.com/lazyfrosch))
- Rakefile: Add and enable parallel\_spec by default [\#40](https://github.com/Icinga/puppet-icinga2/pull/40) ([lazyfrosch](https://github.com/lazyfrosch))
- Make Puppet Lint happy [\#37](https://github.com/Icinga/puppet-icinga2/pull/37) ([lazyfrosch](https://github.com/lazyfrosch))
- Enabling Travis CI [\#36](https://github.com/Icinga/puppet-icinga2/pull/36) ([lazyfrosch](https://github.com/lazyfrosch))

## [v0.7.2](https://github.com/icinga/puppet-icinga2/tree/v0.7.2) (2017-01-02)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.7.1...v0.7.2)

**Implemented enhancements:**

- \[dev.icinga.com \#13333\] Support collecting exported zones and endpoints [\#152](https://github.com/Icinga/puppet-icinga2/issues/152)
- \[dev.icinga.com \#13835\] Added an example that uses exported resources [\#186](https://github.com/Icinga/puppet-icinga2/issues/186)

**Fixed bugs:**

- \[dev.icinga.com \#13779\] add attribute notificationcommand\_name to object notificationcommand [\#166](https://github.com/Icinga/puppet-icinga2/issues/166)
- \[dev.icinga.com \#13833\] Add possibility to set command parameter as String. [\#185](https://github.com/Icinga/puppet-icinga2/issues/185)
- \[dev.icinga.com \#13831\] fix target as undef in several objects [\#184](https://github.com/Icinga/puppet-icinga2/issues/184)
- \[dev.icinga.com \#13829\] fix target as undef in several objects [\#183](https://github.com/Icinga/puppet-icinga2/issues/183)

**Merged pull requests:**

- Added an example that uses exported resources to create a master-agent set-up using exported resources. [\#32](https://github.com/Icinga/puppet-icinga2/pull/32) ([kwisatz](https://github.com/kwisatz))

## [v0.7.1](https://github.com/icinga/puppet-icinga2/tree/v0.7.1) (2016-12-28)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.7.0...v0.7.1)

**Fixed bugs:**

- \[dev.icinga.com \#13821\] fix feature debuglog [\#182](https://github.com/Icinga/puppet-icinga2/issues/182)
- \[dev.icinga.com \#13819\] fix object checkcommand [\#181](https://github.com/Icinga/puppet-icinga2/issues/181)
- \[dev.icinga.com \#13817\] fix feature mainlog [\#180](https://github.com/Icinga/puppet-icinga2/issues/180)
- \[dev.icinga.com \#13815\] add  attribute notificationcommand\_name to object notificationcommand [\#179](https://github.com/Icinga/puppet-icinga2/issues/179)
- \[dev.icinga.com \#13803\] fix documentation of all objects [\#178](https://github.com/Icinga/puppet-icinga2/issues/178)
- \[dev.icinga.com \#13801\] change title of concat\_fragment in object to title [\#177](https://github.com/Icinga/puppet-icinga2/issues/177)
- \[dev.icinga.com \#13789\] add attribute usergroup\_name to object usergroup [\#171](https://github.com/Icinga/puppet-icinga2/issues/171)
- \[dev.icinga.com \#13787\] add attribute user\_name to object user [\#170](https://github.com/Icinga/puppet-icinga2/issues/170)
- \[dev.icinga.com \#13785\] add attribute timeperiod\_name to object timeperiod [\#169](https://github.com/Icinga/puppet-icinga2/issues/169)
- \[dev.icinga.com \#13783\] add attribute servicegroup\_name to object servicegroup [\#168](https://github.com/Icinga/puppet-icinga2/issues/168)
- \[dev.icinga.com \#13781\] add attribute scheduleddowntime\_name to object scheduleddowntime [\#167](https://github.com/Icinga/puppet-icinga2/issues/167)
- \[dev.icinga.com \#13777\] add attribute notification\_name to object notification [\#165](https://github.com/Icinga/puppet-icinga2/issues/165)
- \[dev.icinga.com \#13775\] add attribute eventcommand\_name to object eventcommand [\#164](https://github.com/Icinga/puppet-icinga2/issues/164)
- \[dev.icinga.com \#13773\] add attribute dependency\_name to object dependency  [\#163](https://github.com/Icinga/puppet-icinga2/issues/163)
- \[dev.icinga.com \#13771\] add attribute compatlogger\_name to object compatlogger [\#162](https://github.com/Icinga/puppet-icinga2/issues/162)
- \[dev.icinga.com \#13769\] add attribute checkresultreader\_name to object checkresultreader [\#161](https://github.com/Icinga/puppet-icinga2/issues/161)
- \[dev.icinga.com \#13767\] add attribute service\_name to object service [\#160](https://github.com/Icinga/puppet-icinga2/issues/160)
- \[dev.icinga.com \#13701\] Calling private method "Puppet.settings.preferred\_run\_mode=" in facter/icinga2\_puppet.rb breaks Puppet master [\#159](https://github.com/Icinga/puppet-icinga2/issues/159)

**Merged pull requests:**

- Add possibility to use ip or hostname. [\#31](https://github.com/Icinga/puppet-icinga2/pull/31) ([n00by](https://github.com/n00by))
- Fix non-breaking space. [\#30](https://github.com/Icinga/puppet-icinga2/pull/30) ([n00by](https://github.com/n00by))
- Don't call private method preferred\_run\_mode= in facts [\#29](https://github.com/Icinga/puppet-icinga2/pull/29) ([antaflos](https://github.com/antaflos))

## [v0.7.0](https://github.com/icinga/puppet-icinga2/tree/v0.7.0) (2016-12-15)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.6.0...v0.7.0)

**Implemented enhancements:**

- \[dev.icinga.com \#12344\] CA handling using file ressource [\#50](https://github.com/Icinga/puppet-icinga2/issues/50)
- \[dev.icinga.com \#13513\] Rework default order values for all objects [\#158](https://github.com/Icinga/puppet-icinga2/issues/158)
- \[dev.icinga.com \#13511\] Add custom config fragment [\#157](https://github.com/Icinga/puppet-icinga2/issues/157)
- \[dev.icinga.com \#13495\] CA handling using the icinga2 CLI [\#155](https://github.com/Icinga/puppet-icinga2/issues/155)
- \[dev.icinga.com \#13385\] Add Travis CI Tests [\#154](https://github.com/Icinga/puppet-icinga2/issues/154)
- \[dev.icinga.com \#12653\] Add Support for SLES 12 [\#96](https://github.com/Icinga/puppet-icinga2/issues/96)
- \[dev.icinga.com \#12652\] CA handling using custom function from puppet-icinga2-legacy [\#95](https://github.com/Icinga/puppet-icinga2/issues/95)
- \[dev.icinga.com \#12651\] CA handling with base64 encoded string [\#94](https://github.com/Icinga/puppet-icinga2/issues/94)

**Fixed bugs:**

- \[dev.icinga.com \#13365\] Wrong MySQL user grants for schema import in docs [\#153](https://github.com/Icinga/puppet-icinga2/issues/153)

**Merged pull requests:**

- make service validation consistent with host validation [\#26](https://github.com/Icinga/puppet-icinga2/pull/26) ([deric](https://github.com/deric))
- update influxdb documentation [\#25](https://github.com/Icinga/puppet-icinga2/pull/25) ([deric](https://github.com/deric))
- \[OSMC Hackathon\] Adding initial SLES support [\#24](https://github.com/Icinga/puppet-icinga2/pull/24) ([jfryman](https://github.com/jfryman))
- Remove duplicate target parameter section in icinga2::object::timeper… [\#23](https://github.com/Icinga/puppet-icinga2/pull/23) ([kwisatz](https://github.com/kwisatz))
- fix small typos [\#22](https://github.com/Icinga/puppet-icinga2/pull/22) ([xorpaul](https://github.com/xorpaul))

## [v0.6.0](https://github.com/icinga/puppet-icinga2/tree/v0.6.0) (2016-11-23)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.5.0...v0.6.0)

**Implemented enhancements:**

- \[dev.icinga.com \#12982\] Red Hat Satellite / Puppet 3.x compatibility [\#142](https://github.com/Icinga/puppet-icinga2/issues/142)
- \[dev.icinga.com \#12374\] Object Downtime [\#80](https://github.com/Icinga/puppet-icinga2/issues/80)
- \[dev.icinga.com \#12371\] Object Comment [\#77](https://github.com/Icinga/puppet-icinga2/issues/77)
- \[dev.icinga.com \#13219\] How attribute parsing works documentation [\#150](https://github.com/Icinga/puppet-icinga2/issues/150)
- \[dev.icinga.com \#13181\] Apply Rules Docs [\#147](https://github.com/Icinga/puppet-icinga2/issues/147)
- \[dev.icinga.com \#12960\] Consider function calls in attributes parsing [\#140](https://github.com/Icinga/puppet-icinga2/issues/140)
- \[dev.icinga.com \#12959\] Attribute function does not included adding value [\#139](https://github.com/Icinga/puppet-icinga2/issues/139)
- \[dev.icinga.com \#12958\] Add parsing of assign rules to attribute function [\#138](https://github.com/Icinga/puppet-icinga2/issues/138)
- \[dev.icinga.com \#12957\] Extend attributes Function [\#137](https://github.com/Icinga/puppet-icinga2/issues/137)
- \[dev.icinga.com \#12878\] Extend attributes fct to parse connected strings [\#136](https://github.com/Icinga/puppet-icinga2/issues/136)
- \[dev.icinga.com \#12839\] use-fct-attributes-for-other-configs [\#126](https://github.com/Icinga/puppet-icinga2/issues/126)
- \[dev.icinga.com \#12387\] Object UserGroup [\#92](https://github.com/Icinga/puppet-icinga2/issues/92)
- \[dev.icinga.com \#12385\] Object User [\#91](https://github.com/Icinga/puppet-icinga2/issues/91)
- \[dev.icinga.com \#12384\] Object TimePeriod [\#90](https://github.com/Icinga/puppet-icinga2/issues/90)
- \[dev.icinga.com \#12383\] Object ServiceGroup [\#89](https://github.com/Icinga/puppet-icinga2/issues/89)
- \[dev.icinga.com \#12382\] Object Service [\#88](https://github.com/Icinga/puppet-icinga2/issues/88)
- \[dev.icinga.com \#12381\] Object ScheduledDowntime [\#87](https://github.com/Icinga/puppet-icinga2/issues/87)
- \[dev.icinga.com \#12380\] Object NotificationCommand [\#86](https://github.com/Icinga/puppet-icinga2/issues/86)
- \[dev.icinga.com \#12379\] Object Notification [\#85](https://github.com/Icinga/puppet-icinga2/issues/85)
- \[dev.icinga.com \#12378\] Object HostGroup [\#84](https://github.com/Icinga/puppet-icinga2/issues/84)
- \[dev.icinga.com \#12377\] Object Host [\#83](https://github.com/Icinga/puppet-icinga2/issues/83)
- \[dev.icinga.com \#12376\] Object EventCommand [\#82](https://github.com/Icinga/puppet-icinga2/issues/82)
- \[dev.icinga.com \#12373\] Object Dependency [\#79](https://github.com/Icinga/puppet-icinga2/issues/79)
- \[dev.icinga.com \#12372\] Object CompatLogger [\#78](https://github.com/Icinga/puppet-icinga2/issues/78)
- \[dev.icinga.com \#12370\] Object CheckResultReader [\#76](https://github.com/Icinga/puppet-icinga2/issues/76)
- \[dev.icinga.com \#12369\] Object CheckCommand [\#75](https://github.com/Icinga/puppet-icinga2/issues/75)
- \[dev.icinga.com \#12349\] Apply Rules [\#55](https://github.com/Icinga/puppet-icinga2/issues/55)

**Fixed bugs:**

- \[dev.icinga.com \#13217\] Icinga Functions don't parse correctly [\#149](https://github.com/Icinga/puppet-icinga2/issues/149)
- \[dev.icinga.com \#13207\] Wrong config for attribute vars in level 3 hash [\#148](https://github.com/Icinga/puppet-icinga2/issues/148)
- \[dev.icinga.com \#13179\] Ruby 1.8 testing [\#146](https://github.com/Icinga/puppet-icinga2/issues/146)
- \[dev.icinga.com \#13149\] "in" is a keyword for assignment [\#145](https://github.com/Icinga/puppet-icinga2/issues/145)
- \[dev.icinga.com \#13123\] Objects with required parameters [\#144](https://github.com/Icinga/puppet-icinga2/issues/144)
- \[dev.icinga.com \#13035\] Wrong syntax of "apply" in object.conf.erb template \(afaik\) [\#143](https://github.com/Icinga/puppet-icinga2/issues/143)
- \[dev.icinga.com \#12980\] Symlinks in modules are not allowed in puppet modules [\#141](https://github.com/Icinga/puppet-icinga2/issues/141)

**Merged pull requests:**

- Proposal \(to be discussed\) for allowing function that USE context [\#20](https://github.com/Icinga/puppet-icinga2/pull/20) ([kwisatz](https://github.com/kwisatz))

## [v0.5.0](https://github.com/icinga/puppet-icinga2/tree/v0.5.0) (2016-10-10)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.4.0...v0.5.0)

**Implemented enhancements:**

- \[dev.icinga.com \#12859\] Doc example for creating IDO database [\#129](https://github.com/Icinga/puppet-icinga2/issues/129)
- \[dev.icinga.com \#12836\] Write profile class examples [\#124](https://github.com/Icinga/puppet-icinga2/issues/124)
- \[dev.icinga.com \#12806\] Rework feature idopgsql [\#121](https://github.com/Icinga/puppet-icinga2/issues/121)
- \[dev.icinga.com \#12805\] Rework feature idomysql [\#120](https://github.com/Icinga/puppet-icinga2/issues/120)
- \[dev.icinga.com \#12804\] Rework feature influxdb [\#119](https://github.com/Icinga/puppet-icinga2/issues/119)
- \[dev.icinga.com \#12802\] Usage documentation [\#118](https://github.com/Icinga/puppet-icinga2/issues/118)
- \[dev.icinga.com \#12801\] Adjust SSL settings for features [\#117](https://github.com/Icinga/puppet-icinga2/issues/117)
- \[dev.icinga.com \#12771\] Add parameter ensure to objects [\#114](https://github.com/Icinga/puppet-icinga2/issues/114)
- \[dev.icinga.com \#12759\] Extend api feature with endpoints and zones parameter [\#113](https://github.com/Icinga/puppet-icinga2/issues/113)
- \[dev.icinga.com \#12754\] features-with-objects [\#112](https://github.com/Icinga/puppet-icinga2/issues/112)
- \[dev.icinga.com \#12388\] Object Zone [\#93](https://github.com/Icinga/puppet-icinga2/issues/93)
- \[dev.icinga.com \#12375\] Object Endpoint [\#81](https://github.com/Icinga/puppet-icinga2/issues/81)
- \[dev.icinga.com \#12368\] Object ApiUser [\#74](https://github.com/Icinga/puppet-icinga2/issues/74)
- \[dev.icinga.com \#12367\] Objects [\#73](https://github.com/Icinga/puppet-icinga2/issues/73)

**Fixed bugs:**

- \[dev.icinga.com \#12875\] Icinga2 does not start on Windows [\#135](https://github.com/Icinga/puppet-icinga2/issues/135)
- \[dev.icinga.com \#12871\] Please replace facts icinga2\_puppet\_\* by $::settings [\#133](https://github.com/Icinga/puppet-icinga2/issues/133)
- \[dev.icinga.com \#12872\] Add Requires to basic config for features and objects that need additional packages [\#134](https://github.com/Icinga/puppet-icinga2/issues/134)
- \[dev.icinga.com \#12867\] Feature-statusdata-update-interval-default [\#132](https://github.com/Icinga/puppet-icinga2/issues/132)
- \[dev.icinga.com \#12865\] Class scoping [\#131](https://github.com/Icinga/puppet-icinga2/issues/131)
- \[dev.icinga.com \#12864\] debian based system repo handling [\#130](https://github.com/Icinga/puppet-icinga2/issues/130)
- \[dev.icinga.com \#12858\] Doc example class icinga2 [\#128](https://github.com/Icinga/puppet-icinga2/issues/128)
- \[dev.icinga.com \#12857\] Default owner of config dir [\#127](https://github.com/Icinga/puppet-icinga2/issues/127)
- \[dev.icinga.com \#12837\] File permission on windows [\#125](https://github.com/Icinga/puppet-icinga2/issues/125)
- \[dev.icinga.com \#12821\] Unify windows unit tests [\#123](https://github.com/Icinga/puppet-icinga2/issues/123)
- \[dev.icinga.com \#12809\] Path of Puppet keys and certs broken [\#122](https://github.com/Icinga/puppet-icinga2/issues/122)
- \[dev.icinga.com \#12797\] windows line-breaks for objects [\#116](https://github.com/Icinga/puppet-icinga2/issues/116)
- \[dev.icinga.com \#12775\] Api feature unit tests fail for windows [\#115](https://github.com/Icinga/puppet-icinga2/issues/115)

## [v0.4.0](https://github.com/icinga/puppet-icinga2/tree/v0.4.0) (2016-09-22)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.3.1...v0.4.0)

**Implemented enhancements:**

- \[dev.icinga.com \#12720\] Feature ido-pgsql [\#108](https://github.com/Icinga/puppet-icinga2/issues/108)
- \[dev.icinga.com \#12706\] Implement host\_format\_template and service\_format\_template for perfdata feature [\#105](https://github.com/Icinga/puppet-icinga2/issues/105)
- \[dev.icinga.com \#12363\] Feature ido-mysql [\#69](https://github.com/Icinga/puppet-icinga2/issues/69)

**Fixed bugs:**

- \[dev.icinga.com \#12743\] paths in api feature must be quoted [\#111](https://github.com/Icinga/puppet-icinga2/issues/111)

## [v0.3.1](https://github.com/icinga/puppet-icinga2/tree/v0.3.1) (2016-09-16)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.2.0...v0.3.1)

**Implemented enhancements:**

- \[dev.icinga.com \#12693\] Fix fixtures.yaml [\#102](https://github.com/Icinga/puppet-icinga2/issues/102)
- \[dev.icinga.com \#12366\] Feature notification [\#72](https://github.com/Icinga/puppet-icinga2/issues/72)
- \[dev.icinga.com \#12365\] Feature mainlog  [\#71](https://github.com/Icinga/puppet-icinga2/issues/71)
- \[dev.icinga.com \#12364\] Feature influxdb  [\#70](https://github.com/Icinga/puppet-icinga2/issues/70)
- \[dev.icinga.com \#12362\] Feature graphite  [\#68](https://github.com/Icinga/puppet-icinga2/issues/68)
- \[dev.icinga.com \#12361\] Feature checker  [\#67](https://github.com/Icinga/puppet-icinga2/issues/67)
- \[dev.icinga.com \#12360\] Feature syslog [\#66](https://github.com/Icinga/puppet-icinga2/issues/66)
- \[dev.icinga.com \#12359\] Feature statusdata  [\#65](https://github.com/Icinga/puppet-icinga2/issues/65)
- \[dev.icinga.com \#12358\] Feature perfdata  [\#64](https://github.com/Icinga/puppet-icinga2/issues/64)
- \[dev.icinga.com \#12357\] Feature opentsdb  [\#63](https://github.com/Icinga/puppet-icinga2/issues/63)
- \[dev.icinga.com \#12356\] Feature livestatus  [\#62](https://github.com/Icinga/puppet-icinga2/issues/62)
- \[dev.icinga.com \#12355\] Feature gelf  [\#61](https://github.com/Icinga/puppet-icinga2/issues/61)
- \[dev.icinga.com \#12354\] Feature debuglog  [\#60](https://github.com/Icinga/puppet-icinga2/issues/60)
- \[dev.icinga.com \#12353\] Feature compatlog  [\#59](https://github.com/Icinga/puppet-icinga2/issues/59)
- \[dev.icinga.com \#12352\] Feature command  [\#58](https://github.com/Icinga/puppet-icinga2/issues/58)
- \[dev.icinga.com \#12351\] Feature api  [\#57](https://github.com/Icinga/puppet-icinga2/issues/57)
- \[dev.icinga.com \#12350\] Features [\#56](https://github.com/Icinga/puppet-icinga2/issues/56)
- \[dev.icinga.com \#12343\] Use certificates generated by Puppet [\#49](https://github.com/Icinga/puppet-icinga2/issues/49)

**Fixed bugs:**

- \[dev.icinga.com \#12724\] RSpec tests without effect [\#109](https://github.com/Icinga/puppet-icinga2/issues/109)
- \[dev.icinga.com \#12714\] 32bit for Windows [\#107](https://github.com/Icinga/puppet-icinga2/issues/107)
- \[dev.icinga.com \#12713\] unit test for all defaults in feature mainlog [\#106](https://github.com/Icinga/puppet-icinga2/issues/106)
- \[dev.icinga.com \#12698\] Params inheritance in features [\#104](https://github.com/Icinga/puppet-icinga2/issues/104)
- \[dev.icinga.com \#12696\] Notify service when features-available/feature.conf is created [\#103](https://github.com/Icinga/puppet-icinga2/issues/103)
- \[dev.icinga.com \#12692\] Fix mlodule depency Typo for module puppetlabs/chocolaty [\#101](https://github.com/Icinga/puppet-icinga2/issues/101)
- \[dev.icinga.com \#12738\] Duplicate declaration File\[/etc/icinga2/pki\] [\#110](https://github.com/Icinga/puppet-icinga2/issues/110)

## [v0.2.0](https://github.com/icinga/puppet-icinga2/tree/v0.2.0) (2016-09-09)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.1.0...v0.2.0)

**Implemented enhancements:**

- \[dev.icinga.com \#12658\] Decide whether or not to drop support for Puppet 3.x and below [\#99](https://github.com/Icinga/puppet-icinga2/issues/99)
- \[dev.icinga.com \#12657\] Unit tests should cover every supported OS/Distro instead of just one [\#98](https://github.com/Icinga/puppet-icinga2/issues/98)
- \[dev.icinga.com \#12346\] Add Support for Ubuntu 14.04, 16.04 [\#52](https://github.com/Icinga/puppet-icinga2/issues/52)
- \[dev.icinga.com \#12341\] Config handling [\#47](https://github.com/Icinga/puppet-icinga2/issues/47)

**Fixed bugs:**

- \[dev.icinga.com \#12656\] Inheritance [\#97](https://github.com/Icinga/puppet-icinga2/issues/97)

## [v0.1.0](https://github.com/icinga/puppet-icinga2/tree/v0.1.0) (2016-09-06)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.6.2...v0.1.0)

**Implemented enhancements:**

- \[dev.icinga.com \#12348\] Add Support for Windows [\#54](https://github.com/Icinga/puppet-icinga2/issues/54)
- \[dev.icinga.com \#12347\] Add Support for CentOS 6, 7 [\#53](https://github.com/Icinga/puppet-icinga2/issues/53)
- \[dev.icinga.com \#12345\] Add Support for Debian 7, 8 [\#51](https://github.com/Icinga/puppet-icinga2/issues/51)
- \[dev.icinga.com \#12342\] Repo management [\#48](https://github.com/Icinga/puppet-icinga2/issues/48)
- \[dev.icinga.com \#12340\] Installation [\#46](https://github.com/Icinga/puppet-icinga2/issues/46)

## [v0.6.2](https://github.com/icinga/puppet-icinga2/tree/v0.6.2) (2015-01-30)
[Full Changelog](https://github.com/icinga/puppet-icinga2/compare/v0.6.1...v0.6.2)

## [v0.6.1](https://github.com/icinga/puppet-icinga2/tree/v0.6.1) (2014-12-03)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*