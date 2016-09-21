require 'spec_helper'

describe('icinga2::object::zone', :type => :define) do
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

      it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
        .with({'target' => '/bar/baz'})
        .with_content(/object Zone "bar"/) }
    end


    context "#{os} with target => bar/baz (not valid absolute path)" do
      let(:params) { {:target => 'bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"bar\/baz" is not an absolute path/) }
    end


    context "#{os} with order => 4247 (not valid string)" do
      let(:params) { {:target => '/bar/baz', :order => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with endpoints => [NodeName, Host1]" do
      let(:params) { {:endpoints => ['NodeName','Host1'], :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
        .with_content(/endpoints = \[ NodeName, "Host1", \]/) }
    end


    context "#{os} with endpoints => foo (not a valid array)" do
      let(:params) { {:endpoints => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, / "foo" is not an Array/) }
    end


    context "#{os} with parent => foo" do
      let(:params) { {:parent => 'foo', :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
        .with_content(/parent = "foo"/) }
    end


    context "#{os} with parent => 4247 (not a valid string)" do
      let(:params) { {:parent => 4247, :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with global => true" do
      let(:params) { {:global => true, :target => '/bar/baz'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
        .with_content(/global = true/) }
    end


    context "#{os} with global => foo (not a valid boolean)" do
      let(:params) { {:global => 'foo', :target => '/bar/baz'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end
  end


  context "Windows 2012 R2 with all defaults and target => C:/bar/baz" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat('C:/bar/baz') }

    it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
      .with({'target' => 'C:/bar/baz'})
      .with_content(/object Zone "bar"/) }
  end


  context "Windows 2012 R2 with target => bar/baz (not valid absolute path)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:target => 'bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /"bar\/baz" is not an absolute path/) }
  end


  context "Windows 2012 R2 with order => 4247 (not valid string)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:target => 'C:/bar/baz', :order => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with endpoints => [NodeName, Host1]" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:endpoints => ['NodeName','Host1'], :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
      .with_content(/endpoints = \[ NodeName, "Host1", \]/) }
  end


  context "Windows 2012 R2 with endpoints => foo (not a valid array)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:endpoints => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, / "foo" is not an Array/) }
  end


  context "Windows 2012 R2 with parent => foo" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:parent => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
      .with_content(/parent = "foo"/) }
  end


  context "Windows 2012 R2 with parent => 4247 (not a valid string)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:parent => 4247, :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with global => true" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:global => true, :target => 'C:/bar/baz'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::Zone::bar')
      .with_content(/global = true/) }
  end


  context "ws 2012 R2 with global => foo (not a valid boolean)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:global => 'foo', :target => 'C:/bar/baz'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end
end

