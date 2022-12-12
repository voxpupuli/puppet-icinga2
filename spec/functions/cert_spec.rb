require 'spec_helper'

describe 'icinga2::cert' do
  let(:pre_condition) do
    [
      "class { 'icinga2': }",
    ]
  end

  let(:facts) do
    {
      kernel: 'Linux',
      os: {
        family: 'Debian',
        name: 'Debian',
      },
    }
  end

  it { is_expected.not_to eq(nil) }

  it 'with just a name' do
    is_expected.to run.with_params(
      'foo',
    ).and_return({ 'key' => nil, 'key_file' => nil, 'cert' => nil, 'cert_file' => nil, 'cacert' => nil, 'cacert_file' => nil })
  end

  it 'with key, cert and cacert' do
    is_expected.to run.with_params(
      'foo',
      nil,
      nil,
      nil,
      'key',
      'cert',
      'cacert',
    ).and_return({ 'key' => 'key', 'key_file' => '/var/lib/icinga2/certs/foo.key',
                   'cert' => 'cert', 'cert_file' => '/var/lib/icinga2/certs/foo.crt',
                   'cacert' => 'cacert', 'cacert_file' => '/var/lib/icinga2/certs/foo_ca.crt' })
  end

  it 'with file paths only' do
    is_expected.to run.with_params(
      'foo',
      '/foo.key',
      '/foo.crt',
      '/ca.crt',
      nil,
      nil,
      nil,
    ).and_return({ 'key' => nil, 'key_file' => '/foo.key', 'cert' => nil, 'cert_file' => '/foo.crt', 'cacert' => nil, 'cacert_file' => '/ca.crt' })
  end

  it 'with all params' do
    is_expected.to run.with_params(
      'foo',
      '/foo.key',
      '/foo.crt',
      '/ca.crt',
      'key',
      'cert',
      'cacert',
    ).and_return({ 'key' => 'key', 'key_file' => '/foo.key', 'cert' => 'cert', 'cert_file' => '/foo.crt', 'cacert' => 'cacert', 'cacert_file' => '/ca.crt' })
  end
end
