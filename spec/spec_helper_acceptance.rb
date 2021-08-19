require 'beaker-rspec'
require 'beaker/puppet_install_helper'

# Install Puppet on all hosts
install_puppet_agent_on(hosts, puppet_collection: 'puppet5')

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    # Install module to all hosts
    hosts.each do |host|
      install_dev_puppet_module_on(host, source: module_root, module_name: 'icinga2',
        target_module_path: '/etc/puppetlabs/code/modules')

      # Install dependencies
      on(host, puppet('module', 'install', 'icinga-icinga'))
      on(host, puppet('module', 'install', 'puppetlabs-stdlib'))
      on(host, puppet('module', 'install', 'puppetlabs-concat'))

      # Install additional modules
      on(host, puppet('module', 'install', 'puppetlabs-mysql'))
      on(host, puppet('module', 'install', 'puppetlabs-postgresql'))

      if fact('os.family') == 'Debian'
        on(host, puppet('module', 'install', 'puppetlabs-apt'))
      end

      if fact('os.family') == 'Suse'
        on(host, puppet('module', 'install', 'puppet-zypprepo'))
      end

      # Add more setup code as needed
    end
  end
end

shared_examples 'a idempotent resource' do
  it 'applies with no errors' do
    apply_manifest(pp, catch_failures: true)
  end

  it 'applies a second time without changes', :skip_pup_5016 do
    apply_manifest(pp, catch_changes: true)
  end
end
