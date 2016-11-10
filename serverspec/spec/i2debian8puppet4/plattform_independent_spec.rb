require 'spec_helper'

describe package('icinga2') do
  it { should be_installed }
end

describe service('icinga2') do
  it { should be_enabled }
  it { should be_running }
end
