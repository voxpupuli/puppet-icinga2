# @summary
#   Set a code fragment in a target configuration file. It's not possible to add a fragment to an object.
#
# @example To create a custom configuration add content to a specified target at the position you set in the order parameter.
#   include ::icinga2
#
#   icinga2::object::service { 'load':
#     display_name  => 'Load',
#     apply         => true,
#     check_command => 'load',
#     vars          => {
#       load_wload1 => 'dynamic_threshold(backup, 20, 5)',
#       load_cload1 => 'dynamic_threshold(backup, 40, 10)',
#     },
#     assign        => ['vars.os == Linux'],
#     target        => '/etc/icinga2/example.d/services.conf',
#     order         => 30,
#   }
#
#   icinga2::config::fragment { 'load-function':
#     target  => '/etc/icinga2/example.d/services.conf',
#     order   => 10,
#     content => "globals.dynamic_threshold = function(timeperiod, ivalue, ovalue) {
#     return function() use (timeperiod, ivalue, ovalue) {
#       if (get_time_period(timeperiod).is_inside) {
#         return ivalue
#       } else {
#         return ovalue
#       }
#     }
#   }\n",
#   }
#
# @param content
#   Content to insert in file specified in target.
#
# @param target
#   Destination config file to store in this fragment. File will be declared the
#   first time.
#
# @param code_name
#   Namevar of the fragment.
#
# @param order
#   String or integer to set the position in the target file, sorted in alpha numeric order. Defaults to `00`.
#
define icinga2::config::fragment (
  String                       $content,
  Stdlib::Absolutepath         $target,
  String                       $code_name = $title,
  Variant[String, Integer]     $order     = '00',
) {
  if $facts['os']['family'] != 'windows' {
    Concat {
      owner   => $icinga2::globals::user,
      group   => $icinga2::globals::group,
      seltype => 'icinga2_etc_t',
      mode    => '0640',
    }
  }

  if !defined(Concat[$target]) {
    concat { $target:
      ensure => present,
      tag    => 'icinga2::config::file',
      warn   => true,
    }
  }

  concat::fragment { "icinga2::config::${code_name}":
    target  => $target,
    content => icinga::newline($content),
    order   => $order,
  }
}
