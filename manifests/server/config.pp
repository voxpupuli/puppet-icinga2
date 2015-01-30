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

  if $purge_unmanaged_object_files == true {
    $recurse_objects = true
    $purge_objects = true
    $force_purge = true
  }
  else {
    $recurse_objects = false
    $purge_objects = false
    $force_purge = true
  }
  

  #Directory resource for /etc/icinga2/:
  file { '/etc/icinga2/':
    ensure => directory,
    path   => '/etc/icinga2/',
    owner  => $etc_icinga2_owner,
    group  => $etc_icinga2_group,
    mode   => $etc_icinga2_mode,
    #require => Package[$icinga2::params::icinga2_server_packages],
  }

  #File resource for /etc/icinga2/icinga2.conf:
  file { '/etc/icinga2/icinga2.conf':
    ensure  => file,
    path   => '/etc/icinga2/icinga2.conf',
    owner   => $etc_icinga2_icinga2_conf_owner,
    group   => $etc_icinga2_icinga2_conf_group,
    mode    => $etc_icinga2_icinga2_conf_mode,
    content => template('icinga2/icinga2.conf.erb'),
  }

  #Directory resource for /etc/icinga2/conf.d/:
  file { '/etc/icinga2/conf.d/':
    ensure => directory,
    path   => '/etc/icinga2/conf.d/',
    owner  => $etc_icinga2_confd_owner,
    group  => $etc_icinga2_confd_group,
    mode   => $etc_icinga2_confd_mode,
  }

  #Directory resource for /etc/icinga2/features-available/:
  file { '/etc/icinga2/features-available/':
    ensure => directory,
    path   => '/etc/icinga2/features-available/',
    owner  => $etc_icinga2_features_available_owner,
    group  => $etc_icinga2_features_available_group,
    mode   => $etc_icinga2_features_available_mode,
  }

  #Directory resource for /etc/icinga2/features-enabled/:
  file { '/etc/icinga2/features-enabled/':
    ensure => directory,
    path   => '/etc/icinga2/features-enabled/',
    owner  => $etc_icinga2_features_enabled_owner,
    group  => $etc_icinga2_features_enabled_group,
    mode   => $etc_icinga2_features_enabled_mode,
  }

  #Directory resource for /etc/icinga2/pki/:
  file { '/etc/icinga2/pki/':
    ensure => directory,
    path   => '/etc/icinga2/pki/',
    owner  => $etc_icinga2_pki_owner,
    group  => $etc_icinga2_pki_group,
    mode   => $etc_icinga2_pki_mode,
  }

  #Directory resource for /etc/icinga2/scripts/:
  file { '/etc/icinga2/scripts/':
    ensure => directory,
    path   => '/etc/icinga2/scripts/',
    owner  => $etc_icinga2_scripts_owner,
    group  => $etc_icinga2_scripts_group,
    mode   => $etc_icinga2_scripts_mode,
  }

  #Directory resource for /etc/icinga2/zones.d/:
  file { '/etc/icinga2/zones.d/':
    ensure => directory,
    path   => '/etc/icinga2/zones.d/',
    owner  => $etc_icinga2_zonesd_owner,
    group  => $etc_icinga2_zonesd_group,
    mode   => $etc_icinga2_zonesd_mode,
  }

  #File and directory resources for the object directories that can be used to hold different
  #types of configuration objects

  #Directory resource for /etc/icinga2/objects/:
  file { '/etc/icinga2/objects/':
    ensure  => directory,
    path    => '/etc/icinga2/objects/',
    owner   => $etc_icinga2_obejcts_owner,
    group   => $etc_icinga2_obejcts_group,
    mode    => $etc_icinga2_obejcts_mode,
    recurse => $recurse_objects,
    purge   => $purge_objects,
    force   => $force_purge
  }

  #Directory resource for /etc/icinga2/objects/hosts/:
  file { '/etc/icinga2/objects/hosts/':
    ensure => directory,
    path   => '/etc/icinga2/objects/hosts/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/hostgroups/:
  file { '/etc/icinga2/objects/hostgroups/':
    ensure => directory,
    path   => '/etc/icinga2/objects/hostgroups/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/services/:
  file { '/etc/icinga2/objects/services/':
    ensure => directory,
    path   => '/etc/icinga2/objects/services/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/servicegroups/:
  file { '/etc/icinga2/objects/servicegroups/':
    ensure => directory,
    path   => '/etc/icinga2/objects/servicegroups/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/users/:
  file { '/etc/icinga2/objects/users/':
    ensure => directory,
    path   => '/etc/icinga2/objects/users/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/usergroups/:
  file { '/etc/icinga2/objects/usergroups/':
    ensure => directory,
    path   => '/etc/icinga2/objects/usergroups/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/checkcommands/:
  file { '/etc/icinga2/objects/checkcommands/':
    ensure => directory,
    path   => '/etc/icinga2/objects/checkcommands/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/notificationcommands/:
  file { '/etc/icinga2/objects/notificationcommands/':
    ensure => directory,
    path   => '/etc/icinga2/objects/notificationcommands/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/eventcommands/:
  file { '/etc/icinga2/objects/eventcommands/':
    ensure => directory,
    path   => '/etc/icinga2/objects/eventcommands/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/notifications/:
  file { '/etc/icinga2/objects/notifications/':
    ensure => directory,
    path   => '/etc/icinga2/objects/notifications/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/timeperiods/:
  file { '/etc/icinga2/objects/timeperiods/':
    ensure => directory,
    path   => '/etc/icinga2/objects/timeperiods/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/scheduleddowntimes/:
  file { '/etc/icinga2/objects/scheduleddowntimes/':
    ensure => directory,
    path   => '/etc/icinga2/objects/scheduleddowntimes/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/dependencies/:
  file { '/etc/icinga2/objects/dependencies/':
    ensure => directory,
    path   => '/etc/icinga2/objects/dependencies/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/perfdatawriters/:
  file { '/etc/icinga2/objects/perfdatawriters/':
    ensure => directory,
    path   => '/etc/icinga2/objects/perfdatawriters/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/graphitewriters/:
  file { '/etc/icinga2/objects/graphitewriters/':
    ensure => directory,
    path   => '/etc/icinga2/objects/graphitewriters/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/idomysqlconnections/:
  file { '/etc/icinga2/objects/idomysqlconnections/':
    ensure => directory,
    path   => '/etc/icinga2/objects/idomysqlconnections/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/idopgsqlconnections/:
  file { '/etc/icinga2/objects/idopgsqlconnections/':
    ensure => directory,
    path   => '/etc/icinga2/objects/idopgsqlconnections/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/livestatuslisteners/:
  file { '/etc/icinga2/objects/livestatuslisteners/':
    ensure => directory,
    path   => '/etc/icinga2/objects/livestatuslisteners/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/statusdatawriters/:
  file { '/etc/icinga2/objects/statusdatawriters/':
    ensure => directory,
    path   => '/etc/icinga2/objects/statusdatawriters/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/externalcommandlisteners/:
  file { '/etc/icinga2/objects/externalcommandlisteners/':
    ensure => directory,
    path   => '/etc/icinga2/objects/externalcommandlisteners/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/compatloggers/:
  file { '/etc/icinga2/objects/compatloggers/':
    ensure => directory,
    path   => '/etc/icinga2/objects/compatloggers/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/checkresultreaders/:
  file { '/etc/icinga2/objects/checkresultreaders/':
    ensure => directory,
    path   => '/etc/icinga2/objects/checkresultreaders/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/checkercomponents/:
  file { '/etc/icinga2/objects/checkercomponents/':
    ensure => directory,
    path   => '/etc/icinga2/objects/checkercomponents/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/notificationcomponents/:
  file { '/etc/icinga2/objects/notificationcomponents/':
    ensure => directory,
    path   => '/etc/icinga2/objects/notificationcomponents/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/fileloggers/:
  file { '/etc/icinga2/objects/fileloggers/':
    ensure => directory,
    path   => '/etc/icinga2/objects/fileloggers/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/syslogloggers/:
  file { '/etc/icinga2/objects/syslogloggers/':
    ensure => directory,
    path   => '/etc/icinga2/objects/syslogloggers/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/icingastatuswriters/:
  file { '/etc/icinga2/objects/icingastatuswriters/':
    ensure => directory,
    path   => '/etc/icinga2/objects/icingastatuswriters/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/apilisteners/:
  file { '/etc/icinga2/objects/apilisteners/':
    ensure => directory,
    path   => '/etc/icinga2/objects/apilisteners/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/endpoints/:
  file { '/etc/icinga2/objects/endpoints/':
    ensure => directory,
    path   => '/etc/icinga2/objects/endpoints/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/zones/:
  file { '/etc/icinga2/objects/zones/':
    ensure => directory,
    path   => '/etc/icinga2/objects/zones/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/applys/
  #The files in this folder will be objects like
  #'apply something blah to Host...'
  #See the following link for more info:
  # http://docs.icinga.org/icinga2/latest/doc/module/icinga2/toc#!/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#apply
  file { '/etc/icinga2/objects/applys/':
    ensure => directory,
    path   => '/etc/icinga2/objects/applys/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

  #Directory resource for /etc/icinga2/objects/templates/:
  file { '/etc/icinga2/objects/templates/':
    ensure => directory,
    path   => '/etc/icinga2/objects/templates/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }


  #Directory resource for /etc/icinga2/objects/constants/:
  file { '/etc/icinga2/objects/constants/':
    ensure => directory,
    path   => '/etc/icinga2/objects/constants/',
    owner  => $etc_icinga2_obejcts_sub_dir_owner,
    group  => $etc_icinga2_obejcts_sub_dir_group,
    mode   => $etc_icinga2_obejcts_sub_dir_mode,
  }

}
