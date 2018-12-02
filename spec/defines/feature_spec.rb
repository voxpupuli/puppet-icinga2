require 'spec_helper'

describe('icinga2::feature', :type => :define) do
  let(:title) { 'bar' }

  before(:each) do
    # Fake assert_private function from stdlib to not fail within this test
    Puppet::Parser::Functions.newfunction(:assert_private, :type => :rvalue) { |args| }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      case facts[:kernel]
        when 'Linux'
          case facts[:osfamily]
            when 'Debian'
              before(:all) do
                @icinga2_config_dir = '/etc/icinga2'
                @icinga2_user = 'nagios'
                @icinga2_group = 'nagios'
              end
            else
              before(:all) do
                @icinga2_config_dir = '/etc/icinga2'
                @icinga2_user = 'icinga'
                @icinga2_group = 'icinga'
              end
          end
        when 'FreeBSD'
          before(:all) do
            @icinga2_config_dir = '/usr/local/etc/icinga2'
            @icinga2_user = 'icinga'
            @icinga2_group = 'icinga'
          end
        when 'windows'
          before(:all) do
            @icinga2_config_dir = 'C:/ProgramData/icinga2/etc/icinga2'
          end
      end

      let(:pre_condition) do
        [
          "class { 'icinga2': features => [] }",
          "icinga2::object { 'icinga2::object::FooComponent::foo':
            object_name => 'foo',
            object_type => 'FooComponent',
            target      => '#{@icinga2_config_dir}/features-available/foo.conf',
            order       => 10,
          }"
        ]
      end

      case facts[:kernel]
        when 'windows'
          context "with ensure => present" do
            let(:params) { {:ensure => 'present', :feature => 'foo'} }

            it { is_expected.to contain_file("#{@icinga2_config_dir}/features-enabled/foo.conf")
              .with({ 'ensure' => 'file' })
              .that_notifies('Class[icinga2::service]') }

            it { should compile }
          end
        else
          context "with ensure => present" do
            let(:params) { {:ensure => 'present', :feature => 'foo'} }

            it { is_expected.to contain_file("#{@icinga2_config_dir}/features-enabled/foo.conf")
              .with({
                'ensure' => 'link',
                'owner'  => @icinga2_user,
                'group'  => @icinga2_group,
              }).that_notifies('Class[icinga2::service]') }

            it { should compile }
          end
      end

      context "with ensure => absent" do
        let(:params) { {:ensure => 'absent', :feature => 'foo'} }

        it { is_expected.to contain_file("#{@icinga2_config_dir}/features-enabled/foo.conf")
          .with({ 'ensure' => 'absent'})
          .that_notifies('Class[icinga2::service]') }

        it { should compile }
      end
    end
  end
end
