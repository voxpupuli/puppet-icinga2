# == Defined type: icinga2::object::checkcommand
#
# This is a defined type for Icinga 2 apply objects that create check commands
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-checkcommand
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::checkcommand (
  $object_checkcommandname = $name,
  $template_to_import                    = 'plugin-check-command',
/*  $methods                             = undef, */ /* Need to get more details about this attribute */
  $command                               = undef,
  $cmd_path                              = 'PluginDir',
  $arguments                             = {},
  $env                                   = undef,
  $vars                                  = {},
  $timeout                               = undef,
  $target_dir                            = '/etc/icinga2/objects/checkcommands',
  $checkcommand_template_module          = 'icinga2',
  $checkcommand_template                 = 'object_checkcommand.conf.erb',
  $checkcommand_source_file              = undef,
  $checkcommand_file_distribution_method = 'content',
  $target_file_name                      = "${name}.conf",
  $target_file_owner                     = 'root',
  $target_file_group                     = 'root',
  $target_file_mode                      = '0644',
) {

  #Do some validation of the class' parameters:
  validate_string($object_checkcommandname)
  if $checkcommand_template == 'object_checkcommand.conf.erb' {
    validate_string($template_to_import)
    validate_array($command)
    validate_string($cmd_path)
    if $env {
      validate_hash($env)
    }
    validate_hash($vars)
    if $timeout {
      validate_re($timeout, '^\d+$')
    }
  }
  validate_string($target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_re($target_file_mode, '^\d{4}$')


  if $checkcommand_file_distribution_method == 'content' {
    file {"${target_dir}/${target_file_name}":
      ensure  => file,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template("${checkcommand_template_module}/${checkcommand_template}"),
      notify  => Service['icinga2'],
    }
  }
  elsif $checkcommand_file_distribution_method == 'source' {
    file {"${target_dir}/${target_file_name}":
      ensure => file,
      owner  => $target_file_owner,
      group  => $target_file_group,
      mode   => $target_file_mode,
      source => $checkcommand_source_file,
      notify => Service['icinga2'],
    }
  }
  else {
    notify {'Missing/Incorrect File Distribution Method':
      message => 'The parameter checkcommand_file_distribution_method is missing or incorrect. Please set content or source',
    }
  }
}
