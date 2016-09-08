require 'spec_helper'
require 'plattforms'

describe('icinga2::feature::statusdata', :type => :class) do
  # reference plattform for Linux
  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  context 'with ensure => present on all supported plattforms' do
    let(:params) { {:ensure => 'present'} }
    it do
      should contain_icinga2__feature('statusdata').with({
        'ensure' => 'present',
      })
    end
  end

  context 'with enable => absent on  on all supported plattforms' do
    let(:params) { {:ensure => 'absent'} }
    it do
      should contain_icinga2__feature('statusdata').with({
        'ensure' => 'absent',
      })
    end
  end

  context 'with update_interval => 1m on Linux' do
    let(:params) { {:update_interval => '1m'} }
    it do
      should contain_file('/etc/icinga2/features-available/statusdata.conf')
        .with_content(/update_interval = 1m/)
    end
  end

  context 'with update_interval => 60s on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:update_interval => '60s'} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/statusdata.conf')
        .with_content(/update_interval = 60s/)
    end
  end

  context 'with update_interval => foo (not a valid value)' do
    let(:params) { {:update_interval => 'foo'} }
    it do
      expect {
        should contain_icinga2__feature('statusdata')
      }.to raise_error(Puppet::Error, /"foo" does not match/)
    end
  end

  context 'with status_path => /foo/bar on Linux' do
    let(:params) { {:status_path => '/foo/bar'} }
    it do
      should contain_file('/etc/icinga2/features-available/statusdata.conf')
        .with_content(/status_path = "\/foo\/bar"/)
    end
  end

  context 'with status_path => C:/foo/bar on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:status_path => 'C:/foo/bar'} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/statusdata.conf')
        .with_content(/status_path = "C:\/foo\/bar"/)
    end
  end

  context 'with status_path => foo/bar (not a valid value)' do
    let(:params) { {:status_path => 'foo/bar'} }
    it do
      expect {
        should contain_icinga2__feature('statusdata')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end

  context 'with objects_path => /foo/bar on Linux' do
    let(:params) { {:objects_path => '/foo/bar'} }
    it do
      should contain_file('/etc/icinga2/features-available/statusdata.conf')
        .with_content(/objects_path = "\/foo\/bar"/)
    end
  end

  context 'with objects_path => C:/foo/bar on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:objects_path => 'C:/foo/bar'} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/statusdata.conf')
        .with_content(/objects_path = "C:\/foo\/bar"/)
    end
  end

  context 'with objects_path => foo/bar (not a valid value)' do
    let(:params) { {:objects_path => 'foo/bar'} }
    it do
      expect {
        should contain_icinga2__feature('statusdata')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end

end
