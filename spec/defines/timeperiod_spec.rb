require 'spec_helper'

describe('icinga2::object::timeperiod', :type => :define) do
  let(:title) { 'bar' }
  let(:pre_condition) { [
      "class { 'icinga2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with all defaults and target => /bar/baz" do
      let(:params) { {:target =>  '/bar/baz', :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.to contain_concat__fragment('icinga2::object::TimePeriod::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object TimePeriod "bar"/)
                              .without_content(/assign where/)
                              .without_content(/ignore where/) }

      it { is_expected.to contain_icinga2__object('icinga2::object::TimePeriod::bar')
                              .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with timeperiod_name => foo" do
      let(:params) { {:timeperiod_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::TimePeriod::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object TimePeriod "foo"/) }
    end


    context "#{os} with display_name => foo" do
      let(:params) { {:display_name => 'foo', :target => '/bar/baz', :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to contain_concat__fragment('icinga2::object::TimePeriod::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/display_name = "foo"/) }
    end


    context "#{os} with ranges => { foo => 'bar', bar => 'foo' }" do
      let(:params) { {:ranges => { 'foo' => "bar", 'bar' => "foo"}, :target => '/bar/baz' } }

      it { is_expected.to contain_concat__fragment('icinga2::object::TimePeriod::bar')
                              .with({ 'target' => '/bar/baz' })
                              .with_content(/ranges = {\n\s+foo = "bar"\n\s+bar = "foo"\n\s+}/) }
    end


    context "#{os} with ranges => 'foo' (not a valid hash)" do
      let(:params) { {:ranges => 'foo', :target => '/bar/baz' } }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Hash/) }
    end


    context "#{os} with prefer_incluces => false" do
      let(:params) { {:prefer_includes => false, :target => '/bar/baz', :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to contain_concat__fragment('icinga2::object::TimePeriod::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/prefer_includes = false/) }
    end


    context "#{os} with prefer_includes => foo (not a valid boolean)" do
      let(:params) { {:prefer_includes => 'foo', :target => '/bar/baz', :ranges => { 'foo' => "bar", 'bar' => "foo"}} }

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Boolean/) }
    end


    context "#{os} with excludes => [foo, bar]" do
      let(:params) { {:excludes => ['foo','bar'], :target => '/bar/baz', :ranges => { 'foo' => "bar", 'bar' => "foo"} }}

      it { is_expected.to contain_concat__fragment('icinga2::object::TimePeriod::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/excludes = \[ "foo", "bar", \]/) }
    end


    context "#{os} with excludes => foo (not a valid array)" do
      let(:params) { {:excludes => 'foo', :target => '/bar/baz', :ranges => { 'foo' => "bar", 'bar' => "foo"} }}

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Array/) }
    end


    context "#{os} with includes => [foo, bar]" do
      let(:params) { {:includes => ['foo','bar'], :target => '/bar/baz', :ranges => { 'foo' => "bar", 'bar' => "foo"} }}

      it { is_expected.to contain_concat__fragment('icinga2::object::TimePeriod::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/includes = \[ "foo", "bar", \]/) }
    end


    context "#{os} with includes => foo (not a valid array)" do
      let(:params) { {:includes => 'foo', :target => '/bar/baz', :ranges => { 'foo' => "bar", 'bar' => "foo"} }}

      it { is_expected.to raise_error(Puppet::Error, /expects a value of type Undef or Array/) }
    end
  end
end