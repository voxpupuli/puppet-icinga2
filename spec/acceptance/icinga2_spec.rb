# frozen_string_literal: true

require 'spec_helper_acceptance'

# packages.icinga.com only serves RHEL-family packages to subscribers
describe 'icinga2', if: fact('os.family') == 'Debian' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        class { 'icinga::repos':
          manage_stable => true,
        }
        class { 'icinga2':
          manage_repos => true,
        }
      PUPPET
    end
  end

  describe package('icinga2') do
    it { is_expected.to be_installed }
  end

  describe service('icinga2') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe command('icinga2 daemon -C') do
    its(:exit_status) { is_expected.to eq 0 }
  end
end
