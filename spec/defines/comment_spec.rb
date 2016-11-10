require 'spec_helper'

describe('icinga2::object::comment', :type => :define) do
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

      it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/object Comment "bar"/) }

      it { is_expected.to contain_icinga2__object('icinga2::object::Comment::bar')
                              .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with host_name => foo" do
      let(:params) { {:host_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/host_name = "foo"/) }
    end


    context "#{os} with host_name => 4247 (not a valid string)" do
      let(:params) { {:host_name => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with service_name => foo" do
      let(:params) { {:service_name => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/service_name = "foo"/) }
    end


    context "#{os} with service_name => 4247 (not a valid string)" do
      let(:params) { {:service_name => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with author => foo" do
      let(:params) { {:author => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/author = "foo"/) }
    end


    context "#{os} with author => 4247 (not a valid string)" do
      let(:params) { {:author => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with text => foo" do
      let(:params) { {:text => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/text = "foo"/) }
    end


    context "#{os} with text => 4247 (not a valid string)" do
      let(:params) { {:text => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with entry_time => 30" do
      let(:params) { {:entry_time => '30', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/entry_time = 30/) }
    end


    context "#{os} with entry_time => foo (not a valid integer)" do
      let(:params) { {:entry_time => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
    end


    context "#{os} with entry_type => 30" do
      let(:params) { {:entry_type => '30', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/entry_type = 30/) }
    end


    context "#{os} with entry_type => foo (not a valid integer)" do
      let(:params) { {:entry_type => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
    end


    context "#{os} with expire_time => 30" do
      let(:params) { {:expire_time => '30', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                              .with({'target' => '/bar/baz'})
                              .with_content(/expire_time = 30/) }
    end


    context "#{os} with expire_time => foo (not a valid integer)" do
      let(:params) { {:expire_time => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
    end
  end
end


describe('icinga2::object::comment', :type => :define) do
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
    let(:params) { {:target =>  '/bar/baz'} }

    it { is_expected.to contain_concat('/bar/baz') }

    it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                            .with({'target' => '/bar/baz'})
                            .with_content(/object Comment "bar"/) }

    it { is_expected.to contain_icinga2__object('icinga2::object::Comment::bar')
                            .that_notifies('Class[icinga2::service]') }
  end


  context "Windows 2012 R2 with host_name => foo" do
    let(:params) { {:host_name => 'foo', :target => '/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                            .with({'target' => '/bar/baz'})
                            .with_content(/host_name = "foo"/) }
  end


  context "Windows 2012 R2 with host_name => 4247 (not a valid string)" do
    let(:params) { {:host_name => 4247, :target => '/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with service_name => foo" do
    let(:params) { {:service_name => 'foo', :target => '/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                            .with({'target' => '/bar/baz'})
                            .with_content(/service_name = "foo"/) }
  end


  context "Windows 2012 R2 with service_name => 4247 (not a valid string)" do
    let(:params) { {:service_name => 4247, :target => '/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with author => foo" do
    let(:params) { {:author => 'foo', :target => '/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                            .with({'target' => '/bar/baz'})
                            .with_content(/author = "foo"/) }
  end


  context "Windows 2012 R2 with author => 4247 (not a valid string)" do
    let(:params) { {:author => 4247, :target => '/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with text => foo" do
    let(:params) { {:text => 'foo', :target => '/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                            .with({'target' => '/bar/baz'})
                            .with_content(/text = "foo"/) }
  end


  context "Windows 2012 R2 with text => 4247 (not a valid string)" do
    let(:params) { {:text => 4247, :target => '/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with entry_time => 30" do
    let(:params) { {:entry_time => '30', :target => '/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                            .with({'target' => '/bar/baz'})
                            .with_content(/entry_time = 30/) }
  end


  context "Windows 2012 R2 with entry_time => foo (not a valid integer)" do
    let(:params) { {:entry_time => 'foo', :target => '/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
  end


  context "Windows 2012 R2 with entry_type => 30" do
    let(:params) { {:entry_type => '30', :target => '/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                            .with({'target' => '/bar/baz'})
                            .with_content(/entry_type = 30/) }
  end


  context "Windows 2012 R2 with entry_type => foo (not a valid integer)" do
    let(:params) { {:entry_type => 'foo', :target => '/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
  end


  context "Windows 2012 R2 with expire_time => 30" do
    let(:params) { {:expire_time => '30', :target => '/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Comment::bar')
                            .with({'target' => '/bar/baz'})
                            .with_content(/expire_time = 30/) }
  end


  context "Windows 2012 R2 with expire_time => foo (not a valid integer)" do
    let(:params) { {:expire_time => 'foo', :target => '/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
  end
end
