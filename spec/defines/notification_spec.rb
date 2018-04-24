require 'spec_helper'

describe('icinga2::object::notification', :type => :define) do
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

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object Notification "bar"/) }

      it { is_expected.to contain_icinga2__object('icinga2::object::Notification::bar')
                              .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with notification_name => foo" do
      let(:params) { {:notification_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object Notification "foo"/) }
    end


    context "#{os} with host_name => foo" do
      let(:params) { {:host_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/host_name = "foo"/) }
    end


    context "#{os} with service_name => foo" do
      let(:params) { {:service_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/service_name = "foo"/) }
    end


    context "#{os} with vars => { foo => 'bar', bar => 'foo' }" do
      let(:params) { {:vars => { 'foo' => "bar", 'bar' => "foo"}, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({ 'target' => '/bar/baz' })
                              .with_content(/vars.foo = "bar"/)
                              .with_content(/vars.bar = "foo"/) }
    end


    context "#{os} with users => [foo, bar]" do
      let(:params) { {:users => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/users = \[ "foo", "bar", \]/) }
    end


    context "#{os} with users => host.vars.notification.mail.users" do
      let(:params) { {:users => 'host.vars.notification.mail.users', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/users = host\.vars\.notification\.mail\.users/) }
    end


    context "#{os} with user_groups => [foo, bar]" do
      let(:params) { {:user_groups => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/user_groups = \[ "foo", "bar", \]/) }
    end


    context "#{os} with user_groups => host.vars.notification.mail.groups" do
      let(:params) { {:user_groups => 'host.vars.notification.mail.groups', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/user_groups = host\.vars\.notification\.mail\.groups/) }
    end


    context "#{os} with times => { foo => 'bar', bar => 'foo' }" do
      let(:params) { {:times => { 'foo' => "bar", 'bar' => "foo"}, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({ 'target' => '/bar/baz' })
                              .with_content(/times = {\n\s+foo = "bar"\n\s+bar = "foo"\n\s+}/) }
    end


    context "#{os} with times => 'foo' (not a valid hash)" do
      let(:params) { {:times => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Hash/) }
    end


    context "#{os} with command => foo" do
      let(:params) { {:command => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/command = "foo"/) }
    end


    context "#{os} with interval => 30" do
      let(:params) { {:interval => '30', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/interval = 30/) }
    end


    context "#{os} with interval => 30m" do
      let(:params) { {:interval => '30m', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/interval = 30m/) }
    end


    context "#{os} with interval => foo (not a valid integer)" do
      let(:params) { {:interval => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with period => foo" do
      let(:params) { {:period => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/period = "foo"/) }
    end


    context "#{os} with zone => foo" do
      let(:params) { {:zone => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/zone = "foo"/) }
    end


    context "#{os} with types => [foo, bar]" do
      let(:params) { {:types => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/types = \[ "foo", "bar", \]/) }
    end


    context "#{os} with states => [foo, bar]" do
      let(:params) { {:states => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Notification::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/states = \[ "foo", "bar", \]/) }
    end


    context "#{os} with assign => [] and ignore => [ foo ]" do
      let(:params) { {:assign => [], :ignore => ['foo'], :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /When attribute ignore is used, assign must be set/) }
    end
  end
end