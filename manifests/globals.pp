# @summary
#   This class loads the default parameters by doing a hiera lookup.
#
# @note This parameters depend on the os plattform. Changes maybe will break the functional capability of the supported plattforms and versions. Please only do changes when you know what you're doing.
#
# @api private
#
# @param [String] package_name
#   The name of the icinga package to manage.
#
# @param [String] service_name
#   The name of the icinga service to manage.
#
# @param [Optional[String]] user
#   User as the icinga process runs.
#   CAUTION: This does not manage the user context for the runnig icinga 2 process!
#   The parameter is only used for ownership of files or directories.
#   
# @param [Optional[String]] group
#   Group as the icinga process runs.
#   CAUTION: This does not manage the group context for the runnig icinga 2 process!
#   The parameter is only used for group membership of files or directories.
#
# @param [Optional[String]] selinux_package_name
#   The name of the icinga selinux package.
#
# @param [Optional[String]] ido_mysql_package_name
#   The name of the icinga package that's needed for MySQL.
#   
# @param [String] ido_mysql_schema
#   Path to the MySQL schema to import.
#
# @param [Optional[String]] ido_pgsql_package_name
#   The name of the icinga package that's needed for Postrgesql.
#   
# @param [String] ido_pgsql_schema
#   Path to the Postgresql schema to import.
#
# @param [Stdlib::Absolutepath] icinga2_bin
#   Path to the icinga2 binary.
#
# @param [Stdlib::Absolutepath] conf_dir
#   Location of the configuration directory of Icinga.
#
# @param [Stdlib::Absolutepath] lib_dir
#   Path to the directory contained the system libs.
#
# @param [Stdlib::Absolutepath] log_dir
#   Location to store Icinga log files.
#
# @param [Stdlib::Absolutepath] run_dir
#   Runtime directory of Icinga.
#
# @param [Stdlib::Absolutepath] spool_dir
#   Path to spool files of Icinga.
#
# @param [Stdlib::Absolutepath] cache_dir
#   Path to cache files of Icinga.
#
# @param [Stdlib::Absolutepath] cert_dir
#   Path to the directory where Icinga stores keys and certificates.
#
# @param [Stdlib::Absolutepath] ca_dir
#   Path to CA.
#
# @param [Optional[String]] service_reload
#   How to do a reload of the Icinga process.
#
class icinga2::globals(
  String                 $package_name,
  String                 $service_name,
  String                 $ido_mysql_schema,
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
  Optional[String]       $user                   = undef,
  Optional[String]       $group                  = undef,
  Optional[String]       $selinux_package_name   = undef,
  Optional[String]       $ido_mysql_package_name = undef,
  Optional[String]       $ido_pgsql_package_name = undef,
  Optional[String]       $service_reload         = undef,
) {

  assert_private()

  if ( versioncmp($::puppetversion, '6' ) >= 0 and versioncmp(load_module_metadata('stdlib')['version'], '5.1.0') < 0 ) {
    fail('You be affected by this bug: https://github.com/Icinga/puppet-icinga2/issues/505 so you should update your stdlib to version 5.1 or higher')
  }

  $constants =  lookup('icinga2::globals::constants', Hash, 'deep', {})

}
