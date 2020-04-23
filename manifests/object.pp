# @summary
#   Define resource to used by this module only.
#
# @api private
#
# @param [Enum['present', 'absent']] ensure
#   Set to present enables the object, absent disabled it.
#
# @param [String] object_name
#   Set the icinga2 name of the object.
#
# @param [Boolean] template
#   Set to true will define a template otherwise an object.
#   Ignored if apply is set.
#
# @param [Variant[Boolean, Pattern[/^.+\s+(=>\s+.+\s+)?in\s+.+$/]]] apply
#   Dispose an apply instead an object if set to 'true'. Value is taken as statement,
#   i.e. 'vhost => config in host.vars.vhosts'.
#
# @param [Variant[Boolean, String]] prefix
#   Set object_name as prefix in front of 'apply for'. Only effects if apply is a string.
#
# @param [Optional[Enum['Host', 'Service']]] apply_target
#   Optional for an object type on which to target the apply rule. Valid values are `Host` and `Service`.
#
# @param [Array] import
#   A sorted list of templates to import in this object.
#
# @param [Array] assign
#   Array of assign rules.
#
# @param [Array] ignore
#   Array of ignore rules.
#
# @param [Hash] attrs
#   Hash for the attributes of this object. Keys are the attributes and
#   values are there values.
#
# @param [String] object_type
#   Icinga 2 object type for this object.
#
# @param [Stdlib::Absolutepath] target
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# @param [Variant[String, Integer]] order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
# @param [Array] attrs_list
#   Array of all possible attributes for this object type.
#
define icinga2::object(
  String                                                      $object_type,
  Stdlib::Absolutepath                                        $target,
  Variant[String, Integer]                                    $order,
  Enum['present', 'absent']                                   $ensure       = present,
  String                                                      $object_name  = $title,
  Boolean                                                     $template     = false,
  Variant[Boolean, Pattern[/^.+\s+(=>\s+.+\s+)?in\s+.+$/]]    $apply        = false,
  Array                                                       $attrs_list   = [],
  Optional[Enum['Host', 'Service']]                           $apply_target = undef,
  Variant[Boolean, String]                                    $prefix       = false,
  Array                                                       $import       = [],
  Array                                                       $assign       = [],
  Array                                                       $ignore       = [],
  Hash                                                        $attrs        = {},
) {

  assert_private()

  case $::osfamily {
    'windows': {
    } # windows
    default: {
      Concat {
        owner => 'root',
        group => $::icinga2::globals::group,
        mode  => '0640',
      }
    } # default
  }

  if $object_type == $apply_target {
    fail('The object type must be different from the apply target')
  }

  $_attrs = merge($attrs, {
    'assign where' => $assign,
    'ignore where' => $ignore,
  })

  $_content = $::osfamily ? {
    'windows' => regsubst(template('icinga2/object.conf.erb'), '\n', "\r\n", 'EMG'),
    default   => template('icinga2/object.conf.erb'),
  }

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
      content => $_content,
      order   => $order,
    }
  }

}
