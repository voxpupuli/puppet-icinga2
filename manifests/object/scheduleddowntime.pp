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
# @param export
#   Export object to destination, collected by class `icinga2::query_objects`.
#
define icinga2::object::scheduleddowntime (
  Stdlib::Absolutepath                  $target,
  Enum['absent', 'present']             $ensure                 = present,
  String[1]                             $scheduleddowntime_name = $title,
  Optional[String[1]]                   $host_name              = undef,
  Optional[String[1]]                   $service_name           = undef,
  Optional[String[1]]                   $author                 = undef,
  Optional[String[1]]                   $comment                = undef,
  Optional[Boolean]                     $fixed                  = undef,
  Optional[Icinga2::Interval]           $duration               = undef,
  Optional[Hash]                        $ranges                 = undef,
  Variant[Boolean, String[1]]           $apply                  = false,
  Variant[Boolean, String[1]]           $prefix                 = false,
  Enum['Host', 'Service']               $apply_target           = 'Host',
  Array[String[1]]                      $assign                 = [],
  Array[String[1]]                      $ignore                 = [],
  Variant[String[1], Integer[1]]        $order                  = 90,
  Variant[Array[String[1]], String[1]]  $export                 = [],
) {
  require icinga2::globals

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
  $config = {
    'object_name'  => $scheduleddowntime_name,
    'object_type'  => 'ScheduledDowntime',
    'attrs'        => delete_undef_values($attrs),
    'attrs_list'   => keys($attrs),
    'apply'        => $apply,
    'prefix'       => $prefix,
    'apply_target' => $apply_target,
    'assign'       => $assign,
    'ignore'       => $ignore,
  }

  unless empty($export) {
    @@icinga2::config::fragment { "icinga2::object::ScheduledDowntime::${title}":
      tag     => prefix(any2array($export), 'icinga2::instance::'),
      content => epp('icinga2/object.conf.epp', $config),
      target  => $target,
      order   => $order,
    }
  } else {
    icinga2::object { "icinga2::object::ScheduledDowntime::${title}":
      ensure => $ensure,
      target => $target,
      order  => $order,
      *      => $config,
    }
  }
}
