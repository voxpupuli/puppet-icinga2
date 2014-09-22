class icinga2::server::debmon_repo {
  
  apt::source { 'debmon':
    location          => 'http://debmon.org/debmon',
    release           => "debmon-${lsbdistcodename}",
    repos             => 'main',
    key_source        => 'http://debmon.org/debmon/repo.key',
    key               => 'BC7D020A',
    include_src       => false,
    # backports repo use 200
    pin               => '300'
  }

}
