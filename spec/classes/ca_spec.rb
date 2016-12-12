require 'spec_helper'

describe('icinga2::pki::ca', :type => :class) do
  let(:pre_condition) { [
      "class { 'icinga2': }"
  ] }

  before(:all) do
    @ca_cert = "/var/lib/icinga2/ca/ca.crt"
    @ca_key = "/var/lib/icinga2/ca/ca.key"
  end

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with defaults (no params)" do
      it { is_expected.to contain_exec('create-icinga2-ca') }
    end


    context "#{os} with ca_cert => 'foo', ca_key => 'bar'" do
      let(:params) {{:ca_cert => 'foo', :ca_key => 'bar'}}

      it { is_expected.to contain_file(@ca_cert).with_content(/foo/) }
      it { is_expected.to contain_file(@ca_key).with_content(/bar/) }
    end


    context "#{os} with ca_cert => 4247, ca_key => 'bar' (not a valid string)" do
      let(:params) { {:ca_cert => 4247, :ca_key => 'bar'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end

    context "#{os} with ca_cert => 'foo', ca_key => 4247 (not a valid string)" do
      let(:params) { {:ca_cert => 'foo', :ca_key => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end

  end
end

describe('icinga2::pki::ca', :type => :class) do
  let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2',
      :path => 'C:\Program Files\Puppet Labs\Puppet\puppet\bin;
               C:\Program Files\Puppet Labs\Puppet\facter\bin;
               C:\Program Files\Puppet Labs\Puppet\hiera\bin;
               C:\Program Files\Puppet Labs\Puppet\mcollective\bin;
               C:\Program Files\Puppet Labs\Puppet\bin;
               C:\Program Files\Puppet Labs\Puppet\sys\ruby\bin;
               C:\Program Files\Puppet Labs\Puppet\sys\tools\bin;
               C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;
               C:\Windows\System32\WindowsPowerShell\v1.0\;
               C:\ProgramData\chocolatey\bin;',
  } }
  let(:pre_condition) { [
      "class { 'icinga2': }"
  ] }

  before(:all) do
    @ca_cert = "C:/ProgramData/icinga2/var/lib/icinga2/ca/ca.crt"
    @ca_key = "C:/ProgramData/icinga2/var/lib/icinga2/ca/ca.key"
  end

  context "Windows 2012 R2 with defaults (no params)" do
    it { is_expected.to contain_exec('create-icinga2-ca') }
  end


  context "Windows 2012 R2 with ca_cert => 'foo', ca_key => 'bar'" do
    let(:params) {{:ca_cert => 'foo', :ca_key => 'bar'}}

    it { is_expected.to contain_file(@ca_cert).with_content(/foo/) }
    it { is_expected.to contain_file(@ca_key).with_content(/bar/) }
  end


  context "Windows 2012 R2 with ca_cert => 4247, ca_key => 'bar' (not a valid string)" do
    let(:params) { {:ca_cert => 4247, :ca_key => 'bar'} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end

  context "Windows 2012 R2 with ca_cert => 'foo', ca_key => 4247 (not a valid string)" do
    let(:params) { {:ca_cert => 'foo', :ca_key => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


end



