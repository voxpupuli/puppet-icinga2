require 'spec_helper'

describe('icinga2::feature', :type => :define) do
  let(:title) { 'bar' }
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }


  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => foo (not a valid value)" do
      let(:params) { {:ensure => 'foo'} }

      it do
        expect {
          should contain_icinga2__feature('foo')
        }.to raise_error(Puppet::Error, /foo isn't supported. Valid values are 'present' and 'absent'./)
      end
    end


    context "#{os} with ensure => present, feature => foo" do
      let(:params) { {:ensure => 'present', :feature => 'foo'} }

      it {
        should contain_file('/etc/icinga2/features-enabled/foo.conf').with({
          'ensure' => 'link',
        }).that_notifies('Class[icinga2::service]')
      }
    end


    context "#{os} with ensure => absent, feature => foo" do
      let(:params) { {:ensure => 'absent', :feature => 'foo'} }

      it {
        should contain_file('/etc/icinga2/features-enabled/foo.conf').with({
          'ensure' => 'absent',
        }).that_notifies('Class[icinga2::service]')
      }
    end
  end


  context 'Windows 2012 R2 with ensure => present, feature => foo' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ensure => 'present', 'feature' => 'foo'} }

    it {
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-enabled/foo.conf').with({
        'ensure' => 'file',
      }).with_content(/include "..\/features-available\/foo.conf"/)
        .that_notifies('Class[icinga2::service]')
    }
  end


  context 'Windows 2012 R2 with ensure => absent, feature => foo' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ensure => 'absent', 'feature' => 'foo'} }

    it {
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-enabled/foo.conf').with({
        'ensure' => 'absent',
      }).that_notifies('Class[icinga2::service]')
    }
  end
end
