require 'spec_helper'

describe('icinga2', :type => :class) do

  context 'on unsupported plattform' do
    let(:facts) { {:osfamily => 'foo'} }
    it do
      expect {
        should contain_class('icinga')
      }.to raise_error(Puppet::Error, /foo is not supported/)
    end
  end

  let(:facts) { {:osfamily => 'RedHat', :operatingsystemmajrelease => '7'} }

  context 'with all default parameters' do
    it do
      should contain_package('icinga2').with({'ensure' => 'installed'})
      should contain_service('icinga2').with({
        'ensure' => 'running',
        'enable' => true,
      })
    end
  end

  # all plattform independent tests will be done on a redhat system
  context 'with ensure => running, enable => true' do
    let(:params) { {:ensure => 'running', :enable => true} }
    it do
      should contain_service('icinga2').with({
        'ensure' => 'running',
        'enable' => true,
      })
    end
  end

  context 'with ensure => stopped, enable => false' do
    let(:params) { {:ensure => 'stopped', :enable => false} }
    it do
      should contain_service('icinga2').with({
        'ensure' => 'stopped',
        'enable' => false,
      })
    end
  end

  context 'with ensure => foo (not valid)' do
    let(:params) { {:ensure => 'foo'} }
    it do
      expect {
        should contain_service('icinga2')
      }.to raise_error(Puppet::Error, /foo isn't supported. Valid values are 'running' and 'stopped'./)
    end
  end

  context 'with enable => foo (not valid boolean)' do
    let(:params) { {:enable => 'foo'} }
    it do
      expect {
        should contain_service('icinga2')
      }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
    end
  end

  context 'with manage_service => false' do
    let(:params) { {:manage_service => false} }
    it do
      should_not contain_service('icinga2')
    end
  end

  # redhat based tests
  context 'with all default parameters effect on RedHat' do
    it do
      should_not contain_yumrepo('icinga-stable-release')
    end
  end

  context 'with manage_repo => true on RedHat' do
    let(:params) { {:manage_repo => true} }
    it do
      should contain_yumrepo('icinga-stable-release')
    end
  end

  # debian based tests
  context 'with all default parameters effect on Debian' do
    let(:facts) { {:osfamily => 'Debian'} }
    it do
      should_not contain_apt__source('icinga-stable-release')
    end
  end

  context 'with manage_repo => true on Debian' do
    let(:facts) { {:osfamily => 'Debian', :lsbdistid => 'Debian' } }
    let(:params) { {:manage_repo => true} }
    it do
      should contain_apt__source('icinga-stable-release')
    end
  end

end
