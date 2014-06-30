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

  case $operatingsystem {
    #Red Hat/CentOS systems:
    'RedHat', 'CentOS': {
    
      #Add the official Icinga Yum repository: http://packages.icinga.org/epel/
      yumrepo { 'icinga2_yum_repo':
        baseurl  => "http://packages.icinga.org/epel/${operatingsystemmajrelease}/release/",
        descr    => "Icinga 2 Yum repository",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'http://packages.icinga.org/icinga.key'
      }
    }
    
    #Debian/Ubuntu systems: 
    /^(Debian|Ubuntu)$/: {
      #Add the Icinga 2 snapshots apt repo for Ubuntu Saucy Salamander:
      apt::source { "icinga2_ubuntu_${lsbdistcodename}_release_apt":
        location          => 'http://packages.icinga.org/ubuntu',
        release           => "icinga-${lsbdistcodename}",
        repos             => 'main',
        required_packages => 'debian-keyring debian-archive-keyring',
        key               => '34410682',
        key_source        => 'http://packages.icinga.org/icinga.key',
        include_src       => true
      }
    }
    
    #Fail if we're on any other OS:
    default: { fail("${operatingsystem} is not supported!") }
  }

}

class icinga2::server::install::packages inherits icinga2::server {

  include icinga2::params

}

class icinga2::server::install::execs inherits icinga2::server {

  include icinga2::params

}