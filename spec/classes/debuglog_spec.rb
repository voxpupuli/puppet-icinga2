require 'spec_helper'

describe('icinga2::feature::debuglog', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('debuglog').with({'ensure' => 'present'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::FileLogger::debuglog')
        .with({ 'target' => '/etc/icinga2/features-available/debuglog.conf' })
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('debuglog').with({'ensure' => 'absent'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::FileLogger::debuglog')
        .with({ 'target' => '/etc/icinga2/features-available/debuglog.conf' }) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('debuglog').with({'ensure' => 'present'}) }

      it { is_expected.to contain_concat__fragment('icinga2::object::FileLogger::debuglog')
        .with({ 'target' => '/etc/icinga2/features-available/debuglog.conf' })
        .with_content(/path = "\/var\/log\/icinga2\/debug.log"/) }
    end


    context "#{os} with path => /foo/bar" do
      let(:params) { {:path => '/foo/bar'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::FileLogger::debuglog')
        .with({ 'target' => '/etc/icinga2/features-available/debuglog.conf' })
        .with_content(/path = "\/foo\/bar"/) }
    end


    context "#{os} with path => foo/bar (not an absolute path)" do
      let(:params) { {:path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end
  end
end