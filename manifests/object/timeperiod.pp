# == Define: icinga2::object::timeperiod
#
# Manage Icinga2 timeperiod objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*display_name*]
# 	A short description of the time period.
#
# [*update*]
# 	The "update" script method takes care of updating the internal
#   representation of the time period. In virtually all cases you should import
#   the "legacy-timeperiod" template to take care of this setting.
#
# [*ranges*]
# 	A dictionary containing information which days and durations apply to this
#   timeperiod.
#
# [*prefer_includes*]
# 	Boolean whether to prefer timeperiods includes or excludes. Default to true.
#
# [*excludes*]
# 	An array of timeperiods, which should exclude from your timerange.
#
# [*includes*]
# 	An array of timeperiods, which should include into your timerange
#
# [*template*]
#   Set to true creates a template instead of an object. Defaults to false.
#
# [*target*]
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# [*target*]
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# [*order*]
#   String to control the position in the target file, sorted alpha numeric.
#
# === Authors
#
# Alessandro Lorenzi <alessandro@lm-net.it>
# Icinga Development Team <info@icinga.org>
#
define icinga2::object::timeperiod (
  $ensure           = present,
  $display_name     = $title,
  $ranges           = undef,
  $prefer_includes  = undef,
  $excludes         = undef,
  $includes         = undef,
  $template         = false,
  $import           = ['legacy-timeperiod'],
  $target           = undef,
  $order            = '10',
){
  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_array($import)
  validate_bool($template)
  validate_absolute_path($target)
  validate_string($order)


  if $display_name { validate_string ($display_name) }
  validate_hash ($ranges)
  if $prefer_includes { validate_bool ($prefer_includes) }
  if $excludes { validate_string ($excludes) }
  if $includes { validate_string ($includes) }

  # compose attributes
  $attrs = {
    'display_name'    => $display_name,
    'ranges'          => $ranges,
    'prefer_includes' => $prefer_includes,
    'excludes'        => $excludes,
    'includes'        => $includes,
  }

  # create object
  icinga2::object { "icinga2::object::TimePeriod::${title}":
    ensure      => $ensure,
    object_name => $name,
    object_type => 'TimePeriod',
    template    => $template,
    import      => $import,
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
