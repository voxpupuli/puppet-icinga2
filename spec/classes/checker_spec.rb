require 'spec_helper'

describe('icinga2::feature::checker', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('checker').with({'ensure' => 'present'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::CheckerComponent::checker')
        .with({ 'target' => '/etc/icinga2/features-available/checker.conf' })
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('checker').with({'ensure' => 'absent'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::CheckerComponent::checker')
        .with({ 'target' => '/etc/icinga2/features-available/checker.conf' }) }
    end


    context "#{os} with concurrent_checks => 100" do
      let(:params) { {:concurrent_checks => 100} }

      it { is_expected.to contain_concat__fragment('icinga2::object::CheckerComponent::checker')
        .with({ 'target' => '/etc/icinga2/features-available/checker.conf' })
        .with_content(/concurrent_checks = 100/) }
    end


    context "#{os} with concurrent_checks => foo (not a valid integer)" do
      let(:params) { {:concurrent_checks => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Integer/) }
    end

  end
end