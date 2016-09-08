class IcingaPuppet
  def self.plattforms
    {
      'Debian wheezy' => {
        :kernel                    => 'Linux',
        :architecture              => 'x86_64',
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Debian',
        :lsbdistcodename           => 'wheezy',
        :lsbdistid                 => 'debian',
      },
      'Debian jessie' => {
        :kernel                    => 'Linux',
        :architecture              => 'x86_64',
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Debian',
        :lsbdistcodename           => 'jessie',
        :lsbdistid                 => 'debian',
      },
      'Ubuntu trusty' => {
        :kernel                    => 'Linux',
        :architecture              => 'x86_64',
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Ubuntu',
        :lsbdistcodename           => 'trusty',
        :lsbdistid                 => 'ubuntu',
      },
      'Ubuntu xenial' => {
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Ubuntu',
        :lsbdistcodename           => 'xenial',
        :lsbdistid                 => 'ubuntu',
      },
      'RedHat 6' => {
        :kernel                    => 'Linux',
        :architecture              => 'x86_64',
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'RedHat',
        :operatingsystemmajrelease => '6',
      },
      'RedHat 7' => {
        :kernel                    => 'Linux',
        :architecture              => 'x86_64',
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'RedHat',
        :operatingsystemmajrelease => '7',
      },
      'Centos 6' => {
        :kernel                    => 'Linux',
        :architecture              => 'x86_64',
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'Centos',
        :operatingsystemmajrelease => '6',
      },
      'Centos 7' => {
        :kernel                    => 'Linux',
        :architecture              => 'x86_64',
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'Centos',
        :operatingsystemmajrelease => '7',
      },
      'Windows 2012 R2' => {
        :kernel                    => 'Windows',
        :architecture              => 'x86_64',
        :osfamily                  => 'Windows',
        :operatingsystem           => 'Windows',
        :operatingsystemmajrelease => '2012 R2',
      },
    }
  end
end
