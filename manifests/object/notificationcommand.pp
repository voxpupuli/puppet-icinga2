# == Defined type: icinga2::object::notificationcommand
#
# This is a defined type for Icinga 2 apply objects that create notification commands
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-notificationcommand
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::notificationcommand (
  $object_notificationcommandname = $name,
  $template_to_import = 'plugin-notification-command',
/*  $methods           = undef, */ /* Need to get more details about this attribute */
  $command           = undef,
  $cmd_path          = 'PluginDir',
  $arguments         = {},
  $env               = {},
  $vars              = {},
  $timeout           = undef,
  $target_dir        = '/etc/icinga2/objects/notificationcommands',
  $target_file_name  = "${name}.conf",
  $target_file_owner = 'root',
  $target_file_group = 'root',
  $target_file_mode  = '0644'
) {

  #Do some validation of the class' parameters:
  validate_string($object_notificationcommandname)
  validate_string($template_to_import)
  validate_array($command)
  validate_string($cmd_path)
  validate_hash($arguments)
  validate_hash($env)
  validate_hash($vars)
  if $timeout {
    validate_re($timeout, '^\d+$')
  }
  validate_string($target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_re($target_file_mode, '^\d{4}$')


  file {"${target_dir}/${target_file_name}":
    ensure  => file,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_notificationcommand.conf.erb'),
    notify  => Service['icinga2'],
  }

}
