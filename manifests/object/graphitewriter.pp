# Configure GraphiteWriter Feature .conf file
define icinga2::object::graphitewriter (
  $graphite_host        = '127.0.0.1',
  $graphite_port        = 2003,
  $target_dir           = '/etc/icinga2/features-available',
  $target_file_name     = "${name}.conf",
  $target_file_owner    = 'root',
  $target_file_group    = 'root',
  $target_file_mode     = '0644'
) {

  #Do some validation
  validate_string($host)

  file {"${target_dir}/${target_file_name}":
    ensure => file,
    owner   => $target_file_owner,
    group   => $target_file_group,
    mode    => $target_file_mode,
    content => template('icinga2/object_graphitewriter.conf.erb'),
    notify  => Service['icinga2'],
  }
}
