# == Define: icinga2::object::apiuser
#
# Manage Icinga 2 ApiUser objects.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the object, absent disables it. Defaults to present.
#
# [*apiuser_name*]
#   Set the name of the apiuser object. Defaults to title of the define resource.
#
# [*password*]
#   Password string.
#
# [*client_cn*]
#   Optional. Client Common Name (CN).
#
# [*permissions*]
#   Array of permissions. Either as string or dictionary with the keys permission
#   and filter. The latter must be specified as function.
#
# [*target*]
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# [*order*]
#   String or integer to set the position in the target file, sorted alpha numeric. Defaults to 10.
#
# === Examples
#
# ::icinga2::object::apiuser { 'director':
#   ensure      => present,
#   password    => 'Eih5Weefoo2oa8sh',
#   permissions => [ "*" ],
#   target      => '/etc/icinga2/conf.d/api-users.conf',
# }
#
# ::icinga2::object::apiuser { 'icingaweb2':
#   ensure      => present,
#   password    => '12e2ef553068b519',
#   permissions => [ 'status/query', 'actions/*', 'objects/modify/*', 'objects/query/*' ],
#   target      => '/etc/icinga2/conf.d/api-users.conf',
# }
#
# ::icinga2::object::apiuser { 'read':
#   ensure      => present,
#   password    => 'read',
#   permissions => [
#     {
#       permission => 'objects/query/Host',
#       filter     => '{{ regex("^Linux", host.vars.os) }}'
#     },
#     { 
#       permission => 'objects/query/Service',
#       filter     => '{{ regex("^Linux", host.vars.os) }}'
#     },
#   ],
#   target      => '/etc/icinga2/conf.d/api-users.conf',
# }
#
#
define icinga2::object::apiuser(
  Stdlib::Absolutepath        $target,
  Array                       $permissions,
  Enum['absent', 'present']   $ensure       = present,
  String                      $apiuser_name = $title,
  Optional[String]            $password     = undef,
  Optional[String]            $client_cn    = undef,
  Variant[String, Integer]    $order        = 30,
) {

  # compose the attributes
  $attrs = {
    password    => $password,
    client_cn   => $client_cn,
    permissions => $permissions,
  }

  # create object
  icinga2::object { "icinga2::object::ApiUser::${title}":
    ensure      => $ensure,
    object_name => $apiuser_name,
    object_type => 'ApiUser',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $target,
    order       => $order,
    notify      => Class['::icinga2::service'],
  }
}
