require 'spec_helper'

describe('icinga2::object::dependency', :type => :define) do
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

      it { is_expected.to contain_concat__fragment('icinga2::object::Dependency::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object Dependency "bar"/)
                              .without_content(/assign where/)
                              .without_content(/ignore where/) }

      it { is_expected.to contain_icinga2__object('icinga2::object::Dependency::bar')
                              .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with parent_host_name => foo" do
      let(:params) { {:parent_host_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Dependency::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/parent_host_name = "foo"/) }
    end


    context "#{os} with parent_host_name => 4247 (not a valid string)" do
      let(:params) { {:parent_host_name => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with parent_service_name => foo" do
      let(:params) { {:parent_service_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Dependency::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/parent_service_name = "foo"/) }
    end


    context "#{os} with parent_service_name => 4247 (not a valid string)" do
      let(:params) { {:parent_service_name => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with child_host_name => foo" do
      let(:params) { {:child_host_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Dependency::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/child_host_name = "foo"/) }
    end


    context "#{os} with child_host_name => 4247 (not a valid string)" do
      let(:params) { {:child_host_name => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with child_service_name => foo" do
      let(:params) { {:child_service_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Dependency::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/child_service_name = "foo"/) }
    end


    context "#{os} with child_service_name => 4247 (not a valid string)" do
      let(:params) { {:child_service_name => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with disable_checks => false" do
      let(:params) { {:disable_checks => false, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Dependency::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/disable_checks = false/) }
    end


    context "#{os} with disable_checks => foo (not a valid boolean)" do
      let(:params) { {:disable_checks => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end


    context "#{os} with disable_notifications => false" do
      let(:params) { {:disable_notifications => false, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Dependency::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/disable_notifications = false/) }
    end


    context "#{os} with disable_notifications => foo (not a valid boolean)" do
      let(:params) { {:disable_notifications => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end


    context "#{os} with ignore_soft_states => false" do
      let(:params) { {:ignore_soft_states => false, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Dependency::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/ignore_soft_states = false/) }
    end


    context "#{os} with ignore_soft_states => foo (not a valid boolean)" do
      let(:params) { {:ignore_soft_states => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end


    context "#{os} with period => foo" do
      let(:params) { {:period => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Dependency::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/period = "foo"/) }
    end


    context "#{os} with period => 4247 (not a valid string)" do
      let(:params) { {:period => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with states => [foo, bar]" do
      let(:params) { {:states => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Dependency::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/states = \[ "foo", "bar", \]/) }
    end


    context "#{os} with states => foo (not a valid array)" do
      let(:params) { {:states => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, / "foo" is not an Array/) }
    end
  end
end