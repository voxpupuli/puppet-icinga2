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
  end


  context 'Windows 2012 R2 with ensure => present' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ensure => 'present'} }

    it { is_expected.to contain_icinga2__feature('notification').with({'ensure' => 'present'}) }

#    it { is_expected.to contain_icinga2__object('icinga2::object::NotificationComponent::notification')
#      .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/notification.conf' })
#      .that_notifies('Class[icinga2::service]') }
  end


  context 'Windows 2012 R2 with ensure => absent' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ensure => 'absent'} }

    it { is_expected.to contain_icinga2__feature('notification').with({'ensure' => 'absent'}) }

#    it { is_expected.to contain_icinga2__object('icinga2::object::NotificationComponent::notification')
#      .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/notification.conf' }) }
  end
end
