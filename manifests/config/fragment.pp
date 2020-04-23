# @summary
#   Set a code fragment in a target configuration file.
#
# @example To create a custom configuration add content to a specified target at the position you set in the order parameter. You can use also templates to add content.
#   include ::icinga2
#
#   icinga2::object::service { 'load':
#     display_name  => 'Load',
#     apply         => true,
#     check_command => 'load',
#     assign        => ['vars.os == Linux'],
#     target        => '/etc/icinga2/conf.d/service_load.conf',
#     order         => 30,
#   }
#
#   icinga2::config::fragment { 'load-function':
#     target => '/etc/icinga2/conf.d/service_load.conf',
#     order => 10,
#     content => 'vars.load_wload1 = {{
#       if (get_time_period("backup").is_inside) {
#         return 20
#       } else {
#         return 5
#       }
#     }}',
#   }
#
# @param [String] content
#   Content to insert in file specified in target.
#
# @param [Stdlib::Absolutepath]target
#   Destination config file to store in this fragment. File will be declared the
#   first time.
#
# @param [Variant[String, Integer]] order
#   String or integer to set the position in the target file, sorted in alpha numeric order. Defaults to `00`.
#
define icinga2::config::fragment(
  String                       $content,
  Stdlib::Absolutepath         $target,
  String                       $code_name = $title,
  Variant[String, Integer]     $order     = '00',
) {

  case $::osfamily {
    'windows': {
      $_content = regsubst($content, '\n', "\r\n", 'EMG')
    } # windows
    default: {
      Concat {
        owner => $::icinga2::globals::user,
        group => $::icinga2::globals::group,
        mode  => '0640',
      }
      $_content = $content
    } # default
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
    content => $_content,
    order   => $order,
  }

}
