# Class: icinga2::client::install
#
# This subclass installs NRPE and Nagios plugin packages on Icinga client machines.
#

class icinga2::client::install inherits icinga2::client {
  
  include icinga2::client
  #Apply our subclasses in the right order. Use the squiggly arrows (~>) to ensure that the 
  #class left is applied before the class on the right and that it also refreshes the 
  #class on the right.
  class {'icinga2::client::install::repos':} ~>
  class {'icinga2::client::install::packages':} ~>
  class {'icinga2::client::install::execs':}
}

##################
#Package repositories
##################
class icinga2::client::install::repos inherits icinga2::client {
  
  include icinga2::client
  #repository resources here

}

##################
# Packages
##################
class icinga2::client::install::packages inherits icinga2::client {

  include icinga2::client
  #Install the packages we specified in the ::params class:
  package {$icinga2::params::icinga2_client_packages:
    ensure   => installed,
    provider => $icinga2::params::package_provider,
  }

}


##################
# Execs
##################
class icinga2::client::install::execs { 

  #exec resources here

}