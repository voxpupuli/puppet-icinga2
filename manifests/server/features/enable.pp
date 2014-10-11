# Enable Icinga 2 Features/Modules
define icinga2::server::features::enable () {
  exec { "icinga2-enable-feature ${name}":
    user    => 'root',
    path    => '/usr/bin:/usr/sbin:/bin/:/sbin',
    command => "/usr/sbin/icinga2-enable-feature ${name}",
    unless  => "[ ! -f /etc/icinga2/features-available/${name}.conf ] || [ -f /etc/icinga2/features-enabled/${name}.conf ]",
    require => Class['icinga2::server::install::packages'],
  }
}
