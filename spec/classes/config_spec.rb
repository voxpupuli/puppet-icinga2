require 'spec_helper'
require 'plattforms'

describe('icinga2', :type => :class) do

  # reference plattform for Linux
  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }

  context 'with external icinga2::config::file on Linux' do
    let(:pre_condition) {
      'file { "/etc/icinga2/foo":
        ensure => file,
        tag    => icinga2::config::file,
      }'
    }
    it do
      should contain_file('/etc/icinga2/foo')
        .that_requires('Class[icinga2::config]')
        .that_notifies('Class[icinga2::service]')
    end
  end

  context 'with external icinga2::config::file on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:pre_condition) {
      'file { "C:/ProgramData/icinga2/etc/icinga2/foo":
        ensure => file,
        tag    => icinga2::config::file,
      }'
    }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/foo')
#        .that_requires('Class[icinga2::install]')
#        .that_comes_before('Class[icinga2::config]')
    end
  end

end
