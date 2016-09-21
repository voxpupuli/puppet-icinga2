require 'spec_helper'

describe('icinga2::object', :type => :define) do
  let(:title) { 'bar' }
  let(:pre_condition) { [
    "class { 'icinga2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with all defaults and object_type => foo, target => /bar/baz, order => 10" do
      let(:params) { {:object_type => 'foo', :target => '/bar/baz', :order => '10'} }

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.to contain_concat__fragment('icinga2::object::foo::bar')
        .with({'target' => '/bar/baz', 'order' => '10'})
        .with_content(/object foo "bar"/) }
    end


    context "#{os} with object_type => 4247 (not valid string)" do
      let(:params) { {:object_type => 4247, :target => '/bar/baz', :order => '10'} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with target => bar/baz (not valid absolute path)" do
      let(:params) { {:object_type => 'foo', :target => 'bar/baz', :order => '10'} }

      it { is_expected.to raise_error(Puppet::Error, /"bar\/baz" is not an absolute path/) }
    end


    context "#{os} with order => 4247 (not valid string)" do
      let(:params) { {:object_type => 'foo', :target => '/bar/baz', :order => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with template => true" do
      let(:params) { {:template => true, :object_type => 'foo', :target => '/bar/baz', :order => '10'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::foo::bar')
        .with_content(/template foo "bar"/) }
    end


    context "#{os} with template => false" do
      let(:params) { {:template => false, :object_type => 'foo', :target => '/bar/baz', :order => '10'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::foo::bar')
        .with_content(/object foo "bar"/) }
    end


    context "#{os} with template => foo (not a valid boolean)" do
      let(:params) { {:template => 'foo', :object_type => 'foo', :target => '/bar/baz', :order => '10'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end


    context "#{os} with import => [bar, baz]" do
      let(:params) { {:import => ['bar', 'baz'], :object_type => 'foo', :target => '/bar/baz', :order => '10'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::foo::bar')
        .with_content(/import "bar"/)
        .with_content(/import "baz"/) }
    end


    context "#{os} with import => foo (not a valid array)" do
      let(:params) { {:import => 'foo', :object_type => 'foo', :target => '/bar/baz', :order => '10'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not an Array/) }
    end
  end


  context "Windows 2012 R2 with all defaults and object_type => foo, target => C:/bar/baz, order => 10" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:object_type => 'foo', :target => 'C:/bar/baz', :order => '10'} }

    it { is_expected.to contain_concat('C:/bar/baz') }

    it { is_expected.to contain_concat__fragment('icinga2::object::foo::bar')
      .with({'target' => 'C:/bar/baz', 'order' => '10'})
      .with_content(/object foo "bar"/) }
  end


  context "Windows 2012 R2 with object_type => 4247 (not valid string)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:object_type => 4247, :target => 'C:/bar/baz', :order => '10'} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with target => bar/baz (not valid absolute path)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:object_type => 'foo', :target => 'bar/baz', :order => '10'} }

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
    let(:params) { {:object_type => 'foo', :target => 'C:/bar/baz', :order => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with template => true" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:template => true, :object_type => 'foo', :target => 'C:/bar/baz', :order => '10'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::foo::bar')
      .with_content(/template foo "bar"/) }
  end


  context "Windows 2012 R2 with template => false" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:template => false, :object_type => 'foo', :target => 'C:/bar/baz', :order => '10'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::foo::bar')
      .with_content(/object foo "bar"/) }
  end


  context "Windows 2012 R2 with template => foo (not a valid boolean)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:template => 'foo', :object_type => 'foo', :target => 'C:/bar/baz', :order => '10'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end


  context "Windows 2012 R2 with import => [bar, baz]" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:import => ['bar', 'baz'], :object_type => 'foo', :target => 'C:/bar/baz', :order => '10'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::foo::bar')
      .with_content(/import "bar"/)
      .with_content(/import "baz"/) }
  end


  context "Windows 2012 R2 with import => foo (not a valid array)" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:import => 'foo', :object_type => 'foo', :target => 'C:/bar/baz', :order => '10'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not an Array/) }
  end


  context "Windows 2012 R2 with attrs => { key1 => 4247, key2 => {key3 => 666, key4 => 1m}, key5 => [STRING, NodeName] }" do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:attrs => { 'key1' => '4247', 'key2' => {'key3' => 666, 'key4' => '1m'}, 'key5' => ['STRING', 'NodeName'] }, :object_type => 'foo', :target => 'C:/bar/baz', :order => '10'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::foo::bar')
      .with_content(/key1 = 4247/)
      .with_content(/key2 = \{\n\s*key3 = 666\n\s*key4 = 1m\n\s*\}/)
      .with_content(/key5 = \[ "STRING", NodeName, \]/) }
  end
end
