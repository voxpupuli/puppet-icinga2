# == Class: icinga2::globals
#
# In this class all default parameters are stored.
#
# === Parameters
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
  String                 $service_reload,
) {

  assert_private()

  $constants =  lookup('icinga2::globals::constants', Hash, 'deep', {})

}
