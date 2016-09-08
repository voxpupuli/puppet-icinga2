require 'spec_helper'
require 'plattforms'

describe('icinga2::feature::command', :type => :class) do
  # reference plattform for Linux
  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  context 'with ensure => present on all supported plattforms' do
    let(:params) { {:ensure => 'present'} }
    it do
      should contain_icinga2__feature('command').with({
        'ensure' => 'present',
      })
    end
  end

  context 'with enable => absent on  on all supported plattforms' do
    let(:params) { {:ensure => 'absent'} }
    it do
      should contain_icinga2__feature('command').with({
        'ensure' => 'absent',
      })
    end
  end

  context 'with command_path => /foo/bar on Linux' do
    let(:params) { {:command_path => '/foo/bar'} }
    it do
      should contain_file('/etc/icinga2/features-available/command.conf')
        .with_content(/command_path = "\/foo\/bar"/)
    end
  end

  context 'with command_path => C:/foo/bar on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:command_path => 'C:/foo/bar'} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/command.conf')
        .with_content(/command_path = "C:\/foo\/bar"/)
    end
  end

  context 'with command_path => foo/bar (not a valid value)' do
    let(:params) { {:command_path => 'foo/bar'} }
    it do
      expect {
        should contain_icinga2__feature('command')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end

end
