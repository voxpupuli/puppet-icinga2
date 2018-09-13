require 'spec_helper'

describe('icinga2::feature::compatlog', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('compatlog').with({'ensure' => 'present'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::CompatLogger::compatlog')
        .with({ 'target' => '/etc/icinga2/features-available/compatlog.conf' })
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('compatlog').with({'ensure' => 'absent'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::CompatLogger::compatlog')
        .with({ 'target' => '/etc/icinga2/features-available/compatlog.conf' }) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('compatlog').with({'ensure' => 'present'}) }

      it { is_expected.to contain_concat__fragment('icinga2::object::CompatLogger::compatlog')
        .with({ 'target' => '/etc/icinga2/features-available/compatlog.conf' })
        .with_content(/rotation_method = "DAILY"/)
        .with_content(/log_dir = "\/var\/log\/icinga2\/compat"/) }
    end


    context "#{os} with rotation_method => HOURLY" do
      let(:params) { {:rotation_method => 'HOURLY'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::CompatLogger::compatlog')
        .with({ 'target' => '/etc/icinga2/features-available/compatlog.conf' })
        .with_content(/rotation_method = "HOURLY"/) }
    end


    context "#{os} with rotation_method => foo (not a valid value)" do
      let(:params) { {:rotation_method => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with log_dir => /foo/bar" do
      let(:params) { {:log_dir => '/foo/bar'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::CompatLogger::compatlog')
        .with({ 'target' => '/etc/icinga2/features-available/compatlog.conf' })
        .with_content(/log_dir = "\/foo\/bar"/) }
    end


    context "#{os} with log_dir => foo/bar (not an absolute path)" do
      let(:params) { {:log_dir => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end
  end
end