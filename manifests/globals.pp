# == Class: icinga2::globals
#
# This class loads the default parameters by doing a hiera lookup.
#
# NOTE: This parameters depend on the os plattform. Changes maybe will
#       break the functional capability of the supported plattforms and versions.
#       Please only do changes when you know what you're doing.
#
# === Parameters
#
# [*package_name*]
#   The name of the icinga package to manage.
#
# [*service_name*]
#   The name of the icinga service to manage.
#
# [*user*]
#   User as the icinga process runs.
#   CAUTION: This does not manage the user context for the runnig icinga 2 process!
#   The parameter is only used for ownership of files or directories.
#   
# [*group*]
#   Group as the icinga process runs.
#   CAUTION: This does not manage the group context for the runnig icinga 2 process!
#   The parameter is only used for group membership of files or directories.
#
# [*ido_mysql_package_name*]
#   The name of the icinga package that's needed for MySQL.
#   
# [*ido_mysql_schema*]
#   Path to the MySQL schema to import.
#
# [*ido_pgsql_package_name*]
#   The name of the icinga package that's needed for Postrgesql.
#   
# [*ido_pgsql_schema*]
#   Path to the Postgresql schema to import.
#
# [*icinga2_bin*]
#   Path to the icinga2 binary.
#
# [*conf_dir*]
#   Location of the configuration directory of Icinga.
#
# [*lib_dir*]
#   Path to the directory contained the system libs.
#
# [*log_dir*]
#   Location to store Icinga log files.
#
# [*run_dir*]
#   Runtime directory of Icinga.
#
# [*spool_dir*]
#   Path to spool files of Icinga.
#
# [*cache_dir*]
#   Path to cache files of Icinga.
#
# [*cert_dir*]
#   Path to the directory where Icinga stores keys and certificates.
#
# [*ca_dir*]
#   Path to CA.
#
# [*reserved_words*]
#   Reserved words of the Icinga DSL. These words are not quoted by the
#   parser (function icinga2_attributes) of this module.

# [*service_reload*]
#   How to do a reload of the Icinga process.
#
# [*constants*]
#   Set default constants.
#
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
#
class icinga2::globals(
  String                 $package_name,
  String                 $service_name,
  Optional[String]       $user,
  Optional[String]       $group,
  Optional[String]       $ido_mysql_package_name,
  String                 $ido_mysql_schema,
  Optional[String]       $ido_pgsql_package_name,
  String                 $ido_pgsql_schema,
  Stdlib::Absolutepath   $icinga2_bin,
  Stdlib::Absolutepath   $conf_dir,
  Stdlib::Absolutepath   $lib_dir,
  Stdlib::Absolutepath   $log_dir,
  Stdlib::Absolutepath   $run_dir,
  Stdlib::Absolutepath   $spool_dir,
  Stdlib::Absolutepath   $cache_dir,
  Stdlib::Absolutepath   $cert_dir,
  Stdlib::Absolutepath   $ca_dir,
  Array[String]          $reserved,
  Optional[String]       $service_reload,
) {

  assert_private()

  if ( versioncmp($puppetversion, '6' ) >= 0 and versioncmp(load_module_metadata('stdlib')['version'], '5.1.0') < 0 ) {                                                                             
    fail('You be affected by this bug: https://github.com/Icinga/puppet-icinga2/issues/505 so you should update your stdlib to version 5.1 or higher')                                                             
  }   

  $constants =  lookup('icinga2::globals::constants', Hash, 'deep', {})

}
