require 'spec_helper'

describe('icinga2::feature::notification', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('notification').with({'ensure' => 'present'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::NotificationComponent::notification')
        .with({ 'target' => '/etc/icinga2/features-available/notification.conf' })
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('notification').with({'ensure' => 'absent'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::NotificationComponent::notification')
        .with({ 'target' => '/etc/icinga2/features-available/notification.conf' }) }
    end


    context "#{os} with enable_ha = true" do
      let(:params) { {:enable_ha => true} }

      it { is_expected.to contain_concat__fragment('icinga2::object::NotificationComponent::notification')
        .with({ 'target' => '/etc/icinga2/features-available/notification.conf' })
        .with_content(/enable_ha = true\n/) }
    end


    context "#{os} with enable_ha = false" do
      let(:params) { {:enable_ha => false} }

      it { is_expected.to contain_concat__fragment('icinga2::object::NotificationComponent::notification')
        .with({ 'target' => '/etc/icinga2/features-available/notification.conf' })
        .with_content(/enable_ha = false\n/) }
    end


    context "#{os} with enable_ha = foo (not a valid boolean)" do
      let(:params) { {:enable_ha => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Boolean/) }
    end
  end
end