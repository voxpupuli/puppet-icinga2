require 'spec_helper'

describe('icinga2::feature::idopgsql', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icinga2': features => [] }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      case facts[:kernel]
      when 'windows'
        let(:icinga2_conf_dir) { 'C:/ProgramData/icinga2/etc/icinga2' }
        let(:icinga2_pki_dir) { 'C:/ProgramData/icinga2/var/lib/icinga2/certs' }
        let(:ido_pgsql_schema_dir) { 'C:/Program Files/icinga2/usr/share/icinga2-ido-pgsql/schema' }
        let(:icinga2_sslkey_mode) { nil }
        let(:icinga2_user) { nil }
        let(:icinga2_group) { nil }
      when 'FreeBSD'
        let(:icinga2_conf_dir) { '/usr/local/etc/icinga2' }
        let(:icinga2_pki_dir) { '/var/lib/icinga2/certs' }
        let(:ido_pgsql_schema_dir) { '/usr/local/share/icinga2-ido-pgsql/schema' }
        let(:icinga2_sslkey_mode) { '0600' }
        let(:icinga2_user) { 'icinga' }
        let(:icinga2_group) { 'icinga' }
      else
        let(:icinga2_conf_dir) { '/etc/icinga2' }
        let(:icinga2_pki_dir) { '/var/lib/icinga2/certs' }
        let(:ido_pgsql_schema_dir) { '/usr/share/icinga2-ido-pgsql/schema' }
        let(:icinga2_sslkey_mode) { '0600' }
        case facts[:os]['family']
        when 'Debian'
          let(:icinga2_user) { 'nagios' }
          let(:icinga2_group) { 'nagios' }
        else
          let(:icinga2_user) { 'icinga' }
          let(:icinga2_group) { 'icinga' }
        end
      end

      context 'with defaults' do
        let(:params) do
          {
            password: 'foo',
          }
        end

        if facts[:kernel] == 'Linux'
          it { is_expected.to contain_package('icinga2-ido-pgsql').with({ 'ensure' => 'installed' }) }
        end

        if facts[:os]['family'] == 'Debian'
          it {
            is_expected.to contain_file('/etc/dbconfig-common/icinga2-ido-pgsql.conf').with(
              {
                'ensure' => 'file',
                'owner'  => 'root',
                'group'  => 'root',
              },
            )
          }
        end

        it { is_expected.to contain_icinga2__feature('ido-pgsql').with({ 'ensure' => 'present' }) }

        it {
          is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql').with(
            { 'target' => "#{icinga2_conf_dir}/features-available/ido-pgsql.conf" },
          )
        }
      end

      context 'with ensure => absent' do
        let(:params) do
          {
            ensure: 'absent',
            password: 'foo',
          }
        end

        it { is_expected.to contain_icinga2__feature('ido-pgsql').with({ 'ensure' => 'absent' }) }
      end

      context 'with import_schema => true' do
        let(:params) do
          {
            import_schema: true,
            password: 'foo',
          }
        end

        it {
          is_expected.to contain_exec('idopgsql-import-schema').with(
            {
              'user'        => 'root',
              'environment' => ['PGPASSWORD=foo'],
              'command'     => "psql -h 'localhost' -U 'icinga' -p '5432' -d 'icinga' -w -f \"#{ido_pgsql_schema_dir}/pgsql.sql\"",
            },
          )
        }
      end

      if facts[:kernel] == 'Linux'
        context 'with manage_packages => false' do
          let(:params) do
            {
              password: 'foo',
            }
          end

          let(:pre_condition) do
            [
              "class { 'icinga2': features => [], manage_packages => false }",
            ]
          end

          it { is_expected.not_to contain_package('icinga2').with({ 'ensure' => 'installed' }) }
          it { is_expected.not_to contain_package('icinga2-ido-pgsql').with({ 'ensure' => 'installed' }) }
        end
      end
    end
  end
end
