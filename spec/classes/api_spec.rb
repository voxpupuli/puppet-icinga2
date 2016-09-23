require 'spec_helper'

describe('icinga2::feature::api', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], constants => {'NodeName' => 'host.example.org'} }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('api').with({'ensure' => 'present'}) }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('api').with({'ensure' => 'absent'}) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('api').with({'ensure' => 'present'}) }

      it { is_expected.to contain_file('/etc/icinga2/features-available/api.conf')
        .with_content(/accept_config = false/)
        .with_content(/accept_commands = false/) }

      it { is_expected.to contain_file('/etc/icinga2/pki/host.example.org.key')  }
      it { is_expected.to contain_file('/etc/icinga2/pki/host.example.org.crt')  }
      it { is_expected.to contain_file('/etc/icinga2/pki/ca.crt')  }

      it { is_expected.to contain_icinga2__object__endpoint('NodeName') }

      it { is_expected.to contain_icinga2__object__zone('ZoneName')
        .with({ 'endpoints' => [ 'NodeName' ] }) }
    end


    context "#{os} with pki => puppet" do
      let(:params) { {:pki => 'puppet'} }

      it { is_expected.to contain_file('/etc/icinga2/pki/host.example.org.key')  }
      it { is_expected.to contain_file('/etc/icinga2/pki/host.example.org.crt')  }
      it { is_expected.to contain_file('/etc/icinga2/pki/ca.crt')  }
    end


    context "#{os} with pki => foo (not a valid value)" do
      let(:params) { {:pki => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /Valid values are 'puppet' and 'none'/) }
    end


    context "#{os} with ssl_key_path = /foo/bar" do
      let(:params) { {:ssl_key_path => '/foo/bar'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/api.conf')
        .with_content(/key_path = "\/foo\/bar"/) }
    end


    context "#{os} with ssl_key_path = foo/bar (not a valid absolute path)" do
      let(:params) { {:ssl_key_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
    end


    context "#{os} with ssl_cert_path = /foo/bar" do
      let(:params) { {:ssl_cert_path => '/foo/bar'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/api.conf')
        .with_content(/cert_path = "\/foo\/bar"/) }
    end


    context "#{os} with ssl_cert_path = foo/bar (not a valid absolute path)" do
      let(:params) { {:ssl_cert_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
    end


    context "#{os} with ssl_ca_path = /foo/bar" do
      let(:params) { {:ssl_ca_path => '/foo/bar'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/api.conf')
        .with_content(/ca_path = "\/foo\/bar"/) }
    end


    context "#{os} with ssl_ca_path = foo/bar (not a valid absolute path)" do
      let(:params) { {:ssl_ca_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
    end


    context "#{os} with accept_config => true" do
      let(:params) { {:accept_config => true} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/api.conf')
        .with_content(/accept_config = true/) }
    end


    context "#{os} with accept_config => false" do
      let(:params) { {:accept_config => false} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/api.conf')
        .with_content(/accept_config = false/) }
    end


    context "#{os} with accept_config => foo (not a valid boolean)" do
      let(:params) { {:accept_config => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end


    context "#{os} with accept_commands => true" do
      let(:params) { {:accept_commands => true} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/api.conf')
        .with_content(/accept_commands = true/) }
    end


    context "#{os} with accept_commands => false" do
      let(:params) { {:accept_commands => false} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/api.conf')
        .with_content(/accept_commands = false/) }
    end


    context "#{os} with accept_commands => foo (not a valid boolean)" do
      let(:params) { {:accept_commands => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end


    context "#{os} with ticket_salt => foo" do
      let(:params) { {:ticket_salt => 'foo'} }

      it { is_expected.to contain_file('/etc/icinga2/features-available/api.conf')
        .with_content(/ticket_salt = "foo"/) }
    end


    context "#{os} with ticket_salt => 4247 (not a valid string)" do
      let(:params) { {:ticket_salt => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with endpoints => { foo => {} }" do
      let(:params) { {:endpoints => { 'foo' => {}} }}

      it { is_expected.to contain_icinga2__object__endpoint('foo') }
    end


    context "#{os} with endpoints => foo (not a valid hash)" do
      let(:params) { {:endpoints => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
    end


    context "#{os} with zones => { foo => {endpoints => ['bar']} } }" do
      let(:params) { {:zones => { 'foo' => {'endpoints' => ['bar']}} }}

      it { is_expected.to contain_icinga2__object__zone('foo')
        .with({ 'endpoints' => [ 'bar' ] }) }
    end


    context "#{os} with zones => foo (not a valid hash)" do
      let(:params) { {:zones => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
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

    it { is_expected.to contain_icinga2__feature('api').with({'ensure' => 'present'}) }
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

    it { is_expected.to contain_icinga2__feature('api').with({'ensure' => 'absent'}) }
  end


  context "Windows 2012 R2 with all defaults" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    it { is_expected.to contain_icinga2__feature('api').with({'ensure' => 'present'}) }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/api.conf')
      .with_content(/accept_config = false/)
      .with_content(/accept_commands = false/) }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/pki/host.example.org.key')  }
    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/pki/host.example.org.crt')  }
    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/pki/ca.crt')  }
  end


  context "Windows 2012 R2 with pki => puppet" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:pki => 'puppet'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/pki/host.example.org.key')  }
    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/pki/host.example.org.crt')  }
    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/pki/ca.crt')  }
  end


  context "Windows 2012 R2 with pki => foo (not a valid value)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:pki => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /Valid values are 'puppet' and 'none'/) }
  end


  context "Windows 2012 R2 with ssl_key_path = /foo/bar" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ssl_key_path => '/foo/bar'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/api.conf')
      .with_content(/key_path = "\/foo\/bar"/) }
  end


  context "Windows 2012 R2 with ssl_key_path = foo/bar (not a valid absolute path)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ssl_key_path => 'foo/bar'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
  end


  context "Windows 2012 R2 with ssl_cert_path = /foo/bar" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ssl_cert_path => '/foo/bar'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/api.conf')
      .with_content(/cert_path = "\/foo\/bar"/) }
  end


  context "Windows 2012 R2 with ssl_cert_path = foo/bar (not a valid absolute path)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ssl_cert_path => 'foo/bar'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
  end


  context "Windows 2012 R2 with ssl_ca_path = /foo/bar" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ssl_ca_path => '/foo/bar'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/api.conf')
      .with_content(/ca_path = "\/foo\/bar"/) }
  end


  context "Windows 2012 R2 with ssl_ca_path = foo/bar (not a valid absolute path)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ssl_ca_path => 'foo/bar'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/) }
  end


  context "Windows 2012 R2 with accept_config => true" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:accept_config => true} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/api.conf')
      .with_content(/accept_config = true/) }
  end


  context "Windows 2012 R2 with accept_config => false" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:accept_config => false} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/api.conf')
      .with_content(/accept_config = false/) }
  end


  context "Windows 2012 R2 with accept_config => foo (not a valid boolean)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:accept_config => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end


  context "Windows 2012 R2 with accept_commands => true" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:accept_commands => true} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/api.conf')
      .with_content(/accept_commands = true/) }
  end


  context "Windows 2012 R2 with accept_commands => false" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:accept_commands => false} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/api.conf')
      .with_content(/accept_commands = false/) }
  end


  context "Windows 2012 R2 with accept_config => foo (not a valid boolean)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:accept_commands => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end


  context "Windows 2012 R2  with ticket_salt => foo" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ticket_salt => 'foo'} }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/api.conf')
      .with_content(/ticket_salt = "foo"/) }
  end


  context "Windows 2012 R2  with ticket_salt => 4247 (not a valid string)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ticket_salt => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2  with endpoints => { foo => {} }" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:endpoints => { 'foo' => {}} }}

    it { is_expected.to contain_icinga2__object__endpoint('foo') }
  end


  context "Windows 2012 R2  with endpoints => foo (not a valid hash)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:endpoints => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
  end


  context "Windows 2012 R2  with zones => { foo => {endpoints => ['bar']} } }" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:zones => { 'foo' => {'endpoints' => ['bar']}} }}

    it { is_expected.to contain_icinga2__object__zone('foo')
      .with({ 'endpoints' => [ 'bar' ] }) }
   end


  context "Windows 2012 R2  with zones => foo (not a valid hash)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:zones => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
  end
end

describe('icinga2::feature::api', :type => :class) do
  let(:pre_condition) { [
      "class { 'icinga2': features => [], constants => {'NodeName' => 'host.example.org'} }"
  ] }

  let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
  } }

  context "Windows 2012 R2 with ensure => present" do
    let(:params) { {:ensure => 'present'} }

    it { is_expected.to contain_icinga2__feature('api').with({'ensure' => 'present'}) }
  end

end