# @summary
#   Manage Icinga 2 scheduleddowntime objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param scheduleddowntime_name
#   Set the Icinga 2 name of the scheduleddowntime object.
#
# @param host_name
#   The name of the host this comment belongs to.
#
# @param service_name
#   The short name of the service this comment belongs to. If omitted, this comment object is treated as host comment.
#
# @param author
#   The author's name.
#
# @param comment
#   The comment text.
#
# @param fixed
#   Whether this is a fixed downtime.
#
# @param duration
#   The duration as number.
#
# @param ranges
#   A dictionary containing information which days and durations apply to this timeperiod.
#
# @param apply
#   Dispose an apply instead an object if set to 'true'. Value is taken as statement,
#   i.e. 'vhost => config in host.vars.vhosts'.
#
# @param prefix
#   Set scheduleddowntime_name as prefix in front of 'apply for'. Only effects if apply is a string.
#
# @param apply_target
#   An object type on which to target the apply rule. Valid values are `Host` and `Service`.
#
# @param assign
#   Assign user group members using the group assign rules.
#
# @param ignore
#   Exclude users using the group ignore rules.
#
# @param target
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# @param order
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
