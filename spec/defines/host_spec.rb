require 'spec_helper'

describe('icinga2::object::host', :type => :define) do
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

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/object Host "bar"/) }
    end


    context "#{os} with target => bar/baz (not valid absolute path)" do
      let(:params) { {:target => 'bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"bar\/baz" is not an absolute path/) }
    end


    context "#{os} with order => 4247 (not valid string)" do
      let(:params) { {:target => '/bar/baz', :order => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with import => [foo, bar]" do
      let(:params) { {:import => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/import "foo"\n\s*import "bar"/) }
    end


    context "#{os} with import => foo (not a valid array)" do
      let(:params) { {:import => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, / "foo" is not an Array/) }
    end


    context "#{os} with display_name => foo" do
      let(:params) { {:display_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/display_name = "foo"/) }
    end


    context "#{os} with display_name => 4247 (not a valid string)" do
      let(:params) { {:display_name => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with address => 127.0.0.2" do
      let(:params) { {:address => '127.0.0.2', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/address = "127.0.0.2"/) }
    end


    context "#{os} with address => foo (not a valid IP address)" do
      let(:params) { {:address => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a valid IP address/) }
    end


    context "#{os} with address6 => ::2" do
      let(:params) { {:address6 => '::2', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/address6 = "::2"/) }
    end


    context "#{os} with address6 => foo (not a valid IP address)" do
      let(:params) { {:address6 => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a valid IP address/) }
    end


    context "#{os} with groups => [foo, bar]" do
      let(:params) { {:groups => ['foo','bar'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/groups = \[ "foo", "bar", \]/) }
    end


    context "#{os} with groups => foo (not a valid array)" do
      let(:params) { {:groups => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, / "foo" is not an Array/) }
    end


    context "#{os} with vars => {foo1 => bar1, foo2 => {bar21 => {baz1 => bazz1, baz2 => bazz2}}}" do
      let(:params) { {:vars => {'foo1' => 'bar1', 'foo2' => {'bar21' => {'baz1' => 'bazz1', 'baz2' => 'bazz2'}}}, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/vars\.foo1 = "bar1"/)
        .with_content(/vars\.foo2\["bar21"\] = {\n\s*baz1 = "bazz1"\n\s*baz2 = "bazz2"\n\s*}\n/) }
    end


    context "#{os} with check_command => foo" do
      let(:params) { {:check_command => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/check_command = "foo"/) }
    end


    context "#{os} with check_command => 4247 (not a valid string)" do
      let(:params) { {:check_command => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with max_check_attempts => 3" do
      let(:params) { {:max_check_attempts => '3', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/max_check_attempts = 3/) }
    end


    context "#{os} with max_check_attempts => foo (not a valid integer)" do
      let(:params) { {:max_check_attempts => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
    end


    context "#{os} with check_period => foo" do
      let(:params) { {:check_period => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/check_period = "foo"/) }
    end


    context "#{os} with check_period => 4247 (not a valid string)" do
      let(:params) { {:check_period => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with check_timeout => 1m" do
      let(:params) { {:check_timeout => '1m', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/check_timeout = 1m/) }
    end


    context "#{os} with check_timeout => foo (not a valid value)" do
      let(:params) { {:check_timeout => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
    end


    context "#{os} with check_interval => 1m" do
      let(:params) { {:check_interval => '1m', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/check_interval = 1m/) }
    end


    context "#{os} with check_interval => foo (not a valid value)" do
      let(:params) { {:check_interval => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
    end


    context "#{os} with retry_interval => 30s" do
      let(:params) { {:retry_interval => '30s', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/retry_interval = 30s/) }
    end


    context "#{os} with retry_interval => foo (not a valid value)" do
      let(:params) { {:retry_interval => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
    end


    context "#{os} with enable_notifications => true" do
      let(:params) { {:enable_notifications => true, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/enable_notifications = true/) }
    end


    context "#{os} with enable_notifications => false" do
      let(:params) { {:enable_notifications => false, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/enable_notifications = false/) }
    end


    context "#{os} with enable_notifications => foo (not a valid boolean)" do
      let(:params) { {:enable_notifications => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end


    context "#{os} with template => true" do
      let(:params) { {:template => true, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/template Host "bar"/) }
    end


    context "#{os} with template => foo (not a valid boolean)" do
      let(:params) { {:template => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end
  end
end


describe('icinga2::object::host', :type => :define) do
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

  context "Windows 2012 R2 with all defaults and target => C:/bar/baz" do
    let(:params) { {:target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat('C:/bar/baz') }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/object Host "bar"/) }
  end


  context "Windows 2012 R2 with target => bar/baz (not valid absolute path)" do
    let(:params) { {:target => 'bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /"bar\/baz" is not an absolute path/) }
  end


  context "Windows 2012 R2 with order => 4247 (not valid string)" do
    let(:params) { {:target => 'C:/bar/baz', :order => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with import => [foo, bar]" do
    let(:params) { {:import => ['foo','bar'], :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/import "foo"\r\n\s*import "bar"/) }
  end


  context "Windows 2012 R2 with import => foo (not a valid array)" do
    let(:params) { {:import => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, / "foo" is not an Array/) }
  end


  context "Windows 2012 R2 with display_name => foo" do
    let(:params) { {:display_name => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/display_name = "foo"/) }
  end


  context "Windows 2012 R2 with display_name => 4247 (not a valid string)" do
    let(:params) { {:display_name => 4247, :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with address => 127.0.0.2" do
    let(:params) { {:address => '127.0.0.2', :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/address = "127.0.0.2"/) }
  end


  context "Windows 2012 R2 with address => foo (not a valid IP address)" do
    let(:params) { {:address => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a valid IP address/) }
  end


  context "Windows 2012 R2 with address6 => ::2" do
    let(:params) { {:address6 => '::2', :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/address6 = "::2"/) }
  end


  context "Windows 2012 R2 with address6 => foo (not a valid IP address)" do
    let(:params) { {:address6 => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a valid IP address/) }
  end


  context "Windows 2012 R2 with groups => [foo, bar]" do
    let(:params) { {:groups => ['foo','bar'], :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/groups = \[ "foo", "bar", \]/) }
  end


  context "Windows 2012 R2 with groups => foo (not a valid array)" do
    let(:params) { {:groups => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, / "foo" is not an Array/) }
  end


  context "Windows 2012 R2 with vars => {foo1 => bar1, foo2 => {bar21 => {baz1 => bazz1, baz2 => bazz2}}}" do
    let(:params) { {:vars => {'foo1' => 'bar1', 'foo2' => {'bar21' => {'baz1' => 'bazz1', 'baz2' => 'bazz2'}}}, :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/vars\.foo1 = "bar1"/)
      .with_content(/vars\.foo2\["bar21"\] = {\r\n\s*baz1 = "bazz1"\r\n\s*baz2 = "bazz2"\r\n\s*}\r\n/) }
  end


  context "Windows 2012 R2 with check_command => foo" do
    let(:params) { {:check_command => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/check_command = "foo"/) }
  end


  context "Windows 2012 R2 with check_command => 4247 (not a valid string)" do
    let(:params) { {:check_command => 4247, :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with max_check_attempts => 3" do
    let(:params) { {:max_check_attempts => '3', :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/max_check_attempts = 3/) }
  end


  context "Windows 2012 R2 with max_check_attempts => foo (not a valid integer)" do
    let(:params) { {:max_check_attempts => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
  end


  context "Windows 2012 R2 with check_period => foo" do
    let(:params) { {:check_period => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/check_period = "foo"/) }
  end


  context "Windows 2012 R2 with check_period => 4247 (not a valid string)" do
    let(:params) { {:check_period => 4247, :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with check_timeout => 1m" do
    let(:params) { {:check_timeout => '1m', :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/check_timeout = 1m/) }
  end


  context "Windows 2012 R2 with check_timeout => foo (not a valid value)" do
    let(:params) { {:check_timeout => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
  end


  context "Windows 2012 R2 with check_interval => 1m" do
    let(:params) { {:check_interval => '1m', :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/check_interval = 1m/) }
  end


  context "Windows 2012 R2 with check_interval => foo (not a valid value)" do
    let(:params) { {:check_interval => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
  end


  context "Windows 2012 R2 with retry_interval => 30s" do
    let(:params) { {:retry_interval => '30s', :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/retry_interval = 30s/) }
  end


  context "Windows 2012 R2 with retry_interval => foo (not a valid value)" do
    let(:params) { {:retry_interval => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
  end


  context "Windows 2012 R2 with template => true" do
    let(:params) { {:template => true, :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Host::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/template Host "bar"/) }
  end


  context "Windows 2012 R2 with template => foo (not a valid boolean)" do
    let(:params) { {:template => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end
end
