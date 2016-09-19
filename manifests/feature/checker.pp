class icinga2::feature::checker(
  $ensure = present,
) {

  include ::icinga2::params

  $conf_dir = $::icinga2::params::conf_dir

  icinga2::object::checkercomponent { 'checker':
    target => "${conf_dir}/features-available/checker.conf",
    #    notify => $ensure ? {
    #  'present' => Class['::icinga2::service'],
    #  default   => undef,
    #},
  }

  concat::fragment { 'icinga2::feature::checker':
    target  => "${conf_dir}/features-available/checker.conf",
    content => "library \"checker\"\n\n",
    order   => '05',
  }

  icinga2::feature { 'checker':
    ensure      => $ensure,
  }

}
