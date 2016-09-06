require 'spec_helper'
require 'plattforms'

describe('icinga2::feature::mainlog', :type => :class) do
  # reference plattform for Linux
  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  context 'with ensure => present on all supported plattforms' do
    let(:params) { {:ensure => 'present'} }
    it do
      should contain_icinga2__feature('mainlog').with({
        'ensure' => 'present',
      })
    end
  end

  context 'with enable => absent on  on all supported plattforms' do
    let(:params) { {:ensure => 'absent'} }
    it do
      should contain_icinga2__feature('mainlog').with({
        'ensure' => 'absent',
      })
    end
  end

  context 'with severity => notice on Linux' do
    let(:params) { {:severity => 'notice'} }
    it do
      should contain_file('/etc/icinga2/features-available/mainlog.conf')
        .with_content(/severity = "notice"/)
    end
  end

  context 'with severity => notice on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:severity => 'notice'} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/mainlog.conf')
        .with_content(/severity = "notice"/)
    end
  end

  context 'with severity => foo (not a valid value)' do
    let(:params) { {:severity => 'foo'} }
    it do
      expect {
        should contain_icinga2__feature('mainlog')
      }.to raise_error(Puppet::Error, /"foo" does not match/)
    end
  end

  context 'with path => /foo/bar on Linux' do
    let(:params) { {:path => '/foo/bar'} }
    it do
      should contain_file('/etc/icinga2/features-available/mainlog.conf')
        .with_content(/path = "\/foo\/bar"/)
    end
  end

  context 'with path => C:/foo/bar on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:path => 'C:/foo/bar'} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/mainlog.conf')
        .with_content(/path = "C:\/foo\/bar"/)
    end
  end

  context 'with path => foo/bar (not a valid value)' do
    let(:params) { {:path => 'foo/bar'} }
    it do
      expect {
        should contain_icinga2__feature('mainlog')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end

end
