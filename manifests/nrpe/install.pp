# Class: icinga2::nrpe::install
#
# This subclass installs NRPE and Nagios plugin packages on Icinga client machines.
#

class icinga2::nrpe::install inherits icinga2::nrpe {

  include icinga2::nrpe
  #Apply our subclasses in the right order. Use the squiggly arrows (~>) to ensure that the
  #class left is applied before the class on the right and that it also refreshes the
  #class on the right.
  class {'icinga2::nrpe::install::repos':} ~>
  class {'icinga2::nrpe::install::packages':} ~>
  class {'icinga2::nrpe::install::execs':}
}

##################
#Package repositories
##################
class icinga2::nrpe::install::repos inherits icinga2::nrpe {

  include icinga2::nrpe
  #repository resources here

}

##################
# Packages
##################
class icinga2::nrpe::install::packages inherits icinga2::nrpe {

  include icinga2::nrpe
  #Install the packages we specified in the ::params class:
  package {$icinga2::params::icinga2_client_packages:
    ensure          => installed,
    provider        => $icinga2::params::package_provider,
    install_options => $icinga2::params::client_plugin_package_install_options,
  }

}


##################
# Execs
##################
class icinga2::nrpe::install::execs { 

  #exec resources here

}
