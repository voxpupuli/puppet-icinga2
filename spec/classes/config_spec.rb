require 'spec_helper'

describe('icinga2', :type => :class) do
  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with external icinga2::config::file" do
      let(:pre_condition) {
        'file { "/etc/icinga2/foo":
          ensure => file,
          tag    => icinga2::config::file,
        }'
      }
      it do
        should contain_file('/etc/icinga2/foo')
          .that_requires('Class[icinga2::config]')
          .that_notifies('Class[icinga2::service]')
      end
    end
  
    context "#{os} with constants => foo (not a valid hash)" do
      let(:params) { {:constants => 'foo'} }
      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
    end
  
    context "#{os} with constants => { foo => bar }" do
      let(:params) { { :constants => {'foo' => 'bar'} } }
      it do
        should contain_file('/etc/icinga2/constants.conf')
          .with_content(/^const foo = "bar"\n/)
      end
    end
  
    context "#{os} with plugins => [ foo, bar ]" do
      let(:params) { { :plugins => ['foo', 'bar'] } }
      it do
        should contain_file('/etc/icinga2/icinga2.conf')
          .with_content(/^include <foo>\n/)
          .with_content(/^include <bar>\n/)
      end
    end
  
    context "#{os} with confd => false" do
      let(:params) { { :confd => false } }
      it do
        should contain_file('/etc/icinga2/icinga2.conf')
          .without_content(/^include_recursive "conf.d"\n/)
      end
    end
  
  
    context "#{os} with confd => foo" do
      let(:params) { { :confd => 'foo' } }
      let(:pre_condition) {
        'file { "/etc/icinga2/foo":
          ensure => directory,
          tag    => icinga2::config::file,
        }'
      }
      it do
        should contain_file('/etc/icinga2/icinga2.conf')
          .with_content(/^include_recursive "foo"\n/)
        should contain_file('/etc/icinga2/foo')
          .that_requires('Class[icinga2::install]')
          .that_comes_before('Class[icinga2::config]')
      end
    end
  end
end

describe('icinga2', :type => :class) do
  let(:facts) { {
    :kernel => 'Windows',
    :architecture => 'x86_64',
    :osfamily => 'Windows',
    :operatingsystem => 'Windows',
    :operatingsystemmajrelease => '2012 R2'
  } }

  context 'windows with external icinga2::config::file' do
    let(:pre_condition) {
      'file { "C:/ProgramData/icinga2/etc/icinga2/foo":
        ensure => file,
        tag    => icinga2::config::file,
      }'
    }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/foo')
#        .that_requires('Class[icinga2::install]')
#        .that_comes_before('Class[icinga2::config]')
    end
  end

  context 'windows with constants => { foo => bar }' do
    let(:params) { { :constants => {'foo' => 'bar'} } }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/constants.conf')
        .with_content(/^const foo = "bar"\r\n/)
    end
  end

  context 'windows with plugins => [ foo, bar ]' do
    let(:params) { { :plugins => ['foo', 'bar'] } }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/icinga2.conf')
        .with_content(/^include <foo>\r\n/)
        .with_content(/^include <bar>\r\n/)
    end
  end

  context 'windows with confd => false' do
    let(:params) { { :confd => false } }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/icinga2.conf')
        .without_content(/^include_recursive "conf.d"\r\n/)
    end
  end

  context 'windows with confd => foo' do
    let(:params) { { :confd => 'foo' } }
    let(:pre_condition) {
      'file { "C:/ProgramData/icinga2/etc/icinga2/foo":
        ensure => directory,
        tag    => icinga2::config::file,
      }'
    }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/icinga2.conf')
        .with_content(/^include_recursive "foo"\r\n/)
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/foo')
#        .that_requires('Class[icinga2::install]')
#        .that_comes_before('Class[icinga2::config]')
    end
  end
end
