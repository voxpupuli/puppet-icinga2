require 'spec_helper'

describe('icinga2::pki::ca', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icinga2': features => [], constants => {'NodeName' => 'host.example.org'} }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        case facts[:kernel]
        when 'windows'
          facts.merge(
            {
              icinga2_puppet_hostcert: 'C:/ProgramData/PuppetLabs/puppet/ssl/certs/host.example.org.pem',
              icinga2_puppet_hostprivkey: 'C:/ProgramData/PuppetLabs/puppet/ssl/private_keys/host.example.org.pem',
              icinga2_puppet_localcacert: 'C:/ProgramData/PuppetLabs/puppet/ssl/certs/ca.pem',
            },
          )
        else
          facts.merge(
            {
              icinga2_puppet_hostcert: '/etc/puppetlabs/puppet/ssl/certs/host.example.org.pem',
              icinga2_puppet_hostprivkey: '/etc/puppetlabs/puppet/ssl/private_keys/host.example.org.pem',
              icinga2_puppet_localcacert: '/etc/lib/puppetlabs/puppet/ssl/certs/ca.pem',
            },
          )
        end
      end

      case facts[:kernel]
      when 'windows'
        let(:icinga2_bin) { 'C:/Program Files/icinga2/sbin/icinga2.exe' }
        let(:icinga2_conf_dir) { 'C:/ProgramData/icinga2/etc/icinga2' }
        let(:icinga2_pki_dir) { 'C:/ProgramData/icinga2/var/lib/icinga2/certs' }
        let(:icinga2_ca_dir) { 'C:/ProgramData/icinga2/var/lib/icinga2/ca' }
        let(:icinga2_sslkey_mode) { nil }
        let(:icinga2_user) { nil }
        let(:icinga2_group) { nil }
      when 'FreeBSD'
        let(:icinga2_bin) { '/usr/local/sbin/icinga2' }
        let(:icinga2_conf_dir) { '/usr/local/etc/icinga2' }
        let(:icinga2_pki_dir) { '/var/lib/icinga2/certs' }
        let(:icinga2_ca_dir) { '/var/lib/icinga2/ca' }
        let(:icinga2_sslkey_mode) { '0600' }
        let(:icinga2_user) { 'icinga' }
        let(:icinga2_group) { 'icinga' }
      else
        let(:icinga2_conf_dir) { '/etc/icinga2' }
        let(:icinga2_pki_dir) { '/var/lib/icinga2/certs' }
        let(:icinga2_ca_dir) { '/var/lib/icinga2/ca' }
        let(:icinga2_sslkey_mode) { '0600' }
        case facts[:os]['family']
        when 'Debian'
          let(:icinga2_user) { 'nagios' }
          let(:icinga2_group) { 'nagios' }
          let(:icinga2_bin) { '/usr/sbin/icinga2' }
        else
          let(:icinga2_user) { 'icinga' }
          let(:icinga2_group) { 'icinga' }
          if facts[:os]['family'] != 'RedHat'
            let(:icinga2_bin) { '/usr/sbin/icinga2' }
          else
            case facts[:os]['release']['major']
            when '5'
              let(:icinga2_bin) { '/usr/sbin/icinga2' }
            when '6'
              let(:icinga2_bin) { '/usr/sbin/icinga2' }
            else
              let(:icinga2_bin) { '/sbin/icinga2' }
            end
          end
        end
      end

      context 'with defaults' do
        it {
          is_expected.to contain_exec('create-icinga2-ca').with(
            {
              'command' => "\"#{icinga2_bin}\" pki new-ca",
              'creates' => "#{icinga2_ca_dir}/ca.crt",
            },
          ).that_notifies('Class[icinga2::service]').that_comes_before("File[#{icinga2_pki_dir}/ca.crt]")
        }

        it {
          is_expected.to contain_exec('icinga2 pki create certificate signing request').with(
            {
              'command' => "\"#{icinga2_bin}\" pki new-cert --cn host.example.org --key #{icinga2_pki_dir}/host.example.org.key --csr #{icinga2_pki_dir}/host.example.org.csr",
              'creates' => "#{icinga2_pki_dir}/host.example.org.key",
            },
          ) # .that_requires("File[#{icinga2_pki_dir}/ca.crt]")
        }

        it {
          is_expected.to contain_exec('icinga2 pki sign certificate').with(
            {
              'command'     => "\"#{icinga2_bin}\" pki sign-csr --csr #{icinga2_pki_dir}/host.example.org.csr --cert #{icinga2_pki_dir}/host.example.org.crt",
              'refreshonly' => true,
            },
          ).that_notifies('Class[icinga2::service]').that_subscribes_to('Exec[icinga2 pki create certificate signing request]')
        }

        it {
          is_expected.to contain_file("#{icinga2_pki_dir}/ca.crt").with(
            {
              'ensure' => 'file',
              'owner'  => icinga2_user,
              'group'  => icinga2_group,
            },
          )
        }

        it {
          is_expected.to contain_file("#{icinga2_pki_dir}/host.example.org.key").with(
            {
              'ensure'    => 'file',
              'owner'     => icinga2_user,
              'group'     => icinga2_group,
              'mode'      => icinga2_sslkey_mode,
              'show_diff' => false,
              'backup'    => false,
            },
          ).that_requires('Exec[icinga2 pki create certificate signing request]')
        }

        it {
          is_expected.to contain_file("#{icinga2_pki_dir}/host.example.org.crt").with(
            {
              'ensure' => 'file',
              'owner'  => icinga2_user,
              'group'  => icinga2_group,
            },
          ).that_requires('Exec[icinga2 pki sign certificate]')
        }

        it {
          is_expected.to contain_file("#{icinga2_pki_dir}/host.example.org.csr").with(
            { 'ensure' => 'absent' },
          ).that_requires('Exec[icinga2 pki sign certificate]')
        }
      end

      context "with ca_cert => 'foo', ca_key => 'bar'" do
        let(:params) do
          {
            ca_cert: 'foo',
            ca_key: 'bar'
          }
        end

        it {
          is_expected.to contain_exec('icinga2 pki create certificate signing request').with(
            {
              'command' => "\"#{icinga2_bin}\" pki new-cert --cn host.example.org --key #{icinga2_pki_dir}/host.example.org.key --csr #{icinga2_pki_dir}/host.example.org.csr",
              'creates' => "#{icinga2_pki_dir}/host.example.org.key",
            },
          ).that_requires("File[#{icinga2_pki_dir}/ca.crt]")
        }

        it {
          is_expected.to contain_exec('icinga2 pki sign certificate').with(
            {
              'command' => "\"#{icinga2_bin}\" pki sign-csr --csr #{icinga2_pki_dir}/host.example.org.csr --cert #{icinga2_pki_dir}/host.example.org.crt",
              'refreshonly' => true,
            },
          ).that_notifies('Class[icinga2::service]').that_subscribes_to('Exec[icinga2 pki create certificate signing request]')
        }

        it {
          is_expected.to contain_file("#{icinga2_ca_dir}/ca.crt").with(
            {
              'ensure' => 'file',
              'owner'  => icinga2_user,
              'group'  => icinga2_group,
              'tag'    => 'icinga2::config::file',
            },
          ).with_content(%r{^foo$}).that_comes_before("File[#{icinga2_pki_dir}/ca.crt]")
        }

        it {
          is_expected.to contain_file("#{icinga2_ca_dir}/ca.key").with(
            {
              'ensure' => 'file',
              'owner' => icinga2_user,
              'group' => icinga2_group,
              'mode' => icinga2_sslkey_mode,
              'tag' => 'icinga2::config::file',
              'show_diff' => false,
              'backup' => false,
            },
          ).with_content(%r{bar})
        }
      end
    end
  end
end
