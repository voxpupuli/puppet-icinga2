require 'spec_helper'
require 'plattforms'

describe('icinga2', :type => :class) do

  context 'on unsupported plattform' do
    let(:facts) { {:osfamily => 'foo'} }
    it do
      expect {
        should contain_class('icinga')
      }.to raise_error(Puppet::Error, /foo is not supported/)
    end
  end

  context 'with all default parameters on RedHat 6' do
    let(:facts) { IcingaPuppet.plattforms['RedHat 6'] }
    it do
      should contain_package('icinga2').with({'ensure' => 'installed'})
      should contain_service('icinga2').with({
        'ensure' => 'running',
        'enable' => true,
      })
      should_not contain_yumrepo('icinga-stable-release')
    end
  end

  context 'with all default parameters on RedHat 7' do
    let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }
    it do
      should contain_package('icinga2').with({'ensure' => 'installed'})
      should contain_service('icinga2').with({
        'ensure' => 'running',
        'enable' => true,
      })
      should_not contain_yumrepo('icinga-stable-release')
    end
  end

  context 'with all default parameters on Centos 6' do
    let(:facts) { IcingaPuppet.plattforms['Centos 6'] }
    it do
      should contain_package('icinga2').with({'ensure' => 'installed'})
      should contain_service('icinga2').with({
        'ensure' => 'running',
        'enable' => true,
      })
      should_not contain_yumrepo('icinga-stable-release')
    end
  end

  context 'with all default parameters on Centos 7' do
    let(:facts) { IcingaPuppet.plattforms['Centos 7'] }
    it do
      should contain_package('icinga2').with({'ensure' => 'installed'})
      should contain_service('icinga2').with({
        'ensure' => 'running',
        'enable' => true,
      })
      should_not contain_yumrepo('icinga-stable-release')
    end
  end

  context 'with all default parameters on Debian wheezy' do
    let(:facts) { IcingaPuppet.plattforms['Debian wheezy'] }
    it do
      should contain_package('icinga2').with({'ensure' => 'installed'})
      should contain_service('icinga2').with({
        'ensure' => 'running',
        'enable' => true,
      })
      should_not contain_apt__source('icinga-stable-release')
    end
  end

  context 'with all default parameters on Debian jessie' do
    let(:facts) { IcingaPuppet.plattforms['Debian jessie'] }
    it do
      should contain_package('icinga2').with({'ensure' => 'installed'})
      should contain_service('icinga2').with({
        'ensure' => 'running',
        'enable' => true,
      })
      should_not contain_apt__source('icinga-stable-release')
    end
  end

  context 'with all default parameters on Ubuntu trusty' do
    let(:facts) { IcingaPuppet.plattforms['Ubuntu trusty'] }
    it do
      should contain_package('icinga2').with({'ensure' => 'installed'})
      should contain_service('icinga2').with({
        'ensure' => 'running',
        'enable' => true,
      })
      should_not contain_apt__source('icinga-stable-release')
    end
  end

  context 'with all default parameters on Windows 2012 R2' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    it do
      should contain_package('icinga2').with({'ensure' => 'installed'})
      should contain_service('icinga2').with({
        'ensure' => 'running',
        'enable' => true,
      })
    end
  end

end
