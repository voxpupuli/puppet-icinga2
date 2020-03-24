# == Class: icinga2::repo
#
# This class manages the packages.icinga.com repository based on the operating system. Windows is not supported, as the
# Icinga Project does not offer a chocolate repository.
#
# === Parameters
#
# This class does not provide any parameters.
# To control the behaviour of this class, have a look at the parameters:
# * icinga2::manage_repo
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
#
class icinga2::repo {

  $repo =  lookup('icinga2::repo', Hash, 'deep', {})

  case $::osfamily {
    'redhat': {
      yumrepo { 'icinga-stable-release':
        * => $repo,
      }
      Yumrepo['icinga-stable-release'] -> Package<|tag == 'icinga2'|>
    }

    'debian': {
      # handle icinga stable repo before all package resources
      # contain class problem!
      Apt::Source['icinga-stable-release'] -> Package <| tag == 'icinga2' |>
      Class['Apt::Update'] -> Package<|tag == 'icinga2'|>

      contain ::apt, ::apt::backports

      apt::source { 'icinga-stable-release':
        * => $repo,
      }
    }

    'suse': {
      Zypprepo['icinga-stable-release'] -> Package <| tag == 'icinga2' |>

      if $repo['proxy'] {
        $_proxy = "--httpproxy ${repo['proxy']}"
      } else {
        $_proxy = undef
      }

      exec { 'import icinga gpg key':
        path      => '/bin:/usr/bin:/sbin:/usr/sbin',
        command   => "rpm ${_proxy} --import ${repo['gpgkey']}",
        unless    => 'rpm -q gpg-pubkey-34410682',
        logoutput => 'on_failure',
      }

      -> zypprepo { 'icinga-stable-release':
        * => delete($repo, 'proxy'),
      }

      -> file_line { 'add proxy settings to icinga repo':
        path => '/etc/zypp/repos.d/icinga-stable-release.repo',
        line => "proxy=${repo['proxy']}",
      }
    }

    'windows': {
      warning("The Icinga Project doesn't offer chocolaty packages at the moment.")
    }

    default: {
      fail('Your plattform is not supported to manage a repository.')
    }
  } # osfamily

}
