require 'spec_helper'
require 'plattforms'

describe('icinga2', :type => :class) do
  # reference plattform for Linux
  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }

  context 'with purge_features => true on Linux' do
    let(:params) { {:purge_features => true} }
    it do
      should contain_file('/etc/icinga2/features-enabled').with({
        'ensure'  => 'directory',
        'purge'   => true,
        'recurse' => true,
      })
    end
  end

  context 'with purge_features => true on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:purge_features => true} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-enabled').with({
        'ensure'  => 'directory',
        'purge'   => true,
        'recurse' => true,
      })
    end
  end

  context 'with purge_features => false on Linux' do
    let(:params) { {:purge_features => false} }
    it do
      should contain_file('/etc/icinga2/features-enabled').with({
        'ensure'  => 'directory',
        'purge'   => false,
        'recurse' => false,
      })
    end
  end

  context 'with purge_features => false on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:purge_features => false} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-enabled').with({
        'ensure'  => 'directory',
        'purge'   => false,
        'recurse' => false,
      })
    end
  end

end
