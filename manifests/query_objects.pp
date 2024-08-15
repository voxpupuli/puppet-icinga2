# @summary
#   Class to query `icinga2::objects` from puppetdb.
#
# @param destination
#   Destination equal to what was set in parameter `export` for objects.
#
# @param environments
#   limits the response to objects of these environments if set, all environments if list is empty
#
class icinga2::query_objects (
  String[1]        $destination  = $facts['networking']['fqdn'],
  Array[String[1]] $environments = [$environment],
) {
  $_environments = if empty($environments) {
    ''
  } else {
    sprintf("environment in ['%s'] and", join($environments, "','"))
  }

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

  $pql_query =  puppetdb_query("resources[parameters] { ${_environments} type = 'Icinga2::Config::Fragment' and exported = true and tag = 'icinga2::instance::${destination}' and nodes { deactivated is null and expired is null } order by certname, title }")

  $file_list = $pql_query.map |$object| {
    $object['parameters']['target']
  }

  unique($file_list).each |$target| {
    $objects = $pql_query.filter |$object| { $target == $object['parameters']['target'] }

    $_content = $objects.reduce('') |String $memo, $object| {
      "${memo}${object['parameters']['content']}"
    }

    if !defined(Concat[$target]) {
      concat { $target:
        ensure => present,
        tag    => 'icinga2::config::file',
        warn   => true,
      }
    }

    concat::fragment { "custom-${target}":
      target  => $target,
      content => $_content,
      order   => 99,
    }
  }
}
