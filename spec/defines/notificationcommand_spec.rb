require 'spec_helper'

describe('icinga2::object::notificationcommand', :type => :define) do
  let(:title) { 'bar' }
  let(:pre_condition) { [
      "class { 'icinga2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with all defaults and target => /bar/baz" do
      let(:params) { {:target =>  '/bar/baz', :command => ['foocommand']} }

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.to contain_concat__fragment('icinga2::object::NotificationCommand::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object NotificationCommand "bar"/)
                              .with_content(/command = \[ "foocommand", \]/)}

      it { is_expected.to contain_icinga2__object('icinga2::object::NotificationCommand::bar')
                              .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with notificationcommand_name => foo" do
      let(:params) { {:notificationcommand_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::NotificationCommand::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object NotificationCommand "foo"/) }
    end


    context "#{os} with command => [foo, bar]" do
      let(:params) { {:command => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::NotificationCommand::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/command = \[ "foo", "bar", \]/) }
    end


    context "#{os} with command => foo" do
      let(:params) { {:command => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::NotificationCommand::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/command = "foo"/) }
    end


    context "#{os} with env => { foo => 'bar', bar => 'foo' }" do
      let(:params) { {:env => { 'foo' => "bar", 'bar' => "foo"}, :target => '/bar/baz', :command => ['foocommand'] } }

      it { is_expected.to contain_concat__fragment('icinga2::object::NotificationCommand::bar')
                              .with({ 'target' => '/bar/baz' })
                              .with_content(/env = {\n\s+foo = "bar"\n\s+bar = "foo"\n\s+}/) }
    end


    context "#{os} with env => 'foo' (not a valid hash)" do
      let(:params) { {:env => 'foo', :target => '/bar/baz', :command => ['foocommand']} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Hash/) }
    end


    context "#{os} with vars => { foo => 'bar', bar => 'foo' }" do
      let(:params) { {:vars => { 'foo' => "bar", 'bar' => "foo"}, :target => '/bar/baz', :command => ['foocommand'] } }

      it { is_expected.to contain_concat__fragment('icinga2::object::NotificationCommand::bar')
                              .with({ 'target' => '/bar/baz' })
                              .with_content(/vars.foo = "bar"/)
                              .with_content(/vars.bar = "foo"/) }
    end


    context "#{os} with timeout => 30" do
      let(:params) { {:timeout => 30, :target => '/bar/baz', :command => ['foocommand']} }

      it { is_expected.to contain_concat__fragment('icinga2::object::NotificationCommand::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/timeout = 30/) }
    end


    context "#{os} with timeout => foo (not a valid integer)" do
      let(:params) { {:timeout => 'foo', :target => '/bar/baz', :command => ['foocommand']} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Integer/) }
    end


    context "#{os} with arguments => {-foo1 => bar1, -foo2 => {bar_21 => baz21}}" do
      let(:params) { {
          :arguments => {'-foo1' => 'bar1', '-foo2' => {'bar_21' => 'baz21'}},
          :target => '/bar/baz',
          :command => ['foocommand']} }

      it { is_expected.to contain_concat__fragment('icinga2::object::NotificationCommand::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/arguments = {\n\s*"-foo1" = "bar1"\n\s*"-foo2" = {\n\s*bar_21 = "baz21"\n\s*}\n\s*}/) }
    end


    context "#{os} with arguments => foo (not a valid hash)" do
      let(:params) { {:arguments => 'foo', :target => '/bar/baz', :command => ['foocommand']} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Hash/) }
    end
  end
end