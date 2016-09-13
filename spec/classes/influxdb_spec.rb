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
        .without_content(/username = /)
        .without_content(/password = /)
        .with_content(/ssl_enable = false/)
        .with_content(/enable_send_thresholds = false/)
        .with_content(/enable_send_metadata = false/)
        .with_content(/flush_interval = 10s/)
        .with_content(/flush_threshold = 1024/)
        .with_content(/host_template = {\n\s+measurement = "\$host.check_command\$"\n\s+tags = \{\n\s+hostname = "\$host.name\$"\n\s+\}\n\s+\}/)
        .with_content(/service_template = {\n\s+measurement = "\$service.check_command\$"\n\s+tags = \{\n\s+hostname = "\$host.name\$"\n\s+service = "\$service.name\$"\n\s+\}\n\s+/)}
    end


    context "#{os} with host => 127.0.0.2" do
      let(:params) { {:host => '127.0.0.2'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/host = "127.0.0.2"/) }
    end


    context "#{os} with host => foo (not a valid IP address)" do
      let(:params) { {:host => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('influxdb')
        }.to raise_error(Puppet::Error, /"foo" is not a valid IP address/)
      end
    end


    context "#{os} with port => 4247" do
      let(:params) { {:port => '4247'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
        .with_content(/port = 4247/) }
    end


    context "#{os} with port => foo (not a valid integer)" do
      let(:params) { {:port => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('influxdb')
        }.to raise_error(Puppet::Error, /first argument to be an Integer/)
      end
    end


    context "#{os} with database => foo" do
      let(:params) { {:database => 'foo'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
                              .with_content(/database = "foo"/) }
    end


    context "#{os} with database => 123 (not a valid string)" do
      let(:params) { {:database => 123} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('influxdb')
        }.to raise_error(Puppet::Error, /123 is not a string/)
      end
    end


    context "#{os} with username => foo" do
      let(:params) { {:username => 'foo'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
                              .with_content(/username = "foo"/) }
    end


    context "#{os} with username => 123 (not a valid string)" do
      let(:params) { {:username => 123} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('influxdb')
        }.to raise_error(Puppet::Error, /123 is not a string/)
      end
    end

    context "#{os} with password => foo" do
      let(:params) { {:password => 'foo'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
                              .with_content(/password = "foo"/) }
    end


    context "#{os} with password => 123 (not a valid string)" do
      let(:params) { {:password => 123} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('influxdb')
        }.to raise_error(Puppet::Error, /123 is not a string/)
      end
    end


    context "#{os} with ssl_enable => true" do
      let(:params) { {:ssl_enable => true} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
                              .with_content(/ssl_enable = true/) }
    end


    context "#{os} with ssl_enable => false" do
      let(:params) { {:ssl_enable => false} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
                              .with_content(/ssl_enable = false/) }
    end


    context "#{os} with ssl_enable => foo (not a valid boolean)" do
      let(:params) { {:ssl_enable => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('influxdb')
        }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
      end
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

      it do
        expect {
          is_expected.to contain_icinga2__feature('influxdb')
        }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
      end
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

      it do
        expect {
          is_expected.to contain_icinga2__feature('influxdb')
        }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
      end
    end

    context "#{os} with flush_interval => 50s" do
      let(:params) { {:flush_interval => '50s'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
                              .with_content(/flush_interval = 50s/) }
    end


    context "#{os} with flush_interval => foo (not a valid value)" do
      let(:params) { {:flush_interval => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('influxdb')
        }.to raise_error(Puppet::Error, /"foo" does not match/)
      end
    end


    context "#{os} with flush_threshold => 2048" do
      let(:params) { {:flush_threshold => '2048'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/influxdb.conf')
                              .with_content(/flush_threshold = 2048/) }
    end


    context "#{os} with flush_threshold => foo (not a valid integer)" do
      let(:params) { {:flush_threshold => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('influxdb')
        }.to raise_error(Puppet::Error, /first argument to be an Integer/)
      end
    end

  end

end



describe('icinga2::feature::influxdb', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  let(:facts) { {
    :kernel => 'Windows',
    :architecture => 'x86_64',
    :osfamily => 'Windows',
    :operatingsystem => 'Windows',
    :operatingsystemmajrelease => '2012 R2'
  } }

  context 'Windows 2012 R2 with ensure => present' do
    let(:params) { {:ensure => 'present'} }

    it { is_expected.to contain_icinga2__feature('influxdb').with({'ensure' => 'present'}) }
  end


  context 'Windows 2012 R2 with ensure => absent' do
    let(:params) { {:ensure => 'absent'} }

    it { is_expected.to contain_icinga2__feature('influxdb').with({'ensure' => 'absent'}) }
  end


  context "Windows 2012 R2 with all defaults" do
    it { is_expected.to contain_icinga2__feature('influxdb').with({'ensure' => 'present'}) }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/host = "127.0.0.1"/)
      .with_content(/port = 8086/)
      .with_content(/database = "icinga2"/)
      .without_content(/username = /)
      .without_content(/password = /)
      .with_content(/ssl_enable = false/)
      .with_content(/enable_send_thresholds = false/)
      .with_content(/enable_send_metadata = false/)
      .with_content(/flush_interval = 10s/)
      .with_content(/flush_threshold = 1024/)
      .with_content(/host_template = {\r\n\s+measurement = "\$host.check_command\$"\r\n\s+tags = \{\r\n\s+hostname = "\$host.name\$"\r\n\s+\}\r\n\s+\}/)
      .with_content(/service_template = {\r\n\s+measurement = "\$service.check_command\$"\r\n\s+tags = \{\r\n\s+hostname = "\$host.name\$"\r\n\s+service = "\$service.name\$"\r\n\s+\}\r\n\s+/) }
  end


  context "Windows 2012 R2 with host => 127.0.0.1" do
    let(:params) { {:host => '127.0.0.1'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/host = "127.0.0.1"/) }
  end


  context "Windows 2012 R2 with host => foo (not a valid IP address)" do
    let(:params) { {:host => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('influxdb')
      }.to raise_error(Puppet::Error, /"foo" is not a valid IP address/)
    end
  end


  context "Windows 2012 R2 with port => 4247" do
    let(:params) { {:port => '4247'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/port = 4247/) }
  end


  context "Windows 2012 R2 with port => foo (not a valid integer)" do
    let(:params) { {:port => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('influxdb')
      }.to raise_error(Puppet::Error, /first argument to be an Integer/)
    end
  end


  context "Windows 2012 R2 with database => foo" do
    let(:params) { {:database => 'foo'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
                            .with_content(/database = "foo"/) }
  end


  context "Windows 2012 R2 with database => 123 (not a valid string)" do
    let(:params) { {:database => 123} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('influxdb')
      }.to raise_error(Puppet::Error, /123 is not a string/)
    end
  end


  context "Windows 2012 R2 with username => foo" do
    let(:params) { {:username => 'foo'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
                            .with_content(/username = "foo"/) }
  end


  context "Windows 2012 R2 with username => 123 (not a valid string)" do
    let(:params) { {:username => 123} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('influxdb')
      }.to raise_error(Puppet::Error, /123 is not a string/)
    end
  end


  context "Windows 2012 R2 with password => foo" do
    let(:params) { {:password => 'foo'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
                            .with_content(/password = "foo"/) }
  end


  context "Windows 2012 R2 with password => 123 (not a valid string)" do
    let(:params) { {:password => 123} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('influxdb')
      }.to raise_error(Puppet::Error, /123 is not a string/)
    end
  end


  context "Windows 2012 R2 with ssl_enable => true" do
    let(:params) { {:ssl_enable => true} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
                            .with_content(/ssl_enable = true/) }
  end


  context "Windows 2012 R2 with ssl_enable => false" do
    let(:params) { {:ssl_enable => false} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
                            .with_content(/ssl_enable = false/) }
  end


  context "Windows 2012 R2 with ssl_enable => foo (not a valid boolean)" do
    let(:params) { {:ssl_enable => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('influxdb')
      }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
    end
  end


  context "Windows 2012 R2 with enable_send_thresholds => true" do
    let(:params) { {:enable_send_thresholds => true} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/enable_send_thresholds = true/) }
  end


  context "Windows 2012 R2 with enable_send_thresholds => false" do
    let(:params) { {:enable_send_thresholds => false} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/enable_send_thresholds = false/) }
  end


  context "Windows 2012 R2 with enable_send_thresholds => foo (not a valid boolean)" do
    let(:params) { {:enable_send_thresholds => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('influxdb')
      }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
    end
  end


  context "Windows 2012 R2 with enable_send_metadata => true" do
    let(:params) { {:enable_send_metadata => true} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/enable_send_metadata = true/) }
  end


  context "Windows 2012 R2 with enable_send_metadata => false" do
    let(:params) { {:enable_send_metadata => false} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
      .with_content(/enable_send_metadata = false/) }
  end


  context "Windows 2012 R2 with enable_send_metadata => foo (not a valid boolean)" do
    let(:params) { {:enable_send_metadata => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('influxdb')
      }.to raise_error(Puppet::Error, /"foo" is not a boolean/)
    end
  end

  context "Windows 2012 R2 with flush_interval => 50s" do
    let(:params) { {:flush_interval => '50s'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
                            .with_content(/flush_interval = 50s/) }
  end


  context "Windows 2012 R2 with flush_interval => foo (not a valid value)" do
    let(:params) { {:flush_interval => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('influxdb')
      }.to raise_error(Puppet::Error, /"foo" does not match/)
    end
  end


  context "Windows 2012 R2 with flush_threshold => 2048" do
    let(:params) { {:flush_threshold => '2048'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/influxdb.conf')
                            .with_content(/flush_threshold = 2048/) }
  end


  context "Windows 2012 R2 with flush_threshold => foo (not a valid integer)" do
    let(:params) { {:flush_threshold => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('influxdb')
      }.to raise_error(Puppet::Error, /first argument to be an Integer/)
    end
  end

end
