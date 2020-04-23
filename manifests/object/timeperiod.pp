# @summary
#   Manage Icinga 2 timeperiod objects.
#
# @param [Enum['absent', 'present']] ensure
#   Set to present enables the object, absent disables it.
#
# @param [String] timeperiod_name
#   Set the Icinga 2 name of the timeperiod object.
#
# @param [Optional[String]] display_name
#   A short description of the time period.
#
# @param [Array] import
#   Sorted List of templates to include.
#
# @param [Optional[Hash]] ranges
#   A dictionary containing information which days and durations apply to this
#   timeperiod.
#
# @param [Optional[Boolean]] prefer_includes
#   Boolean whether to prefer timeperiods includes or excludes.
#
# @param [Optional[Array]] excludes
#   An array of timeperiods, which should exclude from your timerange.
#
# @param [Optional[Array]] includes
#   An array of timeperiods, which should include into your timerange
#
# @param [Boolean] template
#   Set to true creates a template instead of an object.
#
# @param [Stdlib::Absolutepath] target
#   Destination config file to store this object in. File will be declared on the first run.
#
# @param [Variant[String, Integer]] order
#   String or integer to control the position in the target file, sorted alpha numeric.
#
define icinga2::object::timeperiod (
  Stdlib::Absolutepath         $target,
  Enum['absent', 'present']    $ensure          = present,
  String                       $timeperiod_name = $title,
  Optional[String]             $display_name    = undef,
  Optional[Hash]               $ranges          = undef,
  Optional[Boolean]            $prefer_includes = undef,
  Optional[Array]              $excludes        = undef,
  Optional[Array]              $includes        = undef,
  Boolean                      $template        = false,
  Array                        $import          = ['legacy-timeperiod'],
  Variant[String, Integer]     $order           = 35,
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
  }

}
