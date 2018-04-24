require 'spec_helper'

describe('icinga2::object::compatlogger', :type => :define) do
  let(:title) { 'bar' }
  let(:pre_condition) { [
      "class { 'icinga2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with all defaults and target => /bar/baz" do
      let(:params) { {:target => '/bar/baz'} }

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.to contain_concat__fragment('icinga2::object::CompatLogger::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object CompatLogger "bar"/) }

      it { is_expected.to contain_concat__fragment('icinga2::object::CompatLogger::bar-library')
                              .with({'target' => '/bar/baz'})
                              .with_content(/library "compat"/) }

      it { is_expected.to contain_icinga2__object('icinga2::object::CompatLogger::bar')
                              .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with compatlogger_name => foo" do
      let(:params) { {:compatlogger_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::CompatLogger::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object CompatLogger "foo"/) }
    end


    context "#{os} with log_dir = /foo/bar" do
      let(:params) { {:log_dir => '/foo/bar', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::CompatLogger::bar')
                              .with({ 'target' => '/bar/baz' })
                              .with_content(/log_dir = "\/foo\/bar"/) }
    end


    context "#{os} with log_dir = foo/bar (not a valid absolute path)" do
      let(:params) { {:log_dir => 'foo/bar', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with rotation_method = 'DAILY'" do
      let(:params) { {:rotation_method => 'DAILY', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::CompatLogger::bar')
                              .with({ 'target' => '/bar/baz' })
                              .with_content(/rotation_method = "DAILY"/) }
    end

    context "#{os} with rotation_method = 'foo' (not a valid absolute path)" do
      let(:params) { {:rotation_method => 'foo', :target => '/bar/baz'} }

    	it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end
  end
end