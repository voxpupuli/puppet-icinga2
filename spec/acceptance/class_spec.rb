require 'spec_helper_acceptance'

describe 'icinga2 class' do
  describe 'with API, IDO mysql and pgsql' do
    let(:pp) do
      <<-MANIFEST
        case $::facts['os']['name'] {
          'redhat', 'centos': {
            if Integer($::facts['os']['release']['major']) < 8 {
              $epel      = true
              $backports = false
            }
          } # RedHat
          'debian', 'ubuntu': {
            if $::facts['os']['distro']['codename'] in [ 'stretch', 'trusty' ] {
              $epel      = false
              $backports = true
            }
          } # Debian
        }

        class { '::icinga::repos':
          manage_epel         => $epel,
          configure_backports => $backports,
        }

        class { 'icinga2':
          manage_repos => true,
          constants    => {
            'TicketSalt' => 'topsecret4ticketid',
          },
        }
        include mysql::server
        include mysql::client
        mysql::db { 'icinga2':
          user     => 'icinga2',
          password => 'topsecret4idomysql',
          host     => 'localhost',
          grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER'],
        }
        -> class { 'icinga2::feature::idomysql':
          host          => 'localhost',
          user          => 'icinga2',
          password      => 'topsecret4idomysql',
          database      => 'icinga2',
          import_schema => true,
        }
        include ::postgresql::server
        postgresql::server::db { 'icinga2':
          user     => 'icinga2',
          password => postgresql_password('icinga2', 'topsecret4idopgsql'),
        }
        -> class { 'icinga2::feature::idopgsql':
          host          => 'localhost',
          user          => 'icinga2',
          password      => 'topsecret4idopgsql',
          database      => 'icinga2',
          import_schema => true,
        }
        include ::icinga2::pki::ca
        class { 'icinga2::feature::api':
          pki => 'none',
        }
        icinga2::object::apiuser { 'ticketid':
          ensure      => present,
          password    => 'topsecret4ticketid',
          permissions => [ 'actions/generate-ticket' ],
          target      => '/etc/icinga2/conf.d/api-users.conf',
        }
      MANIFEST
    end

    it_behaves_like 'a idempotent resource'

    describe package('icinga2') do
      it { is_expected.to be_installed }
    end

    describe service('icinga2') do
      it { is_expected.to be_running }
    end

    describe port(5665) do
      it { is_expected.to be_listening }
    end

    describe command("mysql icinga2 -Ns -e 'select version from icinga_dbversion;'") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{^\d+\.\d+.\d+$} }
    end

    describe command("sudo -u postgres psql -d 'icinga2' -w -c 'select version from icinga_dbversion'") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{\d+\.\d+.\d+} }
    end

    describe command("curl -k -s -u ticketid:topsecret4ticketid -X POST -H 'Accept: application/json' -d '{\"cn\": \"agent.example.org\"}' https://localhost:5665/v1/actions/generate-ticket") do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{e1cfea2cff7bc91bd9be1f0f02ef40a0e5233c2e} }
    end
  end
end
