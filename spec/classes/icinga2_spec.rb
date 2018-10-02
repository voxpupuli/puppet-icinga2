require 'spec_helper'

describe('icinga2', :type => :class) do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts { facts }

      before(:each) do
        case facts[:kernel]
        when 'windows'
          @icinga2_conf_dir = 'C:/ProgramData/icinga2/etc/icinga2'
        when 'FreeBSD'
          @icinga2_conf_dir = '/usr/local/etc/icinga2'
        else
          @icinga2_conf_dir = '/etc/icinga2'
        end
      end

      context 'with defaults' do
        it { is_expected.to contain_package('icinga2')
          .with({ 'ensure' => 'installed' }) }

        it { is_expected.to contain_service('icinga2')
          .with({
            'ensure' => 'running',
            'enable' => true }) }

        it { is_expected.to contain_file("#{@icinga2_conf_dir}/features-enabled")
          .with({
            'ensure'  => 'directory',
            'purge'   => true,
            'recurse' => true, }) }

        case facts[:osfamily]
        when 'windows'
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const PluginDir = \"C:/Program Files/ICINGA2/sbin\"} }
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const PluginContribDir = \"C:/Program Files/ICINGA2/sbin\"} }
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const ManubulonPluginDir = \"C:/Program Files/ICINGA2/sbin\"} }
        when 'FreeBSD'
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const PluginDir = \"/usr/local/libexec/nagios\"} }
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const PluginContribDir = \"\/usr/local/share/icinga2/include/plugins-contrib.d\"} }
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const ManubulonPluginDir = \"/usr/local/libexec/nagios\"} }
        when 'RedHat'
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const PluginDir = \"/usr/lib64/nagios/plugins\"} }
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const PluginContribDir = \"/usr/lib64/nagios/plugins\"} }
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const ManubulonPluginDir = \"/usr/lib64/nagios/plugins\"} }
        else
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const PluginDir = \"/usr/lib/nagios/plugins\"} }
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const PluginContribDir = \"/usr/lib/nagios/plugins\"} }
          it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
            .with_content %r{^const ManubulonPluginDir = \"/usr/lib/nagios/plugins\"} }
        end

        it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
          .with_content %r{^const NodeName = \".+\"} }
        it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
          .with_content %r{^const ZoneName = \".+\"} }
        it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
          .with_content %r{^const TicketSalt = \"\"} }

        it { is_expected.to contain_file("#{@icinga2_conf_dir}/icinga2.conf")
          .with_content %r{^include <plugins>} }
        it { is_expected.to contain_file("#{@icinga2_conf_dir}/icinga2.conf")
          .with_content %r{^include <plugins-contrib>} }
        it { is_expected.to contain_file("#{@icinga2_conf_dir}/icinga2.conf")
          .with_content %r{^include <windows-plugins>} }
        it { is_expected.to contain_file("#{@icinga2_conf_dir}/icinga2.conf")
          .with_content %r{^include <nscp>} }
        it { is_expected.to contain_file("#{@icinga2_conf_dir}/icinga2.conf")
          .with_content %r{^include_recursive \"conf.d\"} }

        it { is_expected.to contain_icinga2__feature('checker')
          .with({'ensure' => 'present'}) }
        it { is_expected.to contain_icinga2__feature('mainlog')
          .with({'ensure' => 'present'}) }
        it { is_expected.to contain_icinga2__feature('notification')
          .with({'ensure' => 'present'}) }

        case facts[:osfamily]
        when 'Debian'
          it { should_not contain_apt__source('icinga-stable-release') }
        when 'RedHat'
          it { should_not contain_yumrepo('icinga-stable-release') }
        when 'Suse'
          it { should_not contain_zypprepo('icinga-stable-release') }
        end
      end

      context "with manage_package => false" do
        let(:params) { {:manage_package => false} }

        it { should_not contain_package('icinga2').with({ 'ensure' => 'installed' }) }
      end

      context "with confd => false" do
        let(:params) { {:confd => false} }

        it { is_expected.to contain_file("#{@icinga2_conf_dir}/icinga2.conf")
          .without_content %r{^include_recursive \"conf.d\"} }
      end

      context "with confd => example.d" do
        let(:params) { {:confd => "#{@icinga2_conf_dir}/example.d"} }

        case facts[:kernel]
        when 'windows'
          let(:pre_condition) {[
            "file { 'C:/ProgramData/icinga2/etc/icinga2/example.d': ensure => directory, tag => 'icinga2::config::file' }",
            "file { 'C:/ProgramData/icinga2/etc/icinga2/example.d/foo': ensure => file, tag => 'icinga2::config::file' }",
          ]}

          it { is_expected.to contain_file("#{@icinga2_conf_dir}/icinga2.conf")
            .with_content %r{^include_recursive \"C:/ProgramData/icinga2/etc/icinga2/example.d\"} }
        when 'FreeBSD'
          let(:pre_condition) {[
            "file { '/usr/local/etc/icinga2/example.d': ensure => directory, tag => 'icinga2::config::file' }",
            "file { '/usr/local/etc/icinga2/example.d/foo': ensure => file, tag => 'icinga2::config::file' }",
          ]}

          it { is_expected.to contain_file("#{@icinga2_conf_dir}/icinga2.conf")
            .with_content %r{^include_recursive \"/usr/local/etc/icinga2/example.d\"} }
        else
          let(:pre_condition) {[
            "file { '/etc/icinga2/example.d': ensure => directory, tag => 'icinga2::config::file' }",
            "file { '/etc/icinga2/example.d/foo': ensure => file, tag => 'icinga2::config::file' }",
          ]}

          it { is_expected.to contain_file("#{@icinga2_conf_dir}/icinga2.conf")
            .with_content %r{^include_recursive \"/etc/icinga2/example.d\"} }
        end

        it { is_expected.to contain_file("#{@icinga2_conf_dir}/example.d")
          .with({
            'ensure' => 'directory',
            'tag'    => 'icinga2::config::file', }) }

        it { is_expected.to contain_file("#{@icinga2_conf_dir}/example.d/foo")
          .with({
            'ensure' => 'file',
            'tag'    => 'icinga2::config::file', })
          .that_notifies('Class[icinga2::service]') }
      end

      context "with constants => { foo => bar }" do
        let(:params) { {:constants => {'foo' => 'bar'}} }

        it { is_expected.to contain_file("#{@icinga2_conf_dir}/constants.conf")
          .with_content(/^const foo = \"bar\"/) }
      end

      context "with plugins => [ foo, bar ]" do
        let(:params) { {:plugins => ['foo', 'bar']} }

        it { is_expected.to contain_file("#{@icinga2_conf_dir}/icinga2.conf")
          .with_content(/^include <foo>/)
          .with_content(/^include <bar>/) }
      end

      context "with ensure => stopped, enable => false" do
        let(:params) { {:ensure => 'stopped', :enable => false} }

        it { is_expected.to contain_service('icinga2')
          .with({
            'ensure' => 'stopped',
            'enable' => false, }) }
      end

      context 'with manage_repo => true' do
        let(:params) { {:manage_repo => true} }
        case facts[:osfamily]
          when 'Debian'
            it { should contain_apt__source('icinga-stable-release') }
          when 'RedHat'
            it { should contain_yumrepo('icinga-stable-release') }
          when 'Suse'
            it { should contain_zypprepo('icinga-stable-release') }
        end
      end

      context "with manage_service => false" do
        let(:params) { {:manage_service => false} }

        it { should_not contain_service('icinga2') }
      end
    end

  end
end
