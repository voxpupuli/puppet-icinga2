# @summary
#   Manage Icinga 2 ApiUser objects.
#
# @example Create an user with full permissions:
#   ::icinga2::object::apiuser { 'director':
#     ensure      => present,
#     password    => 'Eih5Weefoo2oa8sh',
#     permissions => [ '*' ],
#     target      => '/etc/icinga2/conf.d/api-users.conf',
#   }
#
# @example Create an user with restricted permissions for Icinga Web 2:
#   ::icinga2::object::apiuser { 'icingaweb2':
#     ensure      => present,
#     password    => '12e2ef553068b519',
#     permissions => [ 'status/query', 'actions/*', 'objects/modify/*', 'objects/query/*' ],
#     target      => '/etc/icinga2/conf.d/api-users.conf',
#   }
#
# @example Create user who's only allowed to query hosts and services:
#   ::icinga2::object::apiuser { 'read':
#     ensure      => present,
#     password    => 'read',
#     permissions => [
#       {
#         permission => 'objects/query/Host',
#         filter     => '{{ regex("^Linux", host.vars.os) }}'
#       },
#       { 
#         permission => 'objects/query/Service',
#         filter     => '{{ regex("^Linux", host.vars.os) }}'
#       },
#     ],
#     target      => '/etc/icinga2/conf.d/api-users.conf',
#   }
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param apiuser_name
#   Set the name of the apiuser object.
#
# @param password
#   Password string. The password parameter isn't parsed anymore.
#
# @param client_cn
#   Optional. Client Common Name (CN).
#
# @param permissions
#   Array of permissions. Either as string or dictionary with the keys permission
#   and filter. The latter must be specified as function.
#
# @param target
#   Destination config file to store in this object. File will be declared at the
#   first time.
#
# @param [Variant[String, Integer]] order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
define icinga2::object::apiuser(
  Stdlib::Absolutepath                          $target,
  Enum['absent', 'present']                     $ensure       = present,
  String                                        $apiuser_name = $title,
  Optional[Array]                               $permissions  = undef,
  Optional[Variant[String, Sensitive[String]]]  $password     = undef,
  Optional[String]                              $client_cn    = undef,
  Variant[String, Integer]                      $order        = 30,
) {

  $_password = if $password =~ String {
    Sensitive($password)
  } elsif $password =~ Sensitive {
    $password
  } else {
    undef
  }

  # compose the attributes
  $attrs = {
    password    => $_password,
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
  }
}
