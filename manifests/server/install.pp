# == Class: icinga2::server::install
#
# This class installs the server components for the Icinga 2 monitoring system.
#
# === Parameters
#
# Coming soon...
#
# === Examples
# 
# Coming soon...
# 

class icinga2::server::install inherits icinga2::server {
  
  include icinga2::params
  #Apply our classes in the right order. Use the squiggly arrows (~>) to ensure that the 
  #class left is applied before the class on the right and that it also refreshes the 
  #class on the right.
  #
  #Here, we're setting up the package repos first, then installing the packages:
  class{'icinga2::server::install::repos':} ~> 
  class{'icinga2::server::install::packages':} ~> 
  class{'icinga2::server::install::execs':} -> 
  Class['icinga2::server::install']
  
}

class icinga2::server::install::repos inherits icinga2::server {

  include icinga2::params

}

class icinga2::server::install::packages inherits icinga2::server {

  include icinga2::params

}

class icinga2::server::install::execs inherits icinga2::server {

  include icinga2::params

}