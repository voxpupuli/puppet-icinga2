class { 'icinga2':
  manage_repo => true,
}

include icinga2::feature::api

icinga2::object::zone { 'global-templates':
  global => true,
}

icinga2::object::apiuser { 'root':
  password    => "icinga",
  permissions => [ "*" ],
  target      => '/etc/icinga2/conf.d/api_user.conf',
}

icinga2::object::apiuser { 'icinga':
  password    => "icinga",
  permissions => [
    {
      permission => "objects/query/Host",
      filter => '{{ regex("^Linux", host.vars.os) }}',
    },
    {
      permission => "objects/query/Service",
      filter => '{{ regex("^Linux", service.vars.os) }}',
    }
  ],
  target      => '/etc/icinga2/conf.d/api_user.conf',
}
