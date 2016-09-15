require 'spec_helper'

describe('icinga2::feature::statusdata', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('statusdata').with({'ensure' => 'present'}) }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('statusdata').with({'ensure' => 'absent'}) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('statusdata').with({'ensure' => 'present'}) }

      it { is_expected.to contain_file('/etc/icinga2/features-available/statusdata.conf')
        .with_content(/update_interval = 30s/)
        .with_content(/status_path = "\/var\/cache\/icinga2\/status.dat"/)
        .with_content(/objects_path = "\/var\/cache\/icinga2\/objects.cache"/) }
    end


    context "#{os} with update_interval => 1m" do
      let(:params) { {:update_interval => '1m'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/statusdata.conf')
        .with_content(/update_interval = 1m/) }
    end


    context "#{os} with update_interval => foo (not a valid value)" do
      let(:params) { {:update_interval => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
    end


    context "#{os} with status_path => /foo/bar" do
      let(:params) { {:status_path => '/foo/bar'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/statusdata.conf')
        .with_content(/status_path = "\/foo\/bar"/) }
    end


    context "#{os} with status_path => foo/bar (not an absolute path)" do
      let(:params) { {:status_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
    end


    context "#{os} with objects_path => /foo/bar" do
      let(:params) { {:objects_path => '/foo/bar'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/statusdata.conf')
          .with_content(/objects_path = "\/foo\/bar"/)
      }
    end


    context "#{os} with objects_path => foo/bar (not an absolute path)" do
      let(:params) { {:objects_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
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

    it { is_expected.to contain_icinga2__feature('statusdata').with({'ensure' => 'present'}) }
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

    it { is_expected.to contain_icinga2__feature('statusdata').with({'ensure' => 'absent'}) }
  end


  context "Windows 2012 R2 with all defaults" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    it { is_expected.to contain_icinga2__feature('statusdata').with({'ensure' => 'present'}) }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/statusdata.conf')
      .with_content(/update_interval = 30s/)
      .with_content(/status_path = "C:\/ProgramData\/icinga2\/var\/cache\/icinga2\/status.dat"/)
      .with_content(/objects_path = "C:\/ProgramData\/icinga2\/var\/cache\/icinga2\/objects.cache"/) }
  end


  context 'Windows 2012 R2 with update_interval => 1m' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:update_interval => '1m'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/statusdata.conf')
        .with_content(/update_interval = 1m/)
    }
  end


  context 'Windows 2012 R2 with update_interval => foo (not a valid value)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:update_interval => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
  end


  context 'Windows 2012 R2 with status_path => c:/foo/bar' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:status_path => 'c:/foo/bar'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/statusdata.conf')
        .with_content(/status_path = "c:\/foo\/bar"/)
    }
  end


  context 'Windows 2012 R2 with status_path => foo/bar (not an absolute path)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:status_path => 'foo/bar'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
  end


  context 'Windows 2012 R2 with objects_path => c:/foo/bar' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:objects_path => 'c:/foo/bar'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/statusdata.conf')
        .with_content(/objects_path = "c:\/foo\/bar"/)
    }
  end


  context 'Windows 2012 R2 with objects_path => foo/bar (not an absolute path)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:objects_path => 'foo/bar'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
  end
end
