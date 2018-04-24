require 'spec_helper'

describe('icinga2::feature::syslog', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('syslog').with({'ensure' => 'present'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::SyslogLogger::syslog')
        .with({ 'target' => '/etc/icinga2/features-available/syslog.conf' })
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('syslog').with({'ensure' => 'absent'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::SyslogLogger::syslog')
        .with({ 'target' => '/etc/icinga2/features-available/syslog.conf' }) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('syslog').with({'ensure' => 'present'}) }

      it { is_expected.to contain_concat__fragment('icinga2::object::SyslogLogger::syslog')
        .with({ 'target' => '/etc/icinga2/features-available/syslog.conf' })
        .with_content(/severity = "warning"/) }
    end


    context "#{os} with severity => notice" do
      let(:params) { {:severity => 'notice'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::SyslogLogger::syslog')
        .with({ 'target' => '/etc/icinga2/features-available/syslog.conf' })
        .with_content(/severity = "notice"/) }
    end


    context "#{os} with severity => foo (not a valid value)" do
      let(:params) { {:severity => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a match for Enum\['debug', 'information', 'notice', 'warning'\]/) }
    end
  end
end