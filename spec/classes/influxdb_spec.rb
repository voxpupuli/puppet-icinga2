require 'spec_helper'

describe('icinga2::feature::influxdb', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('influxdb').with({'ensure' => 'present'}) }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('influxdb').with({'ensure' => 'absent'}) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('influxdb').with({'ensure' => 'present'}) }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/host = "127.0.0.1"/)
        .with_content(/port = 8086/)
        .with_content(/database = "icinga2"/)
        .with_content(/host_template = {\n    measurement = \"\$host.check_command\$\"\n    tags = {\n      host = \"\$host.name\$\"\n    }\n  }/)
        .with_content(/service_template = {\n    measurement = \"\$service.check_command\$\"\n    tags = {\n      host = \"\$host.name\$\"\n      service = \"\$service.name\$\"\n    }\n  }/)
        .with_content(/enable_send_thresholds = false/)
        .with_content(/enable_send_metadata = false/)
        .with_content(/flush_interval = 10/)
        .with_content(/flush_threshold = 1024/) }

      it { is_expected.not_to contain_file('/etc/icinga2/features-available/influxdb.conf')
       .with_content(/username/)
       .with_content(/password/) }
    end


    context "#{os} with host => 127.0.0.2" do
      let(:params) { {:host => '127.0.0.2'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/host = "127.0.0.2"/) }
    end


    context "#{os} with host => foo (not a valid IP address)" do
      let(:params) { {:host => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a valid IP address/) }
    end


    context "#{os} with port => 4247" do
      let(:params) { {:port => '4247'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/port = 4247/) }
    end


    context "#{os} with port => foo (not a valid integer)" do
      let(:params) { {:port => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
    end


    context "#{os} with database => 4247" do
      let(:params) { {:database => '4247'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/database = "4247"/) }
    end


    context "#{os} with database => 4247 (not a valid string)" do
      let(:params) { {:database => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with username => foo" do
      let(:params) { {:username => 'foo'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/username = "foo"/) }
    end


    context "#{os} with username => 4247 (not a valid string)" do
      let(:params) { {:username => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with password => foo" do
      let(:params) { {:password => 'foo'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/password = "foo"/) }
    end


    context "#{os} with password => 4247 (not a valid string)" do
      let(:params) { {:password => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with host_template => foo" do
      let(:params) { {:host_template => 'foo'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/host_template = foo/) }
    end


    context "#{os} with host_template => 4247 (not a valid string)" do
      let(:params) { {:host_template => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with service_template => foo" do
      let(:params) { {:service_template => 'foo'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/service_template = foo/) }
    end


    context "#{os} with service_template => 4247 (not a valid string)" do
      let(:params) { {:service_template => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with enable_send_thresholds => true" do
      let(:params) { {:enable_send_thresholds => true} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/enable_send_thresholds = true/) }
    end


    context "#{os} with enable_send_thresholds => false" do
      let(:params) { {:enable_send_thresholds => false} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/enable_send_thresholds = false/) }
    end


    context "#{os} with enable_send_thresholds => foo (not a valid boolean)" do
      let(:params) { {:enable_send_thresholds => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end


    context "#{os} with enable_send_metadata => true" do
      let(:params) { {:enable_send_metadata => true} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/enable_send_metadata = true/) }
    end


    context "#{os} with enable_send_metadata => false" do
      let(:params) { {:enable_send_metadata => false} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/enable_send_metadata = false/) }
    end


    context "#{os} with enable_send_metadata => foo (not a valid boolean)" do
      let(:params) { {:enable_send_metadata => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end

    context "#{os} with flush_interval => 20" do
      let(:params) { {:flush_interval => '20'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/flush_interval = 20/) }
    end


    context "#{os} with flush_interval => foo (not a valid integer)" do
      let(:params) { {:flush_interval => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
    end

    context "#{os} with flush_threshold => 1450" do
      let(:params) { {:flush_threshold => '1450'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/flush_threshold = 1450/) }
    end

    context "#{os} with flush_threshold => foo (not a valid integer)" do
      let(:params) { {:flush_threshold => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
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

    it { is_expected.to contain_icinga2__feature('influxdb').with({'ensure' => 'present'}) }
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

    it { is_expected.to contain_icinga2__feature('influxdb').with({'ensure' => 'absent'}) }
  end


  context "Windows 2012 R2 with all defaults" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    it { is_expected.to contain_icinga2__feature('influxdb').with({'ensure' => 'present'}) }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/host = "127.0.0.1"/)
      .with_content(/port = 8086/)
      .with_content(/database = "icinga2"/)
      .with_content(/host_template = {\r\n    measurement = \"\$host.check_command\$\"\r\n    tags = {\r\n      host = \"\$host.name\$\"\r\n    }\r\n  }/)
      .with_content(/service_template = {\r\n    measurement = \"\$service.check_command\$\"\r\n    tags = {\r\n      host = \"\$host.name\$\"\r\n      service = \"\$service.name\$\"\r\n    }\r\n  }/)
      .with_content(/enable_send_thresholds = false/)
      .with_content(/enable_send_metadata = false/)
      .with_content(/flush_interval = 10/)
      .with_content(/flush_threshold = 1024/) }

    it { is_expected.not_to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/username/)
      .with_content(/password/) }
  end


  context "Windows 2012 R2 with host => 127.0.0.1" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:host => '127.0.0.1'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/host = "127.0.0.1"/) }
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

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a valid IP address/) }
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

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/port = 4247/) }
  end


  context "Windows 2012 R2 with port => foo (not a valid integer)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:port => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
  end


  context "Windows 2012 R2 with database => 4247" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:database => '4247'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/database = "4247"/) }
  end


  context "Windows 2012 R2 with database => 4247 (not a valid string)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:database => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with host_template => foo" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:host_template => 'foo'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/host_template = foo/) }
  end


  context "Windows 2012 R2 with host_template => foo (not a valid string)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:host_template => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with service_template => foo" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:service_template => 'foo'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/service_template = foo/) }
  end


  context "Windows 2012 R2 with service_template => foo (not a valid string)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:service_template => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with enable_send_thresholds => true" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:enable_send_thresholds => true} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/enable_send_thresholds = true/) }
  end


  context "Windows 2012 R2 with enable_send_thresholds => false" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:enable_send_thresholds => false} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/enable_send_thresholds = false/) }
  end


  context "Windows 2012 R2 with enable_send_thresholds => foo (not a valid boolean)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:enable_send_thresholds => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end


  context "Windows 2012 R2 with enable_send_metadata => true" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:enable_send_metadata => true} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/enable_send_metadata = true/) }
  end


  context "Windows 2012 R2 with enable_send_metadata => false" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:enable_send_metadata => false} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/enable_send_metadata = false/) }
  end


  context "Windows 2012 R2 with enable_send_metadata => foo (not a valid boolean)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:enable_send_metadata => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end


  context "Windows 2012 R2 with flush_interval => 20" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:flush_interval => '20'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/flush_interval = 20/) }
  end


  context "Windows 2012 R2 with flush_interval => foo (not a valid integer)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:flush_interval => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
  end


  context "Windows 2012 R2 with flush_threshold => 1450" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:flush_threshold => '1450'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/flush_threshold = 1450/) }
  end


  context "Windows 2012 R2 with flush_threshold => foo (not a valid integer)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:flush_threshold => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
  end
end
