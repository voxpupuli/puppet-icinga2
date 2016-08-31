class IcingaPuppet
  def self.plattforms
    {
      'Debian wheezy' => {
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Debian',
        :lsbdistcodename           => 'wheezy',
        :lsbdistid                 => 'debian',
      },
      'Debian jessie' => {
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Debian',
        :lsbdistcodename           => 'jessie',
        :lsbdistid                 => 'debian',
      },
      'Ubuntu trusty' => {
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Ubuntu',
        :lsbdistcodename           => 'trusty',
        :lsbdistid                 => 'ubuntu',
      },
      'RedHat 6' => {
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'RedHat',
        :operatingsystemmajrelease => '6',
      },
      'RedHat 7' => {
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'RedHat',
        :operatingsystemmajrelease => '7',
      },
      'Centos 6' => {
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'Centos',
        :operatingsystemmajrelease => '6',
      },
      'Centos 7' => {
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'Centos',
        :operatingsystemmajrelease => '7',
      },
      'Windows 2012 R2' => {
        :osfamily                  => 'Windows',
        :operatingsystem           => 'Windows',
        :operatingsystemmajrelease => '2012 R2',
      },
    }
  end
end
