# == Define: icinga2::object::timeperiod
#
# Manage Icinga 2 timeperiod objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*timeperiod_name*]
#   Set the Icinga 2 name of the timeperiod object. Defaults to title of the define resource.
#
# [*display_name*]
# 	A short description of the time period.
#
# [*import*]
#   Sorted List of templates to include. Defaults to [ "legacy-timeperiod" ].
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
#   Destination config file to store this object in. File will be declared on the first run.
#
# [*order*]
#   String to control the position in the target file, sorted alpha numeric.
#
#
define icinga2::object::timeperiod (
  Stdlib::Absolutepath      $target,
  Enum['absent', 'present'] $ensure          = present,
  String                    $timeperiod_name = $title,
  Optional[String]          $display_name    = undef,
  Optional[Hash]            $ranges          = undef,
  Optional[Boolean]         $prefer_includes = undef,
  Optional[Array]           $excludes        = undef,
  Optional[Array]           $includes        = undef,
  Boolean                   $template        = false,
  Array                     $import          = ['legacy-timeperiod'],
  Pattern[/^\d+$/]          $order           = '35',
){

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
    object_name => $timeperiod_name,
    object_type => 'TimePeriod',
    template    => $template,
    import      => $import,
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
