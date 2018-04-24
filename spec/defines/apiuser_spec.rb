require 'spec_helper'

describe('icinga2::object::apiuser', :type => :define) do
  let(:title) { 'bar' }
  let(:pre_condition) { [
    "class { 'icinga2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with all defaults and permissions => ['*'], target => /bar/baz" do
      let(:params) { {:target =>  '/bar/baz', :permissions => ['*']} }

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.to contain_concat__fragment('icinga2::object::ApiUser::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/object ApiUser "bar"/)
        .with_content(/permissions = \[ "\*", \]/) }

      it { is_expected.to contain_icinga2__object('icinga2::object::ApiUser::bar')
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with target => bar/baz (not valid absolute path)" do
      let(:params) { {:target => 'bar/baz', :permissions => ['*']} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with password => foo" do
      let(:params) { {:password => 'foo', :permissions => ['*'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ApiUser::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/password = "foo"/) }
    end


    context "#{os} with client_cn => foo" do
      let(:params) { {:client_cn => 'foo', :permissions => ['*'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ApiUser::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/client_cn = "foo"/) }
    end


    context "#{os} with permissions => [foo, bar]" do
      let(:params) { {:permissions => ['foo', 'bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ApiUser::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/permissions = \[ "foo", "bar", \]/) }
    end


    context "#{os} with permissions => foo (not a valid array)" do
      let(:params) { {:permissions => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects an Array value/) }
    end
  end
end