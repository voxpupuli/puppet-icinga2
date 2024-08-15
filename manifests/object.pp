# @summary
#   Define resource to used by this module only.
#
# @api private
#
# @param ensure
#   Set to present enables the object, absent disabled it.
#
# @param object_name
#   Set the icinga2 name of the object.
#
# @param template
#   Set to true will define a template otherwise an object.
#   Ignored if apply is set.
#
# @param apply
#   Dispose an apply instead an object if set to 'true'. Value is taken as statement,
#   i.e. 'vhost => config in host.vars.vhosts'.
#
# @param prefix
#   Set object_name as prefix in front of 'apply for'. Only effects if apply is a string.
#
# @param apply_target
#   Optional for an object type on which to target the apply rule. Valid values are `Host` and `Service`.
#
# @param import
#   A sorted list of templates to import in this object.
#
# @param assign
#   Array of assign rules.
#
# @param ignore
#   Array of ignore rules.
#
# @param attrs
#   Hash for the attributes of this object. Keys are the attributes and
#   values are there values.
#
# @param object_type
#   Icinga 2 object type for this object.
#
# @param target
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# @param order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
# @param attrs_list
#   Array of all possible attributes for this object type.
#
define icinga2::object (
  String[1]                                                   $object_type,
  Stdlib::Absolutepath                                        $target,
  Variant[String[1], Integer[0]]                              $order,
  Enum['present', 'absent']                                   $ensure       = present,
  String[1]                                                   $object_name  = $title,
  Boolean                                                     $template     = false,
  Variant[Boolean, Pattern[/^.+\s+(=>\s+.+\s+)?in\s+.+$/]]    $apply        = false,
  Array[String[1]]                                            $attrs_list   = [],
  Optional[Enum['Host', 'Service']]                           $apply_target = undef,
  Variant[Boolean, String[1]]                                 $prefix       = false,
  Array[String[1]]                                            $import       = [],
  Array[String[1]]                                            $assign       = [],
  Array[String[1]]                                            $ignore       = [],
  Hash[String[1], Any]                                        $attrs        = {},
) {
  assert_private()

  case $facts['os']['family'] {
    'windows': {
    } # windows
    default: {
      Concat {
        owner   => $icinga2::globals::user,
        group   => $icinga2::globals::group,
        seltype => 'icinga2_etc_t',
        mode    => '0640',
      }
    } # default
  }

  if $object_type == $apply_target {
    fail('The object type must be different from the apply target')
  }

  $_object = epp('icinga2/object.conf.epp',
    { 'attrs'        => $attrs,
      'attrs_list'   => $attrs_list,
      'apply'        => $apply,
      'apply_target' => $apply_target,
      'prefix'       => $prefix,
      'object_type'  => $object_type,
      'object_name'  => $object_name,
      'template'     => $template,
      'import'       => $import,
      'assign'       => $assign,
      'ignore'       => $ignore,
    }
  )

  if !defined(Concat[$target]) {
    concat { $target:
      ensure => present,
      tag    => 'icinga2::config::file',
      warn   => true,
    }
  }

  if $ensure != 'absent' {
    concat::fragment { $title:
      target  => $target,
      content => icinga::newline($_object),
      order   => $order,
    }
  }
}
