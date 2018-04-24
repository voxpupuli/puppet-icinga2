require 'spec_helper'

describe('icinga2::feature::livestatus', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('livestatus').with({'ensure' => 'present'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::LivestatusListener::livestatus')
        .with({ 'target' => '/etc/icinga2/features-available/livestatus.conf' })
        .that_notifies('Class[icinga2::service]') }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('livestatus').with({'ensure' => 'absent'}) }

      it { is_expected.to contain_icinga2__object('icinga2::object::LivestatusListener::livestatus')
        .with({ 'target' => '/etc/icinga2/features-available/livestatus.conf' }) }
    end


    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('livestatus').with({'ensure' => 'present'}) }

      it { is_expected.to contain_concat__fragment('icinga2::object::LivestatusListener::livestatus')
        .with({ 'target' => '/etc/icinga2/features-available/livestatus.conf' })
        .with_content(/socket_type = "unix"/)
        .with_content(/bind_host = "127.0.0.1"/)
        .with_content(/bind_port = 6558/)
        .with_content(/socket_path = "\/var\/run\/icinga2\/cmd\/livestatus"/)
        .with_content(/compat_log_path = "\/var\/log\/icinga2\/compat"/) }
    end


    context "#{os} with socket_type => tcp" do
      let(:params) { {:socket_type => 'tcp'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::LivestatusListener::livestatus')
        .with({ 'target' => '/etc/icinga2/features-available/livestatus.conf' })
        .with_content(/socket_type = "tcp"/) }
    end


    context "#{os} with socket_type => foo (not a valid value)" do
      let(:params) { {:socket_type => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects a match for Enum\['tcp', 'unix'\]/) }
    end


    context "#{os} with bind_host => foo.example.com" do
      let(:params) { {:bind_host => 'foo.example.com'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::LivestatusListener::livestatus')
        .with({ 'target' => '/etc/icinga2/features-available/livestatus.conf' })
        .with_content(/bind_host = "foo.example.com"/) }
    end


    context "#{os} with bind_port => 4247" do
      let(:params) { {:bind_port => 4247} }

      it { is_expected.to contain_concat__fragment('icinga2::object::LivestatusListener::livestatus')
        .with({ 'target' => '/etc/icinga2/features-available/livestatus.conf' })
        .with_content(/bind_port = 4247/) }
    end


    context "#{os} with bind_port => foo (not a valid integer)" do
      let(:params) { {:bind_port => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /expects an Integer value/) }
    end


    context "#{os} with socket_path => /foo/bar" do
      let(:params) { {:socket_path => '/foo/bar'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::LivestatusListener::livestatus')
        .with({ 'target' => '/etc/icinga2/features-available/livestatus.conf' })
        .with_content(/socket_path = "\/foo\/bar"/) }
    end


    context "#{os} with socket_path => foo/bar (not an absolute path)" do
      let(:params) { {:socket_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end


    context "#{os} with compat_log_path => /foo/bar" do
      let(:params) { {:compat_log_path => '/foo/bar'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::LivestatusListener::livestatus')
        .with({ 'target' => '/etc/icinga2/features-available/livestatus.conf' })
        .with_content(/compat_log_path = "\/foo\/bar"/) }
    end


    context "#{os} with compat_log_path => foo/bar (not an absolute path)" do
      let(:params) { {:compat_log_path => 'foo/bar'} }

      it { is_expected.to raise_error(Puppet::Error, /Evaluation Error: Error while evaluating a Resource Statement/) }
    end
  end
end