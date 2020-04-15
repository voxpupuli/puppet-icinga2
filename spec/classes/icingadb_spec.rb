require 'spec_helper'

describe('icinga2::feature::icingadb', :type => :class) do
  let(:pre_condition) do
    [
      "class { 'icinga2': features => [], }"
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

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

      context "with defaults" do
        it { is_expected.to contain_icinga2__feature('icingadb').with({'ensure' => 'present'}) }

        it { is_expected.to contain_icinga2__object('icinga2::object::IcingaDB::icingadb')
          .with({ 'target' => "#{@icinga2_conf_dir}/features-available/icingadb.conf" })
          .that_notifies('Class[icinga2::service]') }
      end

      context "with ensure => absent" do
        let(:params) do
          {
            :ensure => 'absent'
          }
        end

        it { is_expected.to contain_icinga2__feature('icingadb').with({'ensure' => 'absent'}) }
      end
    end

  end
end
