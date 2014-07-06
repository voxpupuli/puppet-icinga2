# == Class: icinga2::server::config
#
# This class configures the server components for the Icinga 2 monitoring system.
#
# === Parameters
#
# Coming soon...
#
# === Examples
# 
# Coming soon...
# 

class icinga2::server::config inherits icinga2::server {
  
  include icinga2::params
  
  #Directory resource for /etc/icinga2/:
  file { '/etc/icinga2/':
    path    => '/etc/icinga2/',
    ensure  => directory,
    owner   => $etc_icinga2_owner,
    group   => $etc_icinga2_group,
    mode    => $etc_icinga2_mode,
    #require => Package[$icinga2::params::icinga2_server_packages],
  }

  #File resource for /etc/icinga2/icinga2.conf:
  file { '/etc/icinga2/icinga2.conf':
    path    => '/etc/icinga2/icinga2.conf',
    ensure  => file,
    owner   => $etc_icinga2_icinga2_conf_owner,
    group   => $etc_icinga2_icinga2_conf_group,
    mode    => $etc_icinga2_icinga2_conf_mode,
    content => template('icinga2/icinga2.conf.erb'),
  }

  #Directory resource for /etc/icinga2/conf.d/:
  file { '/etc/icinga2/conf.d/':
    path    => '/etc/icinga2/conf.d/',
    ensure  => directory,
    owner   => $etc_icinga2_confd_owner,
    group   => $etc_icinga2_confd_group,
    mode    => $etc_icinga2_confd_mode,
  }

  #Directory resource for /etc/icinga2/features-available/:
  file { '/etc/icinga2/features-available/':
    path    => '/etc/icinga2/features-available/',
    ensure  => directory,
    owner   => $etc_icinga2_features_available_owner,
    group   => $etc_icinga2_features_available_group,
    mode    => $etc_icinga2_features_available_mode,
  }

  #Directory resource for /etc/icinga2/features-enabled/:
  file { '/etc/icinga2/features-enabled/':
    path    => '/etc/icinga2/features-enabled/',
    ensure  => directory,
    owner   => $etc_icinga2_features_enabled_owner,
    group   => $etc_icinga2_features_enabled_group,
    mode    => $etc_icinga2_features_enabled_mode,
  }
  
  #Directory resource for /etc/icinga2/pki/:
  file { '/etc/icinga2/pki/':
    path    => '/etc/icinga2/pki/',
    ensure  => directory,
    owner   => $etc_icinga2_pki_owner,
    group   => $etc_icinga2_pki_group,
    mode    => $etc_icinga2_pki_mode,
  }

  #Directory resource for /etc/icinga2/scripts/:
  file { '/etc/icinga2/scripts/':
    path    => '/etc/icinga2/scripts/',
    ensure  => directory,
    owner   => $etc_icinga2_scripts_owner,
    group   => $etc_icinga2_scripts_group,
    mode    => $etc_icinga2_scripts_mode,
  }

  #Directory resource for /etc/icinga2/zones.d/:
  file { '/etc/icinga2/zones.d/':
    path    => '/etc/icinga2/zones.d/',
    ensure  => directory,
    owner   => $etc_icinga2_zonesd_owner,
    group   => $etc_icinga2_zonesd_group,
    mode    => $etc_icinga2_zonesd_mode,
  }

  #File and directory resources for the object directories that can be used to hold different
  #types of configuration objects
  
  #Directory resource for /etc/icinga2/objects/:
  file { '/etc/icinga2/objects/':
    path    => '/etc/icinga2/objects/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_owner,
    group   => $etc_icinga2_obejcts_group,
    mode    => $etc_icinga2_obejcts_mode,
  }

