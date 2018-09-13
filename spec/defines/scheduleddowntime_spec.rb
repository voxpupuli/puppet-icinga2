require 'spec_helper'

describe('icinga2::object::scheduleddowntime', :type => :define) do
  let(:title) { 'bar' }
  let(:pre_condition) { [
      "class { 'icinga2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with all defaults and target => /bar/baz" do
      let(:params) { {
          :target =>  '/bar/baz',
          :host_name => 'foohost',
          :author => 'fooauthor',
          :comment => 'foocomment',
          :ranges => { 'foo' => "bar", 'bar' => "foo"} } }

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object ScheduledDowntime "bar"/) }

      it { is_expected.to contain_icinga2__object('icinga2::object::ScheduledDowntime::bar')
                              .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with scheduleddowntime_name => foo" do
      let(:params) { {:scheduleddowntime_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object ScheduledDowntime "foo"/) }
    end


    context "#{os} with host_name => foo" do
      let(:params) { {:host_name => 'foo', :target => '/bar/baz',
                      :author => 'fooauthor',
                      :comment => 'foocomment',
                      :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/host_name = "foo"/) }
    end


    context "#{os} with service_name => foo" do
      let(:params) { {:service_name => 'foo', :target => '/bar/baz',
                      :host_name => 'foohost',
                      :author => 'fooauthor',
                      :comment => 'foocomment',
                      :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/service_name = "foo"/) }
    end


    context "#{os} with author => foo" do
      let(:params) { {:author => 'foo', :target => '/bar/baz',
                      :host_name => 'foohost',
                      :comment => 'foocomment',
                      :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/author = "foo"/) }
    end


    context "#{os} with fixed => false" do
      let(:params) { {:fixed => false, :target => '/bar/baz',
                      :host_name => 'foohost',
                      :author => 'fooauthor',
                      :comment => 'foocomment',
                      :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/fixed = false/) }
    end


    context "#{os} with fixed => foo (not a valid boolean)" do
      let(:params) { {:fixed => 'foo', :target => '/bar/baz',
                      :host_name => 'foohost',
                      :author => 'fooauthor',
                      :comment => 'foocomment',
                      :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Boolean/) }
    end


    context "#{os} with duration => 30" do
      let(:params) { {:duration => '30', :target => '/bar/baz',
                      :host_name => 'foohost',
                      :author => 'fooauthor',
                      :comment => 'foocomment',
                      :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/duration = 30/) }
    end


    context "#{os} with duration => 30m" do
      let(:params) { {:duration => '30m', :target => '/bar/baz',
                      :host_name => 'foohost',
                      :author => 'fooauthor',
                      :comment => 'foocomment',
                      :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/duration = 30m/) }
    end


    context "#{os} with duration => foo (not a valid integer)" do
      let(:params) { {:duration => 'foo', :target => '/bar/baz',
                      :host_name => 'foohost',
                      :author => 'fooauthor',
                      :comment => 'foocomment',
                      :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with ranges => { foo => 'bar', bar => 'foo' }" do
      let(:params) { {:ranges => { 'foo' => "bar", 'bar' => "foo"}, :target => '/bar/baz',
                      :host_name => 'foohost',
                      :author => 'fooauthor',
                      :comment => 'foocomment' } }

      it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                              .with({ 'target' => '/bar/baz' })
                              .with_content(/ranges = {\n\s+foo = "bar"\n\s+bar = "foo"\n\s+}/) }
    end


    context "#{os} with ranges => 'foo' (not a valid hash)" do
      let(:params) { {:ranges => 'foo', :target => '/bar/baz',
                      :host_name => 'foohost',
                      :author => 'fooauthor',
                      :comment => 'foocomment'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Hash/) }
    end
  end
end