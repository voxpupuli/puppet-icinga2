require 'spec_helper'

describe('icinga2::feature::command', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('command').with({'ensure' => 'present'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::ExternalCommandListener::command')
        .with({ 'target' => '/etc/icinga2/features-available/command.conf' })
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('command').with({'ensure' => 'absent'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::ExternalCommandListener::command')
        .with({ 'target' => '/etc/icinga2/features-available/command.conf' }) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('command').with({'ensure' => 'present'}) }

      it { is_expected.to contain_concat__fragment('icinga2::object::ExternalCommandListener::command')
        .with({ 'target' => '/etc/icinga2/features-available/command.conf' })
        .with_content(/command_path = "\/var\/run\/icinga2\/cmd\/icinga2.cmd"/) }
    end


    context "#{os} with command_path => /foo/bar" do
      let(:params) { {:command_path => '/foo/bar'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::ExternalCommandListener::command')
        .with({ 'target' => '/etc/icinga2/features-available/command.conf' })
        .with_content(/command_path = "\/foo\/bar"/) }
    end


    context "#{os} with command_path => foo/bar (not an absolute path)" do
      let(:params) { {:command_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end
  end
end