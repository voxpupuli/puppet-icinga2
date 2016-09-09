require 'spec_helper'

describe('icinga2', :type => :class) do

  before(:all) do
    @icinga2_conf = "/etc/icinga2/icinga2.conf"
    @constants_conf = "/etc/icinga2/constants.conf"

    @windows_icinga2_conf = "C:/ProgramData/icinga2/etc/icinga2/icinga2.conf"
    @windows_constants_conf = "C:/ProgramData/icinga2/etc/icinga2/constants.conf"
  end

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with all default parameters" do
      it { should contain_package('icinga2').with({ 'ensure' => 'installed' }) }

      it {  should contain_service('icinga2').with({ 
        'ensure' => 'running', 
        'enable' => true 
        })
      }

      it { is_expected.to contain_file(@constants_conf)
        .with_content %r{^const PluginDir = \"/usr/lib/nagios/plugins\"\n} }

      it { is_expected.to contain_file(@constants_conf)
        .with_content %r{^const PluginContribDir = \"/usr/lib/nagios/plugins\"\n} }

      it { is_expected.to contain_file(@constants_conf)
        .with_content %r{^const ManubulonPluginDir = \"/usr/lib/nagios/plugins\"\n} }

      it { is_expected.to contain_file(@constants_conf)
        .with_content %r{^const NodeName = \".+\"\n} }

      it { is_expected.to contain_file(@constants_conf)
        .with_content %r{^const ZoneName = \".+\"\n} }

      it { is_expected.to contain_file(@constants_conf)
        .with_content %r{^const TicketSalt = \"\"\n} }

      it { is_expected.to contain_file(@icinga2_conf)
        .with_content %r{^// managed by puppet\n} }

      it { is_expected.to contain_file(@icinga2_conf)
        .with_content %r{^include <plugins>\n} }

      it { is_expected.to contain_file(@icinga2_conf)
        .with_content %r{^include <plugins-contrib>\n} }

      it { is_expected.to contain_file(@icinga2_conf)
        .with_content %r{^include_recursive \"conf.d\"\n} }

      case facts[:osfamily]
      when 'Debian'
        it { should_not contain_apt__source('icinga-stable-release') } 
      when 'RedHat'
        it { should_not contain_yumrepo('icinga-stable-release') }
      end
    end
  end

  context 'Windows 2012 R2 with all default parameters' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }

    it { should contain_package('icinga2').with({ 'ensure' => 'installed' }) }

    it {  should contain_service('icinga2').with({ 
      'ensure' => 'running', 
      'enable' => true 
      })
    }



    it { is_expected.to contain_file(@windows_constants_conf)
      .with_content %r{^const PluginDir = \"C:/Program Files/ICINGA2/sbin\"\r\n} }

    it { is_expected.to contain_file(@windows_constants_conf)
      .with_content %r{^const PluginContribDir = \"C:/Program Files/ICINGA2/sbin\"\r\n} }

    it { is_expected.to contain_file(@windows_constants_conf)
      .with_content %r{^const ManubulonPluginDir = \"C:/Program Files/ICINGA2/sbin\"\r\n} }

    it { is_expected.to contain_file(@windows_constants_conf)
      .with_content %r{^const NodeName = \".+\"\r\n} }

    it { is_expected.to contain_file(@windows_constants_conf)
      .with_content %r{^const ZoneName = \".+\"\r\n} }

    it { is_expected.to contain_file(@windows_constants_conf)
      .with_content %r{^const TicketSalt = \"\"\r\n} }

    it { is_expected.to contain_file(@windows_constants_conf)
      .with_content %r{^} }

    it { is_expected.to contain_file(@windows_icinga2_conf)
      .with_content %r{^// managed by puppet\r\n} }

    it { is_expected.to contain_file(@windows_icinga2_conf)
      .with_content %r{^include <windows-plugins>\r\n} }

    it { is_expected.to contain_file(@windows_icinga2_conf)
      .with_content %r{^include <nscp>\r\n} }

    it { is_expected.to contain_file(@windows_icinga2_conf)
      .with_content %r{^include_recursive \"conf.d\"\r\n} }
  end

  context 'on unsupported plattform' do
    let(:facts) { {:osfamily => 'foo'} }
    it do
      expect {
        should contain_class('icinga')
      }.to raise_error(Puppet::Error, /foo is not supported/)
    end
  end

end
