require 'spec_helper'

describe('icinga2::object::user', :type => :define) do
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

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object User "bar"/)
                              .without_content(/assign where/)
                              .without_content(/ignore where/) }

      it { is_expected.to contain_icinga2__object('icinga2::object::User::bar')
                              .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with user_name => foo" do
      let(:params) { {:user_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object User "foo"/) }
    end


    context "#{os} with display_name => foo" do
      let(:params) { {:display_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/display_name = "foo"/) }
    end


    context "#{os} with email => foo" do
      let(:params) { {:email => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/email = "foo"/) }
    end


    context "#{os} with pager => foo" do
      let(:params) { {:pager => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/pager = "foo"/) }
    end


    context "#{os} with vars => { foo => 'bar', bar => 'foo' }" do
      let(:params) { {:vars => { 'foo' => "bar", 'bar' => "foo"}, :target => '/bar/baz' } }

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({ 'target' => '/bar/baz' })
                              .with_content(/vars.foo = "bar"/)
                              .with_content(/vars.bar = "foo"/) }
    end


    context "#{os} with groups => [foo, bar]" do
      let(:params) { {:groups => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/groups = \[ "foo", "bar", \]/) }
    end


    context "#{os} with groups => foo (not a valid array)" do
      let(:params) { {:groups => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Array/) }
    end


    context "#{os} with enable_notifications => false" do
      let(:params) { {:enable_notifications => false, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/enable_notifications = false/) }
    end


    context "#{os} with enable_notifications => foo (not a valid boolean)" do
      let(:params) { {:enable_notifications => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Boolean/) }
    end


    context "#{os} with period => foo" do
      let(:params) { {:period => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/period = "foo"/) }
    end


    context "#{os} with types => [foo, bar]" do
      let(:params) { {:types => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/types = \[ "foo", "bar", \]/) }
    end


    context "#{os} with types => foo (not a valid array)" do
      let(:params) { {:types => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Array/) }
    end


    context "#{os} with states => [foo, bar]" do
      let(:params) { {:states => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::User::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/states = \[ "foo", "bar", \]/) }
    end


    context "#{os} with states => foo (not a valid array)" do
      let(:params) { {:states => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Array/) }
    end
  end
end