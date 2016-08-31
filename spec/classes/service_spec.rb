require 'spec_helper'
require 'plattforms'

describe('icinga2', :type => :class) do

  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }

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

  context 'with ensure => foo (not a valid boolean)' do
    let(:params) { {:ensure => 'foo'} }
    it do
      expect {
        should contain_service('icinga2')
      }.to raise_error(Puppet::Error, /foo isn't supported. Valid values are 'running' and 'stopped'./)
    end
  end

  context 'with enable => foo (not a valid boolean)' do
    let(:params) { {:enable => 'foo'} }
    it do
      expect {
        should contain_service('icinga2')
      }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
    end
  end

  context 'with manage_service => true' do
    let(:params) { {:manage_service => true} }
    it do
      should contain_service('icinga2')
    end
  end

  context 'with manage_service => false' do
    let(:params) { {:manage_service => false} }
    it do
      should_not contain_service('icinga2')
    end
  end

  context 'with manage_service => foo (not a valid boolean)' do
    let(:params) { {:manage_service => 'foo'} }
    it do
      expect {
        should contain_service('icinga2')
      }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
    end
  end

end
