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
      it { is_expected.to raise_error(Puppet::Error, /expects a Hash value/) }
    end


    context "#{os} with constants => { foo => bar in foobar }" do
      let(:params) { { :constants => {'foo' => 'bar in foobar'} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = "bar in foobar"\n/) }
    end


    context "#{os} with constants => { foo => bar, in foobar }" do
      let(:params) { { :constants => {'foo' => 'bar, in foobar'} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = "bar, in foobar"\n/) }
    end


    context "#{os} with constants => { foo => 4247}" do
      let(:params) { { :constants => {'foo' => '4247'} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = 4247\n/) }
    end


    context "#{os} with constants => { foo => bar(4247)}" do
      let(:params) { { :constants => {'foo' => 'bar(4247)'} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = bar\(4247\)\n/) }
    end


    context "#{os} with constants => { foo => 4247 - bar(NodeName + baz, 1m) * (foo + 2) }" do
      let(:params) { { :constants => {'foo' => '4247 - bar(NodeName + baz, 1m) * (foo + 2)'} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = 4247 - bar\(NodeName \+ "baz", 1m\) \* \(foo \+ 2\)\n/) }
    end


    context "#{os} with constants => { foo => true, bar => false }" do
      let(:params) { { :constants => {'foo' => true, 'bar' => false } } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = true\n/)
        .with_content(/^const bar = false\n/) }
    end


    context "#{os} with constants => { fooS => 30s, fooM => 1m, fooH => 3h, fooD => 2d }" do
      let(:params) { { :constants => {'fooS' => '30s', 'fooM' => '1m', 'fooH' => '3h', 'fooD' => '2d'} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const fooS = 30s\n/)
        .with_content(/^const fooM = 1m\n/)
        .with_content(/^const fooH = 3h\n/)
        .with_content(/^const fooD = 2d\n/) }
    end


    context "#{os} with constants => { foo => NodeName }" do
      let(:params) { { :constants => {'foo' => 'NodeName'} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = NodeName\n/) }
    end


    context "#{os} with constants => { foo => [ 4247, NodeName, bar in foobar ] }" do
      let(:params) { { :constants => {'foo' => ['4247', 'NodeName', 'bar in foobar']} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = \[ 4247, NodeName, "bar in foobar", \]\n/) }
    end


    context "#{os} with constants => { foo => NodeName + bar(4247, NodeName, bar in foobar) - 1}" do
      let(:params) { { :constants => {'foo' => 'NodeName + bar(4247, NodeName, bar in foobar) - 1'} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = NodeName \+ bar\(4247, NodeName, "bar in foobar"\) - 1\n/) }
    end


    context "#{os} with constants => { foo => { -key1 => 4247, key2 => NodeName, key3 => 1m, key4 => bar in foobar } }" do
      let(:params) { { :constants => {'foo' => { '-key1' => '4247', 'key2' => 'NodeName', 'key3' => '1m', 'key4' => 'bar in foobar'}} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = \{\n\s+"-key1" = 4247\n\s+key2 = NodeName\n\s+key3 = 1m\n\s+key4 = "bar in foobar"\n\}\n/) }
    end


    context "#{os} with constants => { foo => { bar => {-key1 => 4247, baz => {key2 => NodeName, key3 => [1m, 3h, 2d]}, key4 => foobar} } }" do
      let(:params) { { :constants => {'foo' => { 'bar' => {'-key1' => '4247', 'baz' => {'key2' => 'NodeName', 'key3' => ['1m','3h','2d']}, 'key4' => 'foobar'}}} } }

      it { is_expected.to contain_file('/etc/icinga2/constants.conf')
        .with_content(/^const foo = \{\n\s+bar = \{\n\s+"-key1" = 4247\n\s+baz = \{\n\s+key2 = NodeName\n\s+key3 = \[ 1m, 3h, 2d, \]\n\s+\}\n\s+key4 = "foobar"\n\s+\}\n\}\n/) }
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