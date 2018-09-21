require 'spec_helper'

describe('icinga2::feature::idopgsql', :type => :class) do
  let(:pre_condition) { [
      "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts { facts }

      before(:each) do
        case facts[:kernel]
        when 'windows'
          @icinga2_conf_dir = 'C:/ProgramData/icinga2/etc/icinga2'
          @icinga2_pki_dir = 'C:/ProgramData/icinga2/var/lib/icinga2/certs'
          @ido_mysql_schema_dir = 'C:/Program Files/icinga2/usr/share/icinga2-ido-mysql/schema'
          @icinga2_sslkey_mode = nil
          @icinga2_user = nil
          @icinga2_group = nil
        when 'FreeBSD'
          @icinga2_conf_dir = '/usr/local/etc/icinga2'
          @icinga2_pki_dir = '/var/lib/icinga2/certs'
          @ido_mysql_schema_dir = '/usr/local/share/icinga2-ido-mysql/schema'
          @icinga2_sslkey_mode = '0600'
          @icinga2_user = 'icinga'
          @icinga2_group = 'icinga'
        else
          @icinga2_conf_dir = '/etc/icinga2'
          @icinga2_pki_dir = '/var/lib/icinga2/certs'
          @ido_mysql_schema_dir = '/usr/share/icinga2-ido-mysql/schema'
          @icinga2_sslkey_mode = '0600'
          case facts[:osfamily]
          when 'Debian'
            @icinga2_user = 'nagios'
            @icinga2_group = 'nagios'
          else
            @icinga2_user = 'icinga'
            @icinga2_group = 'icinga'
          end
        end
      end

      context "with defaults" do
        let(:params) { {:password => 'foo'} }

        if facts[:kernel] == 'Linux'
          it { is_expected.to contain_package('icinga2-ido-pgsql').with({ 'ensure' => 'installed' }) }
        end

        it { is_expected.to contain_icinga2__feature('ido-pgsql').with({'ensure' => 'present'}) }

        it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
          .with({ 'target' => "#{@icinga2_conf_dir}/features-available/ido-pgsql.conf" }) }
      end

      context "with ensure => absent" do
        let(:params) { {:ensure => 'absent', :password => 'foo'} }

        it { is_expected.to contain_icinga2__feature('ido-pgsql').with({'ensure' => 'absent'}) }
      end

      context "with import_schema => true" do
        let(:params) { {:import_schema => true, :password => 'foo'} }

        it { is_expected.to contain_exec('idopgsql-import-schema') }
      end

      if facts[:kernel] == 'Linux'
        context "with icinga2::manage_package => false" do
          let(:params) { {:password => 'foo'} }
          let(:pre_condition) {[
            "class { 'icinga2': features => [], manage_package => false }" ]}

          it { should_not contain_package('icinga2').with({ 'ensure' => 'installed' }) }
          it { should_not contain_package('icinga2-ido-pgsql').with({ 'ensure' => 'installed' }) }
        end
      end
    end

  end
end
