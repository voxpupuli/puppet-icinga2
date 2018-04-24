require 'spec_helper'

describe('icinga2::object::endpoint', :type => :define) do
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

      it { is_expected.to contain_concat__fragment('icinga2::object::Endpoint::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/object Endpoint "bar"/) }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent', :target => '/bar/baz'} }

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.not_to contain_concat__fragment('icinga2::object::Endpoint::bar') }
    end


    context "#{os} with ensure => foo (not a valid value)" do
      let(:params) { {:ensure => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a match for Enum\['absent', 'present'\]/) }
    end


    context "#{os} with target => bar/baz (not valid absolute path)" do
      let(:params) { {:target => 'bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with host => foo.example.com" do
      let(:params) { {:host => 'foo.example.com', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Endpoint::bar')
        .with_content(/host = "foo.example.com"/) }
    end


    context "#{os} with port => 4247" do
      let(:params) { {:port => 4247, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Endpoint::bar')
        .with_content(/port = 4247/) }
    end


    context "#{os} with port => foo (not a valid integer)" do
      let(:params) { {:port => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Integer/) }
    end


    context "#{os} with log_duration => 1m" do
      let(:params) { {:log_duration => '1m', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Endpoint::bar')
        .with_content(/log_duration = 1m/) }
    end


    context "#{os} with log_duration => foo (not a valid value)" do
      let(:params) { {:log_duration => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end
  end
end