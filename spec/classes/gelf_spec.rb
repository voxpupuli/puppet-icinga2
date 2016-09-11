require 'spec_helper'

describe('icinga2::feature::gelf', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('gelf').with({'ensure' => 'present'}) }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('gelf').with({'ensure' => 'absent'}) }
    end


    context "#{os} with host => 127.0.0.2" do
      let(:params) { {:host => '127.0.0.2'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/gelf.conf')
          .with_content(/host = "127.0.0.2"/)
      }
    end


    context "#{os} with host => foo (not a valid IP address)" do
      let(:params) { {:host => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('gelf')
        }.to raise_error(Puppet::Error, /"foo" is not a valid IP address/)
      end
    end


    context "#{os} with port => 4247" do
      let(:params) { {:port => '4247'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/gelf.conf')
          .with_content(/port = 4247/)
      }
    end


    context "#{os} with port => foo (not a valid integer)" do
      let(:params) { {:port => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('gelf')
        }.to raise_error(Puppet::Error, /first argument to be an Integer/)
      end
    end


    context "#{os} with source => foo" do
      let(:params) { {:source => 'foo'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/gelf.conf')
          .with_content(/source = "foo"/)
      }
    end


    context "#{os} with source => 4247 (not a valid string)" do
      let(:params) { {:source => 4247} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('gelf')
        }.to raise_error(Puppet::Error, /4247 is not a string/)
      end
    end


    context "#{os} with enable_send_perfdata => true" do
      let(:params) { {:enable_send_perfdata => true} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/gelf.conf')
          .with_content(/enable_send_perfdata = true/)
      }
    end


    context "#{os} with enable_send_perfdata => false" do
      let(:params) { {:enable_send_perfdata => false} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/gelf.conf')
          .with_content(/enable_send_perfdata = false/)
      }
    end


    context "#{os} with enable_send_perfdata => foo (not a valid boolean)" do
      let(:params) { {:enable_send_perfdata => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('gelf')
        }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
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

    it { is_expected.to contain_icinga2__feature('gelf').with({'ensure' => 'present'}) }
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

    it { is_expected.to contain_icinga2__feature('gelf').with({'ensure' => 'absent'}) }
  end


  context "Windows 2012 R2  with host => 127.0.0.2" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:host => '127.0.0.2'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/gelf.conf')
        .with_content(/host = "127.0.0.2"/)
    }
  end


  context "Windows 2012 R2 with host => foo (not a valid IP address)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:host => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('gelf')
      }.to raise_error(Puppet::Error, /"foo" is not a valid IP address/)
    end
  end


  context "Windows 2012 R2 with port => 4247" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:port => '4247'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/gelf.conf')
        .with_content(/port = 4247/)
    }
  end


  context "Windows 2012 R2 with source => 4247 (not a valid string)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:source => 4247} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('gelf')
      }.to raise_error(Puppet::Error, /4247 is not a string/)
    end
  end


  context 'Windows 2012 R2 with source => foo' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:source => 'foo'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/gelf.conf')
        .with_content(/source = "foo"/)
    }
  end


  context 'Windows 2012 R2 with source => 4247 (not a valid string)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:source => 4247} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('gelf')
      }.to raise_error(Puppet::Error, /4247 is not a string/)
    end
  end


  context "Windows 2012 R2 with enable_send_perfdata => true" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:enable_send_perfdata => true} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/gelf.conf')
        .with_content(/enable_send_perfdata = true/)
    }
  end


  context "Windows 2012 R2 with enable_send_perfdata => false" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:enable_send_perfdata => false} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/gelf.conf')
        .with_content(/enable_send_perfdata = false/)
    }
  end


  context "Windows 2012 R2 with enable_send_perfdata => foo (not a valid boolean)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:enable_send_perfdata => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('gelf')
      }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
    end
  end
end
