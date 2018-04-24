require 'spec_helper'

describe('icinga2::pki::ca', :type => :class) do
  let(:pre_condition) { [
      "class { 'icinga2': features => [], constants => {'NodeName' => 'host.example.org'} }"
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

      it { is_expected.to contain_file('/etc/icinga2/pki/host.example.org.key')  }
      it { is_expected.to contain_file('/etc/icinga2/pki/host.example.org.crt')  }
      it { is_expected.to contain_file('/etc/icinga2/pki/ca.crt')  }
    end


    context "#{os} with ca_cert => 'foo', ca_key => 'bar'" do
      let(:params) {{:ca_cert => 'foo', :ca_key => 'bar'}}

      it { is_expected.to contain_file(@ca_cert).with_content(/foo/) }
      it { is_expected.to contain_file(@ca_key).with_content(/bar/) }
    end

    context "#{os} with ssl_key_path = /foo/bar" do
      let(:params) { {:ssl_key_path => '/foo/bar'} }

      it { is_expected.to contain_file('/foo/bar')  }
    end


    context "#{os} with ssl_key_path = foo/bar (not a valid absolute path)" do
      let(:params) { {:ssl_key_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with ssl_cert_path = /foo/bar" do
      let(:params) { {:ssl_cert_path => '/foo/bar'} }

      it { is_expected.to contain_file('/foo/bar')  }
    end


    context "#{os} with ssl_cert_path = foo/bar (not a valid absolute path)" do
      let(:params) { {:ssl_cert_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with ssl_csr_path = /foo/bar" do
      let(:params) { {:ssl_csr_path => '/foo/bar'} }

      it { is_expected.to contain_file('/foo/bar')  }
    end


    context "#{os} with ssl_csr_path = foo/bar (not a valid absolute path)" do
      let(:params) { {:ssl_csr_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with ssl_cacert_path = /foo/bar" do
      let(:params) { {:ssl_cacert_path => '/foo/bar'} }

      it { is_expected.to contain_file('/foo/bar')  }
    end


    context "#{os} with ssl_cacert_path = foo/bar (not a valid absolute path)" do
      let(:params) { {:ssl_cacert_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end
  end
end