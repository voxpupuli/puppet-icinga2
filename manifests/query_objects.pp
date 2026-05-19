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
      File {
        owner   => $icinga2::globals::user,
        group   => $icinga2::globals::group,
        seltype => 'icinga2_etc_t',
        mode    => '0640',
      }
    } # default
  }

  $pql_query =  puppetdb_query("resources[parameters] { ${_environments} type = 'Icinga2::Config::Fragment' and exported = true and tag = 'icinga2::instance::${destination}' and nodes { deactivated is null and expired is null } order by certname, title }")

  $_files = $pql_query.reduce({}) |Hash $memo, Hash $object| {
    $_parameters       = $object['parameters']
    $_target           = $_parameters['target']
    $_existing_content = $memo[$_target] ? {
      undef   => '',
      default => $memo[$_target]['content'],
    }
    $_content = $_parameters['ensure'] ? {
      'absent' => $_existing_content,
      default  => "${_existing_content}${_parameters['content']}",
    }

    $memo + {
      $_target => {
        'ensure'  => file,
        'tag'     => 'icinga2::config::file',
        'content' => $_content,
      },
    }
  }

  create_resources('file', $_files)
}
