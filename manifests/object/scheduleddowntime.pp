# @summary
#   Manage Icinga 2 scheduleddowntime objects.
#
# @param [Enum['absent', 'present']] ensure
#   Set to present enables the object, absent disables it.
#
# @param [String] scheduleddowntime_name
#   Set the Icinga 2 name of the scheduleddowntime object.
#
# @param [Optional[String]] host_name
#   The name of the host this comment belongs to.
#
# @param [Optional[String]] service_name
#   The short name of the service this comment belongs to. If omitted, this comment object is treated as host comment.
#
# @param [Optional[String]] author
#   The author's name.
#
# @param [Optional[String]] comment
#   The comment text.
#
# @param [Optional[Boolean]] fixed
#   Whether this is a fixed downtime.
#
# @param [Optional[Icinga2::Interval]] duration
#   The duration as number.
#
# @param [Optional[Hash]] ranges
#   A dictionary containing information which days and durations apply to this timeperiod.
#
# @param [Variant[Boolean, String]] apply
#   Dispose an apply instead an object if set to 'true'. Value is taken as statement,
#   i.e. 'vhost => config in host.vars.vhosts'.
#
# @param [Variant[Boolean, String]] prefix
#   Set scheduleddowntime_name as prefix in front of 'apply for'. Only effects if apply is a string.
#
# @param [Enum['Host', 'Service']] apply_target
#   An object type on which to target the apply rule. Valid values are `Host` and `Service`.
#
# @param [Array] assign
#   Assign user group members using the group assign rules.
#
# @param [Array] ignore
#   Exclude users using the group ignore rules.
#
# @param [Stdlib::Absolutepath] target
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# @param [Variant[String, Integer]] order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
define icinga2::object::scheduleddowntime (
  Stdlib::Absolutepath            $target,
  Enum['absent', 'present']       $ensure                 = present,
  String                          $scheduleddowntime_name = $title,
  Optional[String]                $host_name              = undef,
  Optional[String]                $service_name           = undef,
  Optional[String]                $author                 = undef,
  Optional[String]                $comment                = undef,
  Optional[Boolean]               $fixed                  = undef,
  Optional[Icinga2::Interval]     $duration               = undef,
  Optional[Hash]                  $ranges                 = undef,
  Variant[Boolean, String]        $apply                  = false,
  Variant[Boolean, String]        $prefix                 = false,
  Enum['Host', 'Service']         $apply_target           = 'Host',
  Array                           $assign                 = [],
  Array                           $ignore                 = [],
  Variant[String, Integer]        $order                  = 90,
){

  # compose attributes
  $attrs = {
    'host_name'    => $host_name,
    'service_name' => $service_name,
    'author'       => $author,
    'comment'      => $comment,
    'fixed'        => $fixed,
    'duration'     => $duration,
    'ranges'       => $ranges,
  }

  # create object
  icinga2::object { "icinga2::object::ScheduledDowntime::${title}":
    ensure       => $ensure,
    object_name  => $scheduleddowntime_name,
    object_type  => 'ScheduledDowntime',
    attrs        => delete_undef_values($attrs),
    attrs_list   => keys($attrs),
    apply        => $apply,
    prefix       => $prefix,
    apply_target => $apply_target,
    assign       => $assign,
    ignore       => $ignore,
    target       => $target,
    order        => $order,
  }

}
