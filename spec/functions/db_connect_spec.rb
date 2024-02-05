require 'spec_helper'

describe 'icinga2::db::connect' do
  it { is_expected.not_to eq(nil) }

  it 'with MySQL/MariaDB' do
    is_expected.to run.with_params(
      { 'type' => 'mysql', 'host' => 'localhost', 'database' => 'foo', 'username' => 'bar', 'password' => 'supersecret' }, {}
    ).and_return("-u bar -p'supersecret' -D foo")
  end

  it 'with MySQL/MariaDB on db.example.org and port 4711' do
    is_expected.to run.with_params(
      { 'type' => 'mysql', 'host' => 'db.example.org', 'port' => 4711, 'database' => 'foo', 'username' => 'bar', 'password' => 'supersecret' }, {}
    ).and_return("-h db.example.org -P 4711 -u bar -p'supersecret' -D foo")
  end

  it 'with MariaDB TLS on db.example.org and password' do
    is_expected.to run.with_params(
      { 'type' => 'mariadb', 'host' => 'db.example.org', 'database' => 'foo', 'username' => 'bar', 'password' => 'supersecret' },
      { 'cacert_file' => '/cacert.file' },
      true,
    ).and_return("-h db.example.org -u bar -p'supersecret' -D foo --ssl  --ssl-ca /cacert.file")
  end

  it "with MariaDB TLS and noverify 'true' on db.example.org and password" do
    is_expected.to run.with_params(
      { 'type' => 'mariadb', 'host' => 'db.example.org', 'database' => 'foo', 'username' => 'bar', 'password' => 'supersecret' },
      { 'noverify' => true, 'cacert_file' => '/cacert.file' },
      true,
    ).and_return("-h db.example.org -u bar -p'supersecret' -D foo --ssl")
  end

  it 'with MariaDB client TLS cert on db.example.org' do
    is_expected.to run.with_params(
      { 'type' => 'mariadb', 'host' => 'db.example.org', 'database' => 'foo', 'username' => 'bar' },
      { 'key_file' => '/key.file', 'cert_file' => '/cert.file', 'cacert_file' => '/cacert.file' },
      true,
    ).and_return('-h db.example.org -u bar -D foo --ssl --ssl-ca /cacert.file --ssl-cert /cert.file --ssl-key /key.file')
  end

  it 'with MySQL client TLS cert on db.example.org' do
    is_expected.to run.with_params(
      { 'type' => 'mysql', 'host' => 'db.example.org', 'database' => 'foo', 'username' => 'bar' },
      { 'key_file' => '/key.file', 'cert_file' => '/cert.file', 'cacert_file' => '/cacert.file' },
      true,
    ).and_return('-h db.example.org -u bar -D foo --ssl-mode VERIFY_CA --ssl-ca /cacert.file --ssl-cert /cert.file --ssl-key /key.file')
  end

  it "with MySQL TLS and noverify 'true' on db.example.org and password" do
    is_expected.to run.with_params(
      { 'type' => 'mysql', 'host' => 'db.example.org', 'database' => 'foo', 'username' => 'bar', 'password' => 'supersecret' },
      { 'noverify' => true, 'cacert_file' => '/cacert.file' },
      true,
    ).and_return("-h db.example.org -u bar -p'supersecret' -D foo --ssl-mode REQUIRED")
  end

  it 'with PostgreSQL' do
    is_expected.to run.with_params(
      { 'type' => 'pgsql', 'host' => 'localhost', 'database' => 'foo', 'username' => 'bar', 'password' => 'supersecret' }, {}
    ).and_return('host=localhost user=bar dbname=foo')
  end

  it 'with PostgreSQL on db.example.org and port 4711' do
    is_expected.to run.with_params(
      { 'type' => 'pgsql', 'host' => 'db.example.org', 'port' => 4711, 'database' => 'foo', 'username' => 'bar', 'password' => 'supersecret' }, {}
    ).and_return('host=db.example.org user=bar port=4711 dbname=foo')
  end

  it 'with PostgreSQL TLS on db.example.org and password' do
    is_expected.to run.with_params(
      { 'type' => 'pgsql', 'host' => 'db.example.org', 'database' => 'foo', 'username' => 'bar', 'password' => 'supersecret' },
      { 'cacert_file' => '/cacert.file' },
      true,
    ).and_return('host=db.example.org user=bar dbname=foo sslmode=verify-full sslrootcert=/cacert.file')
  end

  it 'with PostgreSQL TLS on 192.168.0.1 and password' do
    is_expected.to run.with_params(
      { 'type' => 'pgsql', 'host' => '192.168.0.1', 'database' => 'foo', 'username' => 'bar', 'password' => 'supersecret' },
      { 'cacert_file' => '/etc/pki/ca-trust/source/anchors/mycacert.crt' },
      true,
      'verify-ca',
    ).and_return('host=192.168.0.1 user=bar dbname=foo sslmode=verify-ca sslrootcert=/etc/pki/ca-trust/source/anchors/mycacert.crt')
  end

  it 'with PostgreSQL TLS (insecure) on db.example.org and password' do
    is_expected.to run.with_params(
      { 'type' => 'pgsql', 'host' => 'db.example.org', 'database' => 'foo', 'username' => 'bar', 'password' => 'supersecret' },
      { 'noverify' => true },
      true,
    ).and_return('host=db.example.org user=bar dbname=foo sslmode=require')
  end

  it 'with PostgreSQL client TLS cert on db.example.org' do
    is_expected.to run.with_params(
      { 'type' => 'pgsql', 'host' => 'db.example.org', 'database' => 'foo', 'username' => 'bar' },
      { 'key_file' => '/key.file', 'cert_file' => '/cert.file', 'cacert_file' => '/cacert.file' },
      true,
    ).and_return('host=db.example.org user=bar dbname=foo sslmode=verify-full sslcert=/cert.file sslkey=/key.file sslrootcert=/cacert.file')
  end
end
