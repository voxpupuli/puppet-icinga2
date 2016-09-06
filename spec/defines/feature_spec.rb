require 'spec_helper'
require 'plattforms'

describe('icinga2::feature', :type => :define) do
  # reference plattform for Linux
  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }
  let(:title) { 'bar' }

  context 'with ensure => foo (not a valid value)' do
    let(:params) { {:ensure => 'foo'} }
    it do
      expect {
        should contain_icinga2__feature('foo')
      }.to raise_error(Puppet::Error, /foo isn't supported. Valid values are 'present' and 'absent'./)
    end
  end

  context 'with ensure => present, feature => foo on Linux' do
    let(:params) { {:ensure => 'present', 'feature' => '.foo'} }
    it do
      should contain_file('/etc/icinga2/features-available/.foo.conf').with({
        'ensure' => 'file',
      }).with_content(/.foo/)
        .that_requires('icinga2::install')
        .that_notifies('icinga2::service')
      should contain_file('/etc/icinga2/features-enabled/.foo.conf').with({
        'ensure' => 'link',
        'target' => '../features-available/.foo.conf',
      }).that_notifies('icinga2::service')
    end
  end

  context 'with ensure => present, feature => foo on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:ensure => 'present', 'feature' => '.foo'} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/.foo.conf').with({
        'ensure' => 'file',
      }).with_content(/.foo/)
#        .that_requires('icinga2::install')
#        .that_notifies('icinga2::service')
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-enabled/.foo.conf').with({
        'ensure' => 'file',
      }).with_content(/include "..\/features-available\/.foo.conf"/)
#        .that_notifies('icinga2::service')
    end
  end

  context 'with ensure => absent, feature => foo on Linux' do
    let(:params) { {:ensure => 'absent', 'feature' => '.foo'} }
    it do
      should contain_file('/etc/icinga2/features-available/.foo.conf').with({
        'ensure' => 'file',
      }).with_content(/.foo/)
        .that_requires('icinga2::install')
      should contain_file('/etc/icinga2/features-enabled/.foo.conf').with({
        'ensure' => 'absent',
      }).that_notifies('icinga2::service')
    end
  end

  context 'with ensure => absent, feature => foo on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { {:ensure => 'absent', 'feature' => '.foo'} }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/.foo.conf').with({
        'ensure' => 'file',
      }).with_content(/.foo/)
#        .that_requires('icinga2::install')
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/features-enabled/.foo.conf').with({
        'ensure' => 'absent',
      }) #.that_notifies('icinga2::service')
    end
  end

end
