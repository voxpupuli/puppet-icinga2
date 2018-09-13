require 'spec_helper'

describe('icinga2::object::zone', :type => :define) do
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

      it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/object Zone "bar"/) }
    end


   context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent', :target => '/bar/baz'} }

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.not_to contain_concat__fragment('icinga2::object::Zone::bar') }
    end


    context "#{os} with ensure => foo (not a valid value)" do
      let(:params) { {:ensure => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a match for Enum\['absent', 'present'\]/) }
    end


    context "#{os} with target => bar/baz (not valid absolute path)" do
      let(:params) { {:target => 'bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with endpoints => [NodeName, Host1]" do
      let(:params) { {:endpoints => ['NodeName','Host1'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
        .with_content(/endpoints = \[ NodeName, "Host1", \]/) }
    end


    context "#{os} with endpoints => foo (not a valid array)" do
      let(:params) { {:endpoints => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Array/) }
    end


    context "#{os} with parent => foo" do
      let(:params) { {:parent => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
        .with_content(/parent = "foo"/) }
    end


    context "#{os} with global => true" do
      let(:params) { {:global => true, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
        .with_content(/global = true/) }
    end


    context "#{os} with global => foo (not a valid boolean)" do
      let(:params) { {:global => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Boolean/) }
    end
  end
end