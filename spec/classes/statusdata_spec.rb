require 'spec_helper'

describe('icinga2::feature::statusdata', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('statusdata').with({'ensure' => 'present'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::StatusDataWriter::statusdata')
        .with({ 'target' => '/etc/icinga2/features-available/statusdata.conf' })
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('statusdata').with({'ensure' => 'absent'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::StatusDataWriter::statusdata')
        .with({ 'target' => '/etc/icinga2/features-available/statusdata.conf' }) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('statusdata').with({'ensure' => 'present'}) }

      it { is_expected.to contain_concat__fragment('icinga2::object::StatusDataWriter::statusdata')
        .with({ 'target' => '/etc/icinga2/features-available/statusdata.conf' })
        .with_content(/update_interval = 15s/)
        .with_content(/status_path = "\/var\/cache\/icinga2\/status.dat"/)
        .with_content(/objects_path = "\/var\/cache\/icinga2\/objects.cache"/) }
    end


    context "#{os} with update_interval => 1m" do
      let(:params) { {:update_interval => '1m'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::StatusDataWriter::statusdata')
        .with({ 'target' => '/etc/icinga2/features-available/statusdata.conf' })
        .with_content(/update_interval = 1m/) }
    end


    context "#{os} with update_interval => foo (not a valid value)" do
      let(:params) { {:update_interval => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with status_path => /foo/bar" do
      let(:params) { {:status_path => '/foo/bar'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::StatusDataWriter::statusdata')
        .with({ 'target' => '/etc/icinga2/features-available/statusdata.conf' })
        .with_content(/status_path = "\/foo\/bar"/) }
    end


    context "#{os} with status_path => foo/bar (not an absolute path)" do
      let(:params) { {:status_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with objects_path => /foo/bar" do
      let(:params) { {:objects_path => '/foo/bar'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::StatusDataWriter::statusdata')
        .with({ 'target' => '/etc/icinga2/features-available/statusdata.conf' })
        .with_content(/objects_path = "\/foo\/bar"/) }
    end


    context "#{os} with objects_path => foo/bar (not an absolute path)" do
      let(:params) { {:objects_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end
  end
end