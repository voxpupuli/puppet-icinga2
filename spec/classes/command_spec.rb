require 'spec_helper'

describe('icinga2::feature::command', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('command').with({'ensure' => 'present'}) }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('command').with({'ensure' => 'absent'}) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('command').with({'ensure' => 'present'}) }

      it { is_expected.to contain_file('/etc/icinga2/features-available/command.conf')
          .with_content(/command_path = "\/var\/run\/icinga2\/cmd\/icinga2.cmd"/) }
    end


    context "#{os} with command_path => /foo/bar" do
      let(:params) { {:command_path => '/foo/bar'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/command.conf')
          .with_content(/command_path = "\/foo\/bar"/)
      }
    end


    context "#{os} with command_path => foo/bar (not an absolute path)" do
      let(:params) { {:command_path => 'foo/bar'} }

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

    it { is_expected.to contain_icinga2__feature('command').with({'ensure' => 'present'}) }
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

    it { is_expected.to contain_icinga2__feature('command').with({'ensure' => 'absent'}) }
  end


  context "Windows 2012 R2 with all defaults" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    it { is_expected.to contain_icinga2__feature('command').with({'ensure' => 'present'}) }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/command.conf')
      .with_content(/command_path = "C:\/ProgramData\/icinga2\/var\/run\/icinga2\/cmd\/icinga2.cmd"/) }
  end


  context 'Windows 2012 R2 with command_path => c:/foo/bar' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:command_path => 'c:/foo/bar'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/command.conf')
        .with_content(/command_path = "c:\/foo\/bar"/)
    }
  end


  context 'Windows 2012 R2 with path => foo/bar (not an absolute path)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:command_path => 'foo/bar'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
  end
end
