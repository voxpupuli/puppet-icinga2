require 'spec_helper'

describe('icinga2', :type => :class) do
  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with ensure => running, enable => true" do
      let(:params) { {:ensure => 'running', :enable => true} }
      it do
        should contain_service('icinga2').with({
          'ensure' => 'running',
          'enable' => true,
        })
      end
    end

    context "#{os} with ensure => stopped, enable => false" do
      let(:params) { {:ensure => 'stopped', :enable => false} }
      it do
        should contain_service('icinga2').with({
          'ensure' => 'stopped',
          'enable' => false,
        })
      end
    end

    context "#{os} with ensure => foo (not a valid boolean)" do
      let(:params) { {:ensure => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a match for Enum\['running', 'stopped'\]/) }
    end

    context "#{os} with enable => foo (not a valid boolean)" do
      let(:params) { {:enable => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a Boolean value/) }
    end

    context "#{os} with manage_service => true" do
      let(:params) { {:manage_service => true} }
      it { should contain_service('icinga2') }
    end

    context "#{os} with manage_service => false" do
      let(:params) { {:manage_service => false} }
      it { should_not contain_service('icinga2') }
    end

    context "#{os} with manage_service => foo (not a valid boolean)" do
      let(:params) { {:manage_service => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a Boolean value/) }
    end
  end
end