require 'spec_helper'
require 'plattforms'

describe('icinga2', :type => :class) do

  # reference plattform for Linux
  let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }

  context 'with constants => foo (not a valid hash)' do
    let(:params) { {:constants => 'foo'} }
    it do
      expect {
        should contain_class('icinga')
      }.to raise_error(Puppet::Error, /"foo" is not a Hash/)
    end
  end

  context 'with constants => { foo => bars } on Linux' do
    let(:params) { { :constants => {'foo' => 'bar'} } }
    it do
      should contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = "bar"\n/)
    end
  end

  context 'with constants => { foo => bars } on Windows' do
    let(:facts) { IcingaPuppet.plattforms['Windows 2012 R2'] }
    let(:params) { { :constants => {'foo' => 'bar'} } }
    it do
      should contain_file('C:/ProgramData/icinga2/etc/icinga2/constants.conf')
        .with_content(/^const foo = "bar"\r\n/)
    end
  end

end
