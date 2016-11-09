# == Define: icinga2::object::compatlogger
#
# Manage Icinga2 CompatLogger objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the endpoint object, absent disables it. Defaults to present.
#
# [*spool_dir*]
#   The directory which contains the check result files. Defaults to LocalStateDir + "/lib/icinga2/spool/checkresults/".
#
# [*target*]
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# [*order*]
#   String to set the position in the target file, sorted alpha numeric. Defaults to 30.
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
define icinga2::object::compatlogger (
  $ensure               = present,
  $log_dir              = undef,
  $rotation_method      = undef,
  $order                = '30',
  $target,
){
  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($target)
  validate_integer ( $order )

  if $log_dir { validate_absolute_path($log_dir) }
  if $rotation_method {
    validate_re($rotation_method, [ '^HOURLY$', '^DAILY$', '^WEEKLY$', '^MONTHLY$' ],
      "${rotation_method} isn't supported. Valid values are 'HOURLY', 'DAILY', 'WEEKLY' and 'MONTHLY'.")
  }

  # compose the attributes
  $attrs = {
    'log_dir'         => $log_dir,
    'rotation_method' => $rotation_method,
  }

  # create object
  icinga2::object { "icinga2::object::CompatLogger::${title}":
    ensure      => $ensure,
    object_name => $name,
    object_type => 'CompatLogger',
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

  # import library
  concat::fragment { "icinga2::object::CompatLogger::${title}-library":
    target  => $target,
    content => "library \"compat\"\n\n",
    order   => '05',
  }
}