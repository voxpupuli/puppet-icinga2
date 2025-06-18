# @summary
#   This class loads the default parameters by doing a hiera lookup.
#
# @note This parameters depend on the os plattform. Changes maybe will break the functional capability of the supported plattforms and versions. Please only do changes when you know what you're doing.
#
# @api private
#
# @param package_name
#   The name of the icinga package to manage.
#
# @param service_name
#   The name of the icinga service to manage.
#
# @param user
#   User as the icinga process runs.
#   CAUTION: This does not manage the user context for the runnig icinga 2 process!
#   The parameter is only used for ownership of files or directories.
#
# @param group
#   Group as the icinga process runs.
#   CAUTION: This does not manage the group context for the runnig icinga 2 process!
#   The parameter is only used for group membership of files or directories.
#
# @param logon_account
#   The user context in which the service should run.
#   ATM only relevant on Windows.
#
# @param selinux_package_name
#   The name of the icinga selinux package.
#
# @param ido_mysql_package_name
#   The name of the icinga package that's needed for MySQL.
#
# @param ido_mysql_schema
#   Path to the MySQL schema to import.
#
# @param ido_pgsql_package_name
#   The name of the icinga package that's needed for Postrgesql.
#
# @param ido_pgsql_schema
#   Path to the Postgresql schema to import.
#
# @param icinga2_bin
#   Path to the icinga2 binary.
#
# @param conf_dir
#   Location of the configuration directory of Icinga.
#
# @param lib_dir
#   Path to the directory contained the system libs.
#
# @param log_dir
#   Location to store Icinga log files.
#
# @param run_dir
#   Runtime directory of Icinga.
#
# @param spool_dir
#   Path to spool files of Icinga.
#
# @param cache_dir
#   Path to cache files of Icinga.
#
# @param data_dir
#   Path to data files of Icinga.
#
# @param cert_dir
#   Path to the directory where Icinga stores keys and certificates.
#
# @param ca_dir
#   Path to CA.
#
# @param service_reload
#   How to do a reload of the Icinga process.
#
# @param $constants
#   Define Icinga constants
class icinga2::globals (
  String[1]              $package_name,
  String[1]              $service_name,
  String[1]              $ido_mysql_schema,
  String[1]              $ido_pgsql_schema,
  Stdlib::Absolutepath   $icinga2_bin,
  Stdlib::Absolutepath   $conf_dir,
  Stdlib::Absolutepath   $lib_dir,
  Stdlib::Absolutepath   $log_dir,
  Stdlib::Absolutepath   $run_dir,
  Stdlib::Absolutepath   $spool_dir,
  Stdlib::Absolutepath   $cache_dir,
  Stdlib::Absolutepath   $data_dir,
  Stdlib::Absolutepath   $cert_dir,
  Stdlib::Absolutepath   $ca_dir,
  Array[String[1]]       $reserved,
  Optional[String[1]]    $user                   = undef,
  Optional[String[1]]    $group                  = undef,
  Optional[String[1]]    $logon_account          = undef,
  Optional[String[1]]    $selinux_package_name   = undef,
  Optional[String[1]]    $ido_mysql_package_name = undef,
  Optional[String[1]]    $ido_pgsql_package_name = undef,
  Optional[String[1]]    $service_reload         = undef,
  Hash[String, Any]      $constants              = {},
) {
  assert_private()
}
