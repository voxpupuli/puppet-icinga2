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
          :host_name => "foo",
          :service_name => "fooo",
          :author => "bar",
          :comment => "baz",
          :duration => 5,
          :fixed => true,
          :ranges => { "foo" => "bar" } } }

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object ScheduledDowntime "bar"/)
                              .with_content(/host_name = "foo"/)
                              .with_content(/service_name = "fooo"/)
                              .with_content(/author = "bar/)
                              .with_content(/comment = "baz"/)
                              .with_content(/fixed = true/)
                              .with_content(/duration = 5/)
                              .with_content(/ranges = {\n\s+foo = "bar"\n\s+}/)
      }

      it { is_expected.to contain_icinga2__object('icinga2::object::ScheduledDowntime::bar')
                              .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} host_name => 4247 (not a valid string)" do
      let(:params) { {
          :target =>  '/bar/baz',
          :host_name => 4247,
          :author => "bar",
          :comment => "baz",
          :ranges => { "foo" => "bar" } } }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} service_name => 4247 (not a valid string)" do
      let(:params) { {
          :target =>  '/bar/baz',
          :host_name => "foo",
          :service_name => 4247,
          :author => "bar",
          :comment => "baz",
          :ranges => { "foo" => "bar" } } }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} author => 4247 (not a valid string)" do
      let(:params) { {
          :target =>  '/bar/baz',
          :host_name => "foo",
          :author => 4247,
          :comment => "baz",
          :ranges => { "foo" => "bar" } } }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} comment => 4247 (not a valid string)" do
      let(:params) { {
          :target =>  '/bar/baz',
          :host_name => "foo",
          :author => "bar",
          :comment => 4247,
          :ranges => { "foo" => "bar" } } }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} fixed => 'foo' (not a valid string)" do
      let(:params) { {
          :target =>  '/bar/baz',
          :host_name => "foo",
          :author => "bar",
          :comment => "baz",
          :fixed => "foo",
          :ranges => { "foo" => "bar" } } }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end


    context "#{os} duration => 'foo' (not a valid string)" do
      let(:params) { {
          :target =>  '/bar/baz',
          :host_name => "foo",
          :author => "bar",
          :comment => "baz",
          :duration => "foo",
          :ranges => { "foo" => "bar" } } }

      it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
    end


    context "#{os} ranges => 'foo' (not a valid string)" do
      let(:params) { {
          :target =>  '/bar/baz',
          :host_name => "foo",
          :author => "bar",
          :comment => "baz",
          :ranges => "foo" } }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
    end
  end
end


describe('icinga2::object::scheduleddowntime', :type => :define) do
  let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2',
      :path => 'C:\Program Files\Puppet Labs\Puppet\puppet\bin;
               C:\Program Files\Puppet Labs\Puppet\facter\bin;
               C:\Program Files\Puppet Labs\Puppet\hiera\bin;
               C:\Program Files\Puppet Labs\Puppet\mcollective\bin;
               C:\Program Files\Puppet Labs\Puppet\bin;
               C:\Program Files\Puppet Labs\Puppet\sys\ruby\bin;
               C:\Program Files\Puppet Labs\Puppet\sys\tools\bin;
               C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;
               C:\Windows\System32\WindowsPowerShell\v1.0\;
               C:\ProgramData\chocolatey\bin;',
  } }
  let(:title) { 'bar' }
  let(:pre_condition) { [
      "class { 'icinga2': }"
  ] }


  context "Windows 2012 R2 with all defaults and target => /bar/baz" do
    let(:params) { {
        :target =>  '/bar/baz',
        :host_name => "foo",
        :service_name => "fooo",
        :author => "bar",
        :comment => "baz",
        :duration => 5,
        :fixed => true,
        :ranges => { "foo" => "bar" } } }

    it { is_expected.to contain_concat('/bar/baz') }

    it { is_expected.to contain_concat__fragment('icinga2::object::ScheduledDowntime::bar')
                            .with({'target' => '/bar/baz'})
                            .with_content(/object ScheduledDowntime "bar"/)
                            .with_content(/host_name = "foo"/)
                            .with_content(/service_name = "fooo"/)
                            .with_content(/author = "bar/)
                            .with_content(/comment = "baz"/)
                            .with_content(/fixed = true/)
                            .with_content(/duration = 5/)
                            .with_content(/ranges = {\r\n\s+foo = "bar"\r\n\s+}/)
    }

    it { is_expected.to contain_icinga2__object('icinga2::object::ScheduledDowntime::bar')
                            .that_notifies('Class[icinga2::service]') }
  end


  context "Windows 2012 R2 host_name => 4247 (not a valid string)" do
    let(:params) { {
        :target =>  '/bar/baz',
        :host_name => 4247,
        :author => "bar",
        :comment => "baz",
        :ranges => { "foo" => "bar" } } }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 service_name => 4247 (not a valid string)" do
    let(:params) { {
        :target =>  '/bar/baz',
        :host_name => "foo",
        :service_name => 4247,
        :author => "bar",
        :comment => "baz",
        :ranges => { "foo" => "bar" } } }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 author => 4247 (not a valid string)" do
    let(:params) { {
        :target =>  '/bar/baz',
        :host_name => "foo",
        :author => 4247,
        :comment => "baz",
        :ranges => { "foo" => "bar" } } }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 comment => 4247 (not a valid string)" do
    let(:params) { {
        :target =>  '/bar/baz',
        :host_name => "foo",
        :author => "bar",
        :comment => 4247,
        :ranges => { "foo" => "bar" } } }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 fixed => 'foo' (not a valid string)" do
    let(:params) { {
        :target =>  '/bar/baz',
        :host_name => "foo",
        :author => "bar",
        :comment => "baz",
        :fixed => "foo",
        :ranges => { "foo" => "bar" } } }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end


  context "Windows 2012 R2 duration => 'foo' (not a valid string)" do
    let(:params) { {
        :target =>  '/bar/baz',
        :host_name => "foo",
        :author => "bar",
        :comment => "baz",
        :duration => "foo",
        :ranges => { "foo" => "bar" } } }

    it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
  end


  context "Windows 2012 R2 ranges => 'foo' (not a valid string)" do
    let(:params) { {
        :target =>  '/bar/baz',
        :host_name => "foo",
        :author => "bar",
        :comment => "baz",
        :ranges => "foo" } }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
  end
end
