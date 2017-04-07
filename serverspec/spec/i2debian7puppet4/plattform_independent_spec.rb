require 'spec_helper'

describe package('icinga2') do
  it { should be_installed }
end

describe service('icinga2') do
  it { should be_enabled }
  it { should be_running }
end

describe port(5665) do
  it { should be_listening.with('tcp') }
end

describe command('curl -u icinga:icinga -k https://localhost:5665/v1') do
  its(:stdout) { should match(%r{Hello from Icinga 2}) }
end
