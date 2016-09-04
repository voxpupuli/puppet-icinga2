# == Class: icinga2
#
# This module installs and configures Icinga2.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   Set to stopped declare the service to be stopped. Default to running.
#
# [*enable*]
#   Enables (true) or disables (false) the service to start at boot. Default to true.
#
# [*manage_repo*]
#   Manage the corrolated repository from icinga.org on all supported
#   plattforms. Default to false.
#
# [*manage_service*]
#   If set to true the service is managed otherwise the service also
#   isn't restarted if a config file changed. Default to true.
#
# [*constants*]
#   Hash of constants to set. Defaults are set in the params class. Your settings
#   will be merged with this defaults.
#
# [*plugins*]
#   A list of the ITL plugins to load. Default to [ 'plugins', 'plugins-contrib' ]
#   on Linux systems and [ 'windows-plugins', 'nscp' ] on Windows.
#
# [*confd*]
#   Can be set to true to load the configuration under etc/icinga2/conf.d directory.
#   To disable this set it to false. It's also possible to assign your own directory.
#   This directory is relative to etc/icinga2 and must be managed outside of this
#   module as file resource with tag icinga2::config::file. Default to true.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
#
# === Examples
#
# Declare icinga2 with all defaults. Keep in mind that you've to
# manage a repository on your own.
#
#  include icinga2
#
# If you like to use the Icinga Project repository, enable the manage_repo parameter.
# Note: On Windows chocolatey is supported only and the Icinga Project doesn't offer a
# package , so if you enbale mange_repo on Windows you'll get a warning and the
# parameter is ignored.
#
#  class { 'icinga2':
#    manage_repo => true,
#  }
#
# Maybe you don't like to manage the icinga2 service by puppet. You can disable this
# behavoir by setting manage_service to false. That mean no service refresh will be
# done even if this was triggered.
#
#  class { 'icinga2':
#    manage_service => false,
#  }
#
# Also at this early state of development you can use it in any way you like.
# I.e. you can manage every configuration file in puppet by setting the metaparameter
# tag to icinga2::config::file. A refresh is triggered automatically.
#
#  include icinga2
#  file { '/etc/icinga2/icinga2.conf':
#    ensure => file,
#    owner  => icinga,
#    ...
#    tag    => 'icinga2::config::file',
#    ...
#  }
#
# To set constants in etc/icinga2/constants.conf use the constants parameter and as
# value a hash, every key will be set as constant and assigned by it's value. Defaults
# can be overwritten.
#
#  class { 'icinga2':
#    ...
#    constants   => {
#      'key1'             => 'value1',
#      'key2'             => 'value2',
#      'PluginContirbDir' => '/usr/local/nagios/plugins',
#    }
#  }
#
# The ITL contains several CheckCommand definitions to load, set these in the array
# of the plugins parameter, i.e. for a master or satellite do the following and
# disbale the load of the configuration in conf.d.
#
#  class { 'icinga':
#    ...
#    plugins => [ 'plugins', 'contrib-plugins', 'nscp', 'windows-plugins' ],
#    confd   => false,
#  }
#
# To use a different directory for your configuration, create the directory
# as file resource with tag icinga2::config::file.
#
#   file { '/etc/icinga2/local.d':
#     ensure => directory,
#     tag    => 'icinga2::config::file'
#   }
#   class { 'icinga2':
#     ...
#     confd => 'local.d',
#   }
#
# === Authors
#
# Icinga Development Team <info@icinga.org>
#
class icinga2(
  $ensure         = running,
  $enable         = true,
  $manage_repo    = false,
  $manage_service = true,
  $constants      = {},
  $plugins        = $icinga2::params::plugins,
  $confd          = true,
) inherits icinga2::params {

  validate_re($ensure, [ '^running$', '^stopped$' ],
    "${ensure} isn't supported. Valid values are 'running' and 'stopped'.")
  validate_bool($enable)
  validate_bool($manage_repo)
  validate_bool($manage_service)
  validate_hash($constants)
  validate_array($plugins)

  # validate confd, boolean or string
  if $icinga2::confd {
    if is_bool($icinga2::confd) {
      $_confd = "conf.d"
    } elsif is_string($icinga2::confd) {
      $_confd = $icinga2::confd
    } else {
      fail('confd has to be a boolean or string')
    }
  }

  anchor { 'icinga2::begin':
    notify => Class['icinga2::service']
  }
  -> class { 'icinga2::repo': }
  -> class { 'icinga2::install': }
  -> File <| ensure == 'directory' and tag == 'icinga2::config::file' |>
  -> class { 'icinga2::config': notify => Class['icinga2::service'] }
  -> File <| ensure != 'directory' and tag == 'icinga2::config::file' |>
  ~> class { 'icinga2::service': }
  -> anchor { 'icinga2::end':
    subscribe => Class['icinga2::config']
  }

}