  #Directory resource for /etc/icinga2/objects/hosts/:
  file { '/etc/icinga2/objects/hosts/':
    path    => '/etc/icinga2/objects/hosts/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/hostgroups/:
  file { '/etc/icinga2/objects/hostgroups/':
    path    => '/etc/icinga2/objects/hostgroups/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/services/:
  file { '/etc/icinga2/objects/services/':
    path    => '/etc/icinga2/objects/services/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/servicegroups/:
  file { '/etc/icinga2/objects/servicegroups/':
    path    => '/etc/icinga2/objects/servicegroups/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/users/:
  file { '/etc/icinga2/objects/users/':
    path    => '/etc/icinga2/objects/users/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/usergroups/:
  file { '/etc/icinga2/objects/usergroups/':
    path    => '/etc/icinga2/objects/usergroups/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/checkcommands/:
  file { '/etc/icinga2/objects/checkcommands/':
    path    => '/etc/icinga2/objects/checkcommands/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/notificationcommands/:
  file { '/etc/icinga2/objects/notificationcommands/':
    path    => '/etc/icinga2/objects/notificationcommands/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/eventcommands/:
  file { '/etc/icinga2/objects/eventcommands/':
    path    => '/etc/icinga2/objects/eventcommands/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/notifications/:
  file { '/etc/icinga2/objects/notifications/':
    path    => '/etc/icinga2/objects/notifications/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/timeperiods/:
  file { '/etc/icinga2/objects/timeperiods/':
    path    => '/etc/icinga2/objects/timeperiods/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/scheduleddowntimes/:
  file { '/etc/icinga2/objects/scheduleddowntimes/':
    path    => '/etc/icinga2/objects/scheduleddowntimes/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/dependencies/:
  file { '/etc/icinga2/objects/dependencies/':
    path    => '/etc/icinga2/objects/dependencies/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/perfdatawriters/:
  file { '/etc/icinga2/objects/perfdatawriters/':
    path    => '/etc/icinga2/objects/perfdatawriters/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/graphitewriters/:
  file { '/etc/icinga2/objects/graphitewriters/':
    path    => '/etc/icinga2/objects/graphitewriters/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/idomysqlconnections/:
  file { '/etc/icinga2/objects/idomysqlconnections/':
    path    => '/etc/icinga2/objects/idomysqlconnections/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/idopgsqlconnections/:
  file { '/etc/icinga2/objects/idopgsqlconnections/':
    path    => '/etc/icinga2/objects/idopgsqlconnections/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/livestatuslisteners/:
  file { '/etc/icinga2/objects/livestatuslisteners/':
    path    => '/etc/icinga2/objects/livestatuslisteners/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/statusdatawriters/:
  file { '/etc/icinga2/objects/statusdatawriters/':
    path    => '/etc/icinga2/objects/statusdatawriters/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/externalcommandlisteners/:
  file { '/etc/icinga2/objects/externalcommandlisteners/':
    path    => '/etc/icinga2/objects/externalcommandlisteners/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/compatloggers/:
  file { '/etc/icinga2/objects/compatloggers/':
    path    => '/etc/icinga2/objects/compatloggers/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/checkresultreaders/:
  file { '/etc/icinga2/objects/checkresultreaders/':
    path    => '/etc/icinga2/objects/checkresultreaders/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/checkercomponents/:
  file { '/etc/icinga2/objects/checkercomponents/':
    path    => '/etc/icinga2/objects/checkercomponents/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/notificationcomponents/:
  file { '/etc/icinga2/objects/notificationcomponents/':
    path    => '/etc/icinga2/objects/notificationcomponents/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/fileloggers/:
  file { '/etc/icinga2/objects/fileloggers/':
    path    => '/etc/icinga2/objects/fileloggers/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/syslogloggers/:
  file { '/etc/icinga2/objects/syslogloggers/':
    path    => '/etc/icinga2/objects/syslogloggers/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/icingastatuswriters/:
  file { '/etc/icinga2/objects/icingastatuswriters/':
    path    => '/etc/icinga2/objects/icingastatuswriters/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/apilisteners/:
  file { '/etc/icinga2/objects/apilisteners/':
    path    => '/etc/icinga2/objects/apilisteners/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/endpoints/:
  file { '/etc/icinga2/objects/endpoints/':
    path    => '/etc/icinga2/objects/endpoints/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/zones/:
  file { '/etc/icinga2/objects/zones/':
    path    => '/etc/icinga2/objects/zones/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/applys/
  #The files in this folder will be objects like 
  #'apply something blah to Host...'
  #See the following link for more info:
  # http://docs.icinga.org/icinga2/latest/doc/module/icinga2/toc#!/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#apply
  file { '/etc/icinga2/objects/applys/':
    path    => '/etc/icinga2/objects/applys/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/templates/:
  file { '/etc/icinga2/objects/templates/':
    path    => '/etc/icinga2/objects/templates/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }


  #Directory resource for /etc/icinga2/objects/constants/:
  file { '/etc/icinga2/objects/constants/':
    path    => '/etc/icinga2/objects/constants/',
    ensure  => directory,
    owner   => $etc_icinga2_obejcts_sub_dir_owner,
    group   => $etc_icinga2_obejcts_sub_dir_group,
    mode    => $etc_icinga2_obejcts_sub_dir_mode,
  }

}