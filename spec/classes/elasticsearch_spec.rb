require 'spec_helper'

describe('icinga2::feature::elasticsearch', :type => :class) do
  let(:pre_condition) { [
      "class { 'icinga2': features => [], constants => {'NodeName' => 'host.example.org'} }"
  ] }

  on_supported_os.each do |os, facts|
    let(:facts) do
      facts.merge({
                      :icinga2_puppet_hostcert => '/var/lib/puppet/ssl/certs/host.example.org.pem',
                      :icinga2_puppet_hostprivkey => '/var/lib/puppet/ssl/private_keys/host.example.org.pem',
                      :icinga2_puppet_localcacert => '/var/lib/puppet/ssl/certs/ca.pem',
                  })
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('elasticsearch').with({'ensure' => 'present'}) }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('elasticsearch').with({'ensure' => 'absent'}) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('elasticsearch').with({'ensure' => 'present'}) }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
        .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
        .with_content(/host = "127.0.0.1"/)
        .with_content(/port = 9200/)
        .with_content(/index = "icinga2"/)
        .without_content(/username = /)
        .without_content(/password = /)
        .with_content(/enable_tls = false/)
        .with_content(/enable_send_perfdata = false/)
        .with_content(/flush_interval = 10s/)
        .with_content(/flush_threshold = 1024/) }
    end


    context "#{os} with host => foo.example.com" do
      let(:params) { {:host => 'foo.example.com'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/host = "foo.example.com"/) }
    end


    context "#{os} with port => 4247" do
      let(:params) { {:port => 4247} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/port = 4247/) }
    end


    context "#{os} with port => foo (not a valid integer)" do
      let(:params) { {:port => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects an Integer value/) }
    end


    context "#{os} with index => foo" do
      let(:params) { {:index => 'foo'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/index = "foo"/) }
    end


    context "#{os} with username => foo" do
      let(:params) { {:username => 'foo'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/username = "foo"/) }
    end


    context "#{os} with password => foo" do
      let(:params) { {:password => 'foo'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/password = "foo"/) }
    end


    context "#{os} with enable_ssl => false" do
      let(:params) { {:enable_ssl => false} }


      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/enable_tls = false/)
                              .without_content(/ssl_ca_cert =/)
                              .without_content(/ssl_cert =/)
                              .without_content(/ssl_key/) }
    end


    context "#{os} with enable_ssl => true, pki => puppet" do
      let(:params) { {:enable_ssl => true, :pki => 'puppet'} }

      it { is_expected.to contain_file('/etc/icinga2/pki/elasticsearch/host.example.org.key')  }
      it { is_expected.to contain_file('/etc/icinga2/pki/elasticsearch/host.example.org.crt')  }
      it { is_expected.to contain_file('/etc/icinga2/pki/elasticsearch/ca.crt')  }
    end


    context "#{os} with pki => foo (not a valid value)" do
      let(:params) { {:pki => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a match for Enum\['none', 'puppet'\]/) }
    end


    context "#{os} with enable_ssl = true, pki => none, ssl_key => foo, ssl_cert => bar, ssl_cacert => baz" do
      let(:params) { {:enable_ssl => true, :pki => 'none', 'ssl_key' => 'foo', 'ssl_cert' => 'bar', 'ssl_cacert' => 'baz'} }

      it { is_expected.to contain_file('/etc/icinga2/pki/elasticsearch/host.example.org.key').with({
                                                                                         'mode'  => '0600',
                                                                                     }).with_content(/^foo/) }

      it { is_expected.to contain_file('/etc/icinga2/pki/elasticsearch/host.example.org.crt')
                              .with_content(/^bar/) }

      it { is_expected.to contain_file('/etc/icinga2/pki/elasticsearch/ca.crt')
                              .with_content(/^baz/) }
    end


    context "#{os} with enable_ssl = true, ssl_key_path = /foo/bar" do
      let(:params) { {:enable_ssl => true, :ssl_key_path => '/foo/bar'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/key_path = "\/foo\/bar"/) }
    end


    context "#{os} with enable_ssl = true, ssl_key_path = foo/bar (not a valid absolute path)" do
      let(:params) { {:enable_ssl => true, :ssl_key_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Error while evaluating a Resource Statement/) }
    end


    context "#{os} with enable_ssl = true, ssl_cert_path = /foo/bar" do
      let(:params) { {:enable_ssl => true, :ssl_cert_path => '/foo/bar'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/cert_path = "\/foo\/bar"/) }
    end


    context "#{os} with enable_ssl = true, ssl_cert_path = foo/bar (not a valid absolute path)" do
      let(:params) { {:enable_ssl => true, :ssl_cert_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Error while evaluating a Resource Statement/) }
    end


    context "#{os} with enable_ssl = true, ssl_cacert_path = /foo/bar" do
      let(:params) { {:enable_ssl => true, :ssl_cacert_path => '/foo/bar'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/ca_path = "\/foo\/bar"/) }
    end


    context "#{os} with enable_ssl = true, ssl_cacert_path = foo/bar (not a valid absolute path)" do
      let(:params) { {:enable_ssl => true, :ssl_cacert_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Error while evaluating a Resource Statement/) }
    end


    context "#{os} with enable_send_perfdata => true" do
      let(:params) { {:enable_send_perfdata => true} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/enable_send_perfdata = true/) }
    end


    context "#{os} with enable_send_perfdata => false" do
      let(:params) { {:enable_send_perfdata => false} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/enable_send_perfdata = false/) }
    end


    context "#{os} with enable_send_perfdata => foo (not a valid boolean)" do
      let(:params) { {:enable_send_perfdata => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /Error while evaluating a Resource Statement/) }
    end

    context "#{os} with flush_interval => 50s" do
      let(:params) { {:flush_interval => '50s'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/flush_interval = 50s/) }
    end


    context "#{os} with flush_interval => foo (not a valid value)" do
      let(:params) { {:flush_interval => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /Error while evaluating a Resource Statement/) }
    end


    context "#{os} with flush_threshold => 2048" do
      let(:params) { {:flush_threshold => 2048} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ElasticsearchWriter::elasticsearch')
                              .with({ 'target' => '/etc/icinga2/features-available/elasticsearch.conf' })
                              .with_content(/flush_threshold = 2048/) }
    end


    context "#{os} with flush_threshold => foo (not a valid integer)" do
      let(:params) { {:flush_threshold => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects an Integer value/) }
    end
  end
end