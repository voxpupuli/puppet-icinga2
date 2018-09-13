require 'spec_helper'

describe('icinga2::feature::opentsdb', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('opentsdb').with({'ensure' => 'present'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::OpenTsdbWriter::opentsdb')
        .with({ 'target' => '/etc/icinga2/features-available/opentsdb.conf' })
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('opentsdb').with({'ensure' => 'absent'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::OpenTsdbWriter::opentsdb')
        .with({ 'target' => '/etc/icinga2/features-available/opentsdb.conf' }) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('opentsdb').with({'ensure' => 'present'}) }

      it { is_expected.to contain_concat__fragment('icinga2::object::OpenTsdbWriter::opentsdb')
        .with({ 'target' => '/etc/icinga2/features-available/opentsdb.conf' })
        .with_content(/host = "127.0.0.1"/)
        .with_content(/port = 4242/) }
    end


    context "#{os} with host => foo.example.com" do
      let(:params) { {:host => 'foo.example.com'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::OpenTsdbWriter::opentsdb')
        .with({ 'target' => '/etc/icinga2/features-available/opentsdb.conf' })
        .with_content(/host = "foo.example.com"/) }
    end


    context "#{os} with port => 4247" do
      let(:params) { {:port => 4247} }

      it { is_expected.to contain_concat__fragment('icinga2::object::OpenTsdbWriter::opentsdb')
        .with({ 'target' => '/etc/icinga2/features-available/opentsdb.conf' })
        .with_content(/port = 4247/) }
    end


    context "#{os} with port => foo (not a valid integer)" do
      let(:params) { {:port => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects an Integer value/) }
    end
  end
end