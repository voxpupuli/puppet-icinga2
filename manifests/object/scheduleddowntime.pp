# == Define: icinga2::object::scheduleddowntime
#
# Manage Icinga2 scheduleddowntime objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the endpoint object, absent disables it. Defaults to present.
# 
# [*host_name*]
#     The name of the host this comment belongs to.
#
# [*service_name*]
#     The short name of the service this comment belongs to. If omitted, this comment object is treated as host comment.
#
# [*author*]
#     The author's name.
#
# [*comment*]
#     The comment text.
#
# [*fixed*]
#     Whether the downtime is fixed (true) or flexible (false). Defaults to flexible. Details in the advanced topics chapter.
#
# [*duration*]
#     The duration as number.
#
# [*ranges*]
#     A dictionary containing information which days and durations apply to this timeperiod.
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
define icinga2::object::scheduleddowntime (
  $ensure               = present,
  $host_name            = undef,
  $service_name         = undef,
  $author               = undef,
  $comment              = undef,
  $fixed                = undef,
  $duration             = undef,
  $ranges               = undef,
  $order                = '30',
  $target               = undef,
){
  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  # validation
  validate_re($ensure, [ '^present$', '^absent$' ],
    "${ensure} isn't supported. Valid values are 'present' and 'absent'.")
  validate_absolute_path($target)
  validate_integer ( $order )

  validate_string($host_name)
  if $service_name { validate_string ($service_name) }
  validate_string($author)
  validate_string($comment)
  if $fixed { validate_bool($fixed) }
  validate_integer($duration)
  validate_hash($ranges)

  # compose attributes
  $attrs = {
    'host_name'    => $host_name,
    'service_name' => $service_name,
    'author'       => $author,
    'comment'      => $comment,
    'start_time'   => $start_time,
    'end_time'     => $end_time,
    'duration'     => $duration,
    'entry_time'   => $entry_time,
    'fixed'        => $fixed,
    'triggers'     => $triggers,
  }

  # create object
  icinga2::object { "icinga2::object::ScheduledDowntime::${title}":
    ensure      => $ensure,
    object_name => $name,
    object_type => 'ScheduledDowntime',
    template    => $template,
    import      => $import,
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }

}
