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
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('syslog').with({'ensure' => 'absent'}) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('syslog').with({'ensure' => 'present'}) }

      it { is_expected.to contain_file('/etc/icinga2/features-available/syslog.conf')
        .with_content(/severity = "warning"/) }
    end


    context "#{os} with severity => notice" do
      let(:params) { {:severity => 'notice'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/syslog.conf')
        .with_content(/severity = "notice"/) }
    end


    context "#{os} with severity => foo (not a valid value)" do
      let(:params) { {:severity => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
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

    it { is_expected.to contain_icinga2__feature('syslog').with({'ensure' => 'present'}) }
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

    it { is_expected.to contain_icinga2__feature('syslog').with({'ensure' => 'absent'}) }
  end


  context "Windows 2012 R2 with all defaults" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    it { is_expected.to contain_icinga2__feature('syslog').with({'ensure' => 'present'}) }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/syslog.conf')
      .with_content(/severity = "warning"/) }
  end


  context 'Windows 2012 R2 with severity => notice' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:severity => 'notice'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/syslog.conf')
        .with_content(/severity = "notice"/)
    }
  end


  context 'Windows 2012 R2 with severity => foo (not a valid value)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:severity => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
  end
end
