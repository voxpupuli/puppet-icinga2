# == Define: icinga2::object::hostgroup
#
# Manage Icinga2 HostGroup objects.
#
# === Parameters
#
# [*display_name*]
#   A short description of the host group.
#
# [*groups*]
#   An array of nested group names.
#
# [*assign*]
#   Assign host group members using the group assign rules.
#
# [*target*]
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# [*order*]
#   String to set the position in the target file, sorted alpha numeric. Defaults to 10.
#
# === Examples
#
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
define icinga2::object::hostgroup(
  $hostgroup_name = $title,
  $display_name   = undef,
  $groups         = undef,
  $assign         = undef,
  $ignore         = undef,
  $order          = '25',
  $target,
) {

  # validation
  validate_string($hostgroup_name)
  validate_string($order)
  validate_absolute_path($target)

  if $display_name { validate_string($display_name) }
  if $groups { validate_array($groups) }
  if $assign { validate_array($assign) }
  if $ignore { validate_array($ignore) }

  # compose the attributes
  $attrs = {
    display_name   => $display_name,
    groups         => $groups,
    'assign where' => $assign,
    'ignore where' => $ignore,
  }

  # create object
  icinga2::object { "icinga2::object::HostGroup::${title}":
    object_name => $hostgroup_name,
    object_type => 'HostGroup',
    attrs       => $attrs,
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
