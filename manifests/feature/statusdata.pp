# @summary
#   Configures the Icinga 2 feature statusdata.
#
# @param ensure
#   Set to present enables the feature statusdata, absent disables it.
#
# @param status_path
#   Absolute path to the status.dat file.
#
# @param objects_path
#   Absolute path to the object.cache file.
#
# @param update_interval
#   Interval in seconds to update both status files. You can also specify
#   it in minutes with the letter m or in seconds with s.
#
class icinga2::feature::statusdata(
  Enum['absent', 'present']          $ensure          = present,
  Optional[Stdlib::Absolutepath]     $status_path     = undef,
  Optional[Stdlib::Absolutepath]     $objects_path    = undef,
  Optional[Icinga2::Interval]        $update_interval = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir = $::icinga2::globals::conf_dir
  $_notify  = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  # compose attributes
  $attrs = {
    status_path     => $status_path,
    objects_path    => $objects_path,
    update_interval => $update_interval,
  }

  # create object
  icinga2::object { 'icinga2::object::StatusDataWriter::statusdata':
    object_name => 'statusdata',
    object_type => 'StatusDataWriter',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/statusdata.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'compat'
  concat::fragment { 'icinga2::feature::statusdata':
    target  => "${conf_dir}/features-available/statusdata.conf",
    content => "library \"compat\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'statusdata':
    ensure => $ensure,
  }
}
