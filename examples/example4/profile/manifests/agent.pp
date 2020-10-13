# Notice: this code contains Puppet 4 syntax! It doesn't run on Puppet 3.
class profile::icinga2::agent(
  Hash                       $parent_endpoints,
  String                     $parent_zone,
  Stdlib::Compat::Ip_address $agent_ip = $::ipaddress,
) {

  contain ::profile::icinga2::plugins

  case $::osfamily {
    'redhat': {
      package { 'epel-release': }
    } # RedHat
  }

  class { '::icinga2':
    manage_repos => true,
    confd        => false,
    features     => ['mainlog'],
  }

  # Feature: api
  class { '::icinga2::feature::api':
    accept_config   => true,
    accept_commands => true,
    zones           => {
      'ZoneName' => {
        'endpoints' => [ 'NodeName' ],
        'parent'    => $parent_zone,
      },
    },
  }

  ::icinga2::object::zone { 'linux-commands':
    global => true,
    order  => '47',
  }

  create_resources('icinga2::object::endpoint', $parent_endpoints)

  ::icinga2::object::zone { $parent_zone:
    endpoints => keys($parent_endpoints),
  }

  @@::icinga2::object::endpoint { $::fqdn:
    target => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
  }

  @@::icinga2::object::zone { $::fqdn:
    endpoints => [ $::fqdn ],
    parent    => $parent_zone,
    target    => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
  }

  @@::icinga2::object::host { $::fqdn:
    # Puppet 4 syntax
    * => merge({
      display_name => $::hostname,
      address      => $agent_ip,
      target       => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
    }, hiera_hash(icinga2::host)),
  }
}
