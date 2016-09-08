require 'spec_helper'
require 'plattforms'

describe('icinga2', :type => :class) do

  # reference plattform for Linux
  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }

  context 'with external icinga2::config::file on Linux' do
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

  context 'with external icinga2::config::file on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
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

  context 'with constants => foo (not a valid hash)' do
    let(:params) { {:constants => 'foo'} }
    it do
      expect {
        should contain_class('icinga')
      }.to raise_error(Puppet::Error, /"foo" is not a Hash/)
    end
  end

  context 'with constants => { foo => bar } on Linux' do
    let(:params) { { :constants => {'foo' => 'bar'} } }
    it do
      should contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = "bar"\n/)
    end
  end

  context 'with constants => { foo => bar } on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { { :constants => {'foo' => 'bar'} } }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/constants.conf')
        .with_content(/^const foo = "bar"\r\n/)
    end
  end

  context 'with plugins => [ foo, bar ] on Linux' do
    let(:params) { { :plugins => ['foo', 'bar'] } }
    it do
      should contain_file('/etc/icinga2/icinga2.conf')
        .with_content(/^include <foo>\n/)
        .with_content(/^include <bar>\n/)
    end
  end

  context 'with plugins => [ foo, bar ] on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { { :plugins => ['foo', 'bar'] } }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/icinga2.conf')
        .with_content(/^include <foo>\r\n/)
        .with_content(/^include <bar>\r\n/)
    end
  end

  context 'with confd => false on Linux' do
    let(:params) { { :confd => false } }
    it do
      should contain_file('/etc/icinga2/icinga2.conf')
        .without_content(/^include_recursive "conf.d"\n/)
    end
  end

  context 'with confd => false on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { { :confd => false } }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/icinga2.conf')
        .without_content(/^include_recursive "conf.d"\r\n/)
    end
  end

  context 'with confd => foo on Linux' do
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

  context 'with confd => foo on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
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
