# @summary
#   Manage Icinga 2 HostGroup objects.
#
# @example
#   icinga2::object::hostgroup { 'monitoring-hosts':
#     display_name => 'Linux Servers',
#     groups       => [ 'linux-servers' ],
#     target       => '/etc/icinga2/conf.d/groups2.conf',
#     assign       => [ 'host.name == NodeName' ],
#   }
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param hostgroup_name
#   Namevar of the hostgroup.
#
# @param display_name
#   A short description of the host group.
#
# @param groups
#   An array of nested group names.
#
# @param assign
#   Assign host group members using the group rules.
#
# @param ignore
#   Ignore host group members using the group rules.
#
# @param target
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# @param order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
# @param export
#   Export object to destination, collected by class `icinga2::query_objects`.
#
define icinga2::object::hostgroup (
  Stdlib::Absolutepath                 $target,
  Enum['absent', 'present']            $ensure         = present,
  String[1]                            $hostgroup_name = $title,
  Optional[String[1]]                  $display_name   = undef,
  Optional[Array]                      $groups         = undef,
  Array[String[1]]                     $assign         = [],
  Array[String[1]]                     $ignore         = [],
  Variant[String[1], Integer[0]]       $order          = 55,
  Variant[Array[String[1]], String[1]] $export         = [],
) {
  require icinga2::globals

  if $ignore != [] and $assign == [] {
    fail('When attribute ignore is used, assign must be set.')
  }

  # compose the attributes
  $attrs = {
    display_name   => $display_name,
    groups         => $groups,
  }

  # create object
  $config = {
    'object_name' => $hostgroup_name,
    'object_type' => 'HostGroup',
    'attrs'       => delete_undef_values($attrs),
    'attrs_list'  => keys($attrs),
    'assign'      => $assign,
    'ignore'      => $ignore,
  }

  unless empty($export) {
    @@icinga2::config::fragment { "icinga2::object::HostGroup::${title}":
      tag     => prefix(any2array($export), 'icinga2::instance::'),
      content => epp('icinga2/object.conf.epp', $config),
      target  => $target,
      order   => $order,
    }
  } else {
    icinga2::object { "icinga2::object::HostGroup::${title}":
      ensure => $ensure,
      target => $target,
      order  => $order,
      *      => $config,
    }
  }
}
