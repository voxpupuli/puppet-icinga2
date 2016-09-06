require 'spec_helper'
require 'plattforms'

describe('icinga2::feature::checker', :type => :class) do
  # reference plattform for Linux
  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  context 'with ensure => present on all supported plattforms' do
    let(:params) { {:ensure => 'present'} }
    it do
      should contain_icinga2__feature('checker').with({
        'ensure' => 'present',
      })
    end
  end

  context 'with enable => absent on  on all supported plattforms' do
    let(:params) { {:ensure => 'absent'} }
    it do
      should contain_icinga2__feature('checker').with({
        'ensure' => 'absent',
      })
    end
  end

end
