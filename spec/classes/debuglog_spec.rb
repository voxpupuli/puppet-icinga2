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
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('debuglog').with({'ensure' => 'absent'}) }
    end


    context "#{os} with path => /foo/bar" do
      let(:params) { {:path => '/foo/bar'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/debuglog.conf')
          .with_content(/path = "\/foo\/bar"/)
      }
    end


    context "#{os} with path => foo/bar (not an absolute path)" do
      let(:params) { {:path => 'foo/bar'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('debuglog')
        }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
      end
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

    it { is_expected.to contain_icinga2__feature('debuglog').with({'ensure' => 'present'}) }
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

    it { is_expected.to contain_icinga2__feature('debuglog').with({'ensure' => 'absent'}) }
  end


  context 'Windows 2012 R2 with path => c:/foo/bar' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:path => 'c:/foo/bar'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/debuglog.conf')
        .with_content(/path = "c:\/foo\/bar"/)
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
    let(:params) { {:path => 'foo/bar'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('debuglog')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end
end
