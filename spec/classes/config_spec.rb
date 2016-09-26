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
      it { is_expected.to contain_file('/etc/icinga2/foo')
        .that_notifies('Class[icinga2::service]') }
        #.that_requires('Class[icinga2::config]')
    end

    context "#{os} with constants => foo (not a valid hash)" do
      let(:params) { {:constants => 'foo'} }
      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
    end

    context "#{os} with constants => { foo => bar }" do
      let(:params) { { :constants => {'foo' => 'bar'} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = "bar"\n/) }
    end

    context "#{os} with plugins => [ foo, bar ]" do
      let(:params) { { :plugins => ['foo', 'bar'] } }

      it { is_expected.to contain_file('/etc/icinga2/icinga2.conf')
        .with_content(/^include <foo>\n/)
        .with_content(/^include <bar>\n/) }
    end

    context "#{os} with confd => false" do
      let(:params) { { :confd => false } }

      it { is_expected.to contain_file('/etc/icinga2/icinga2.conf')
        .without_content(/^include_recursive "conf.d"\n/) }
    end


    context "#{os} with confd => foo" do
      let(:params) { { :confd => 'foo' } }
      let(:pre_condition) {
        'file { "/etc/icinga2/foo":
          ensure => directory,
          tag    => icinga2::config::file,
        }'
      }
      it { is_expected.to contain_file('/etc/icinga2/icinga2.conf')
        .with_content(/^include_recursive "foo"\n/) }
      it { is_expected.to contain_file('/etc/icinga2/foo')
        .that_requires('Class[icinga2::install]')
        .that_comes_before('Class[icinga2::config]') }
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

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/icinga2.conf') }
#      .that_requires('Class[icinga2::install]')
#      .that_comes_before('Class[icinga2::config]') }
  end

  context 'windows with constants => { foo => bar }' do
    let(:params) { { :constants => {'foo' => 'bar'} } }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/constants.conf')
      .with_content(/^const foo = "bar"\r\n/) }
  end

  context 'windows with plugins => [ foo, bar ]' do
    let(:params) { { :plugins => ['foo', 'bar'] } }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/icinga2.conf')
      .with_content(/^include <foo>\r\n/)
      .with_content(/^include <bar>\r\n/) }
  end

  context 'windows with confd => false' do
    let(:params) { { :confd => false } }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/icinga2.conf')
      .without_content(/^include_recursive "conf.d"\r\n/) }
  end

  context 'windows with confd => foo' do
    let(:params) { { :confd => 'foo' } }
    let(:pre_condition) {
      'file { "C:/ProgramData/icinga2/etc/icinga2/foo":
        ensure => directory,
        tag    => icinga2::config::file,
      }'
    }

    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/icinga2.conf')
      .with_content(/^include_recursive "foo"\r\n/) }
    it { is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/foo') }
#        .that_requires('Class[icinga2::install]')
#        .that_comes_before('Class[icinga2::config]') }
  end
end
