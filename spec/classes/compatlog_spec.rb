require 'spec_helper'
require 'plattforms'

describe('icinga2::feature::compatlog', :type => :class) do
  # reference plattform for Linux
  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  context 'with ensure => present on all supported plattforms' do
    let(:params) { {:ensure => 'present'} }
    it do
      should contain_icinga2__feature('compatlog').with({
        'ensure' => 'present',
      })
    end
  end

  context 'with enable => absent on  on all supported plattforms' do
    let(:params) { {:ensure => 'absent'} }
    it do
      should contain_icinga2__feature('compatlog').with({
        'ensure' => 'absent',
      })
    end
  end

  context 'with rotation_method => HOURLY on Linux' do
    let(:params) { {:rotation_method => 'HOURLY'} }
    it do
      should contain_file('/etc/icinga2/features-available/compatlog.conf')
        .with_content(/rotation_method = "HOURLY"/)
    end
  end

  context 'with rotation_method => notice on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:rotation_method => 'HOURLY'} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/compatlog.conf')
        .with_content(/rotation_method = "HOURLY"/)
    end
  end

  context 'with rotation_method => foo (not a valid value)' do
    let(:params) { {:rotation_method => 'foo'} }
    it do
      expect {
        should contain_icinga2__feature('compatlog')
      }.to raise_error(Puppet::Error, /"foo" does not match/)
    end
  end

  context 'with log_dir => /foo/bar on Linux' do
    let(:params) { {:log_dir => '/foo/bar'} }
    it do
      should contain_file('/etc/icinga2/features-available/compatlog.conf')
        .with_content(/log_dir = "\/foo\/bar"/)
    end
  end

  context 'with log_dir => C:/foo/bar on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:log_dir => 'C:/foo/bar'} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/compatlog.conf')
        .with_content(/log_dir = "C:\/foo\/bar"/)
    end
  end

  context 'with log_dir => foo/bar (not a valid value)' do
    let(:params) { {:log_dir => 'foo/bar'} }
    it do
      expect {
        should contain_icinga2__feature('compatlog')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end

end
