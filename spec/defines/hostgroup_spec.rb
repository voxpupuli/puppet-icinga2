require 'spec_helper'

describe('icinga2::object::hostgroup', :type => :define) do
  let(:title) { 'bar' }
  let(:pre_condition) { [
    "class { 'icinga2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with all defaults and target => /bar/baz" do
      let(:params) { {:target =>  '/bar/baz'} }

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.to contain_concat__fragment('icinga2::object::HostGroup::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/object HostGroup "bar"/)
        .without_content(/assign where/)
        .without_content(/ignore where/) }

      it { is_expected.to contain_icinga2__object('icinga2::object::HostGroup::bar')
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with display_name => foo" do
      let(:params) { {:display_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::HostGroup::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/display_name = "foo"/) }
    end


    context "#{os} with groups => [foo, bar]" do
      let(:params) { {:groups => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::HostGroup::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/groups = \[ "foo", "bar", \]/) }
    end


    context "#{os} with groups => foo (not a valid array)" do
      let(:params) { {:groups => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Array/) }
    end


    context "#{os} with assign => [] and ignore => [ foo ]" do
      let(:params) { {:assign => [], :ignore => ['foo'], :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /When attribute ignore is used, assign must be set/) }
    end
  end
end