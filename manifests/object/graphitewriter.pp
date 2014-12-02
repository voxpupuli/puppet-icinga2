# == Defined type: icinga2::object::graphitewriter
#
#  This is a defined type for Icinga 2 GraphiteWriter objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/configuring-icinga2#objecttype-graphitewriter
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::graphitewriter (
  $graphite_host        = '127.0.0.1',
  $graphite_port        = 2003,
  #Put the object files this defined type generates in features-available
  #since the Graphite writer feature is one that has to be explicitly enabled.
  $target_dir           = '/etc/icinga2/features-available',
  $target_file_name     = "${name}.conf",
  $target_file_ensure   = file,
  $target_file_owner    = 'root',
  $target_file_group    = 'root',
  $target_file_mode     = '0644',
  $refresh_icinga2_service = true
) {

  #Do some validation
  validate_string($host)
  validate_bool($refresh_icinga2_service)

  #If the refresh_icinga2_service parameter is set to true...
  if $refresh_icinga2_service == true {

    file { "${target_dir}/${target_file_name}":
      ensure  => $target_file_ensure,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template('icinga2/object_graphitewriter.conf.erb'),
      #...notify the Icinga 2 daemon so it can restart and pick up changes made to this config file...
      notify  => Service['icinga2'],
    }

  }
  #...otherwise, use the same file resource but without a notify => parameter: 
  else {
  
    file { "${target_dir}/${target_file_name}":
      ensure  => $target_file_ensure,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template('icinga2/object_graphitewriter.conf.erb'),
    }
  
  }

}
