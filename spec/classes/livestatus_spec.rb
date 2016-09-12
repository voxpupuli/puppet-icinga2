require 'spec_helper'

describe('icinga2::feature::livestatus', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('livestatus').with({'ensure' => 'present'}) }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('livestatus').with({'ensure' => 'absent'}) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('livestatus').with({'ensure' => 'present'}) }

      it { is_expected.to contain_file('/etc/icinga2/features-available/livestatus.conf')
        .with_content(/socket_type = "unix"/)
        .with_content(/bind_host = "127.0.0.1"/)
        .with_content(/bind_port = 6558/)
        .with_content(/socket_path = "\/var\/run\/icinga2\/cmd\/livestatus"/)
        .with_content(/compat_log_path = "\/var\/log\/icinga2\/compat"/) }
    end


    context "#{os} with socket_type => tcp" do
      let(:params) { {:socket_type => 'tcp'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/livestatus.conf')
        .with_content(/socket_type = "tcp"/) }
    end


    context "#{os} with socket_type => foo (not a valid value)" do
      let(:params) { {:socket_type => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('livestatus')
        }.to raise_error(Puppet::Error, /foo isn't supported. Valid values are 'unix' and 'tcp'./)
      end
    end


    context "#{os} with bind_host => 127.0.0.2" do
      let(:params) { {:bind_host => '127.0.0.2'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/livestatus.conf')
        .with_content(/bind_host = "127.0.0.2"/) }
    end


    context "#{os} with bind_host => foo (not a valid IP address)" do
      let(:params) { {:bind_host => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('livestatus')
        }.to raise_error(Puppet::Error, /"foo" is not a valid IP address/)
      end
    end


    context "#{os} with bind_port => 4247" do
      let(:params) { {:bind_port => '4247'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/livestatus.conf')
          .with_content(/bind_port = 4247/)
      }
    end


    context "#{os} with bind_port => foo (not a valid integer)" do
      let(:params) { {:bind_port => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('livestatus')
        }.to raise_error(Puppet::Error, /first argument to be an Integer/)
      end
    end


    context "#{os} with socket_path => /foo/bar" do
      let(:params) { {:socket_path => '/foo/bar'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/livestatus.conf')
          .with_content(/socket_path = "\/foo\/bar"/)
      }
    end


    context "#{os} with socket_path => foo/bar (not an absolute path)" do
      let(:params) { {:socket_path => 'foo/bar'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('livestatus')
        }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
      end
    end


    context "#{os} with compat_log_path => /foo/bar" do
      let(:params) { {:compat_log_path => '/foo/bar'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/livestatus.conf')
          .with_content(/compat_log_path = "\/foo\/bar"/)
      }
    end


    context "#{os} with compat_log_path => foo/bar (not an absolute path)" do
      let(:params) { {:compat_log_path => 'foo/bar'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('livestatus')
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

    it { is_expected.to contain_icinga2__feature('livestatus').with({'ensure' => 'present'}) }
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

    it { is_expected.to contain_icinga2__feature('livestatus').with({'ensure' => 'absent'}) }
  end


  context "Windows 2012 R2 with all defaults" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    it { is_expected.to contain_icinga2__feature('livestatus').with({'ensure' => 'present'}) }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/livestatus.conf')
      .with_content(/socket_type = "unix"/)
      .with_content(/bind_host = "127.0.0.1"/)
      .with_content(/bind_port = 6558/)
      .with_content(/socket_path = "C:\/ProgramData\/icinga2\/var\/run\/icinga2\/cmd\/livestatus"/)
      .with_content(/compat_log_path = "C:\/ProgramData\/icinga2\/var\/log\/icinga2\/compat"/) }
  end


  context 'Windows 2012 R2 with socket_type => tcp' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:socket_type => 'tcp'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/livestatus.conf')
        .with_content(/socket_type = "tcp"/)
    }
  end


  context 'Windows 2012 R2 with socket_type => foo (not a valid value)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:socket_type => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('livestatus')
      }.to raise_error(Puppet::Error, /foo isn't supported. Valid values are 'unix' and 'tcp'./)
    end
  end


  context "Windows 2012 R2 with bind_host => 127.0.0.2" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:bind_host => '127.0.0.2'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/livestatus.conf')
        .with_content(/bind_host = "127.0.0.2"/)
    }
  end


  context "Windows 2012 R2 with bind_host => foo (not a valid IP address)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:bind_host => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('livestatus')
      }.to raise_error(Puppet::Error, /"foo" is not a valid IP address/)
    end
  end


  context "Windows 2012 R2 with bind_port => 4247" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:bind_port => '4247'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/livestatus.conf')
        .with_content(/bind_port = 4247/)
    }
  end


  context "Windows 2012 R2 with bind_port => foo (not a valid integer)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:bind_port => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('livestatus')
      }.to raise_error(Puppet::Error, /first argument to be an Integer/)
    end
  end


  context 'Windows 2012 R2 with socket_path => c:/foo/bar' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:socket_path => 'c:/foo/bar'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/livestatus.conf')
        .with_content(/socket_path = "c:\/foo\/bar"/)
    }
  end


  context 'Windows 2012 R2 with socket_path => foo/bar (not an absolute path)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:socket_path => 'foo/bar'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('livestatus')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end


  context 'Windows 2012 R2 with compat_log_path => c:/foo/bar' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:compat_log_path => 'c:/foo/bar'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/livestatus.conf')
        .with_content(/compat_log_path = "c:\/foo\/bar"/)
    }
  end


  context 'Windows 2012 R2 with compat_log_path => foo/bar (not an absolute path)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:compat_log_path => 'foo/bar'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('livestatus')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end
end
