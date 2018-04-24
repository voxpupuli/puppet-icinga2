require 'spec_helper'

describe('icinga2::feature::gelf', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('gelf').with({'ensure' => 'present'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::GelfWriter::gelf')
        .with({ 'target' => '/etc/icinga2/features-available/gelf.conf' })
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('gelf').with({'ensure' => 'absent'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::GelfWriter::gelf')
        .with({ 'target' => '/etc/icinga2/features-available/gelf.conf' }) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('gelf').with({'ensure' => 'present'}) }

      it { is_expected.to contain_concat__fragment('icinga2::object::GelfWriter::gelf')
        .with({ 'target' => '/etc/icinga2/features-available/gelf.conf' })
        .with_content(/host = "127.0.0.1"/)
        .with_content(/port = 12201/)
        .with_content(/source = "icinga2"/) }
    end


    context "#{os} with host => foo.example.com" do
      let(:params) { {:host => 'foo.example.com'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::GelfWriter::gelf')
        .with({ 'target' => '/etc/icinga2/features-available/gelf.conf' })
        .with_content(/host = "foo.example.com"/) }
    end


    context "#{os} with port => 4247" do
      let(:params) { {:port => 4247} }

      it { is_expected.to contain_concat__fragment('icinga2::object::GelfWriter::gelf')
        .with({ 'target' => '/etc/icinga2/features-available/gelf.conf' })
        .with_content(/port = 4247/) }
    end


    context "#{os} with port => foo (not a valid integer)" do
      let(:params) { {:port => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects an Integer value/) }
    end


    context "#{os} with source => foo" do
      let(:params) { {:source => 'foo'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::GelfWriter::gelf')
        .with({ 'target' => '/etc/icinga2/features-available/gelf.conf' })
        .with_content(/source = "foo"/) }
    end


    context "#{os} with enable_send_perfdata => true" do
      let(:params) { {:enable_send_perfdata => true} }

      it { is_expected.to contain_concat__fragment('icinga2::object::GelfWriter::gelf')
        .with({ 'target' => '/etc/icinga2/features-available/gelf.conf' })
        .with_content(/enable_send_perfdata = true/) }
    end


    context "#{os} with enable_send_perfdata => false" do
      let(:params) { {:enable_send_perfdata => false} }

      it { is_expected.to contain_concat__fragment('icinga2::object::GelfWriter::gelf')
        .with({ 'target' => '/etc/icinga2/features-available/gelf.conf' })
        .with_content(/enable_send_perfdata = false/) }
    end


    context "#{os} with enable_send_perfdata => foo (not a valid boolean)" do
      let(:params) { {:enable_send_perfdata => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a Boolean value/) }
    end
  end
end