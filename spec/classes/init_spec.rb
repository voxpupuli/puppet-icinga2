require 'spec_helper'

describe('icinga2', :type => :class) do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      case facts[:kernel]
      when 'Linux'
        before(:all) do
          @icinga2_conf = '/etc/icinga2/icinga2.conf'
          @constants_conf = '/etc/icinga2/constants.conf'
        end
      when 'FreeBSD'
        before(:all) do
          @icinga2_conf = '/usr/local/etc/icinga2/icinga2.conf'
          @constants_conf = '/usr/local/etc/icinga2/constants.conf'
        end
      when 'windows'
        before(:all) do
          @icinga2_conf = 'C:/ProgramData/icinga2/etc/icinga2/icinga2.conf'
          @constants_conf = 'C:/ProgramData/icinga2/etc/icinga2/constants.conf'
        end
      end

      context 'with all default parameters' do
        it { is_expected.to contain_package('icinga2').with({ 'ensure' => 'installed' }) }

        it { is_expected.to contain_service('icinga2').with({
          'ensure' => 'running',
          'enable' => true
          })
        }

        case facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_file(@constants_conf)
            .with_content %r{^const PluginDir = \"/usr/lib/nagios/plugins\"} }

          it { is_expected.to contain_file(@constants_conf)
            .with_content %r{^const PluginContribDir = \"/usr/lib/nagios/plugins\"} }

          it { is_expected.to contain_file(@constants_conf)
            .with_content %r{^const ManubulonPluginDir = \"/usr/lib/nagios/plugins\"} }
        when 'RedHat'
          it { is_expected.to contain_file(@constants_conf)
            .with_content %r{^const PluginDir = \"/usr/lib64/nagios/plugins\"} }

          it { is_expected.to contain_file(@constants_conf)
            .with_content %r{^const PluginContribDir = \"/usr/lib64/nagios/plugins\"} }

          it { is_expected.to contain_file(@constants_conf)
            .with_content %r{^const ManubulonPluginDir = \"/usr/lib64/nagios/plugins\"} }
        when 'Suse'
          it { is_expected.to contain_file(@constants_conf)
            .with_content %r{^const PluginDir = \"/usr/lib/nagios/plugins\"} }
          it { is_expected.to contain_file(@constants_conf)
            .with_content %r{^const PluginContribDir = \"/usr/lib/nagios/plugins\"} }
          it { is_expected.to contain_file(@constants_conf)
            .with_content %r{^const ManubulonPluginDir = \"/usr/lib/nagios/plugins\"} }
        end

        it { is_expected.to contain_file(@constants_conf)
          .with_content %r{^const NodeName = \".+\"} }

        it { is_expected.to contain_file(@constants_conf)
          .with_content %r{^const ZoneName = \".+\"} }

        it { is_expected.to contain_file(@constants_conf)
          .with_content %r{^const TicketSalt = \"\"} }

        it { is_expected.to contain_file(@icinga2_conf)
          .with_content %r{^// managed by puppet} }

        it { is_expected.to contain_file(@icinga2_conf)
          .with_content %r{^include <plugins>} }

        it { is_expected.to contain_file(@icinga2_conf)
          .with_content %r{^include <plugins-contrib>} }

        it { is_expected.to contain_file(@icinga2_conf)
          .with_content %r{^include <windows-plugins>} }

        it { is_expected.to contain_file(@icinga2_conf)
          .with_content %r{^include <nscp>} }

        it { is_expected.to contain_file(@icinga2_conf)
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

        context "#{os} with manage_package => false" do
          let(:params) { {:manage_package => false} }

          it { should_not contain_package('icinga2').with({ 'ensure' => 'installed' }) }
        end
      end
    end
  end
end

describe('icinga2', :type => :class) do
  let(:facts) { {
      :kernel => 'foo',
      :osfamily => 'bar',
  } }

  context 'on unsupported plattform' do
    it { is_expected.to raise_error(Puppet::Error, /bar is not supported/) }
  end
end
