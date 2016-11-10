# == Define: icinga2::object::comment
#
# Manage Icinga2 Comment objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the endpoint object, absent disables it. Defaults to present.
#
# [*host_name*]
#    The name of the host this comment belongs to.
#
# [*service_name*]
#    The short name of the service this comment belongs to. If omitted, this comment object is treated as host comment.
#
# [*author*]
#    The author's name.
#
# [*text*]
#    The comment text.
#
# [*entry_time*]
#    The unix timestamp when this comment was added.
#
# [*entry_type*]
#    The comment type (User = 1, Downtime = 2, Flapping = 3, Acknowledgement = 4).
#
# [*expire_time*]
#    The comment's expire time as unix timestamp.
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
define icinga2::object::comment (
  $ensure               = present,
  $host_name            = undef,
  $service_name         = undef,
  $author               = undef,
  $text                 = undef,
  $entry_time           = undef,
  $entry_type           = undef,
  $expire_time          = undef,
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

  if $host_name { validate_string($host_name) }
  if $service_name { validate_string($service_name) }
  if $author { validate_string($author) }
  if $text { validate_string($text) }
  if $entry_time { validate_integer($entry_time) }
  if $entry_type { validate_integer($entry_type) }
  if $expire_time { validate_integer($expire_time) }

  # compose the attributes
  $attrs = {
    'host_name'    => $host_name,
    'service_name' => $service_name,
    'author'       => $author,
    'text'         => $text,
    'entry_time'   => $entry_time,
    'entry_type'   => $entry_type,
    'expire_time'  => $expire_time,
  }

  # create object
  icinga2::object { "icinga2::object::Comment::${title}":
    ensure      => $ensure,
    object_name => $name,
    object_type => 'Comment',
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
