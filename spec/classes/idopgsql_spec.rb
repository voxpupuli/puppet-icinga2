require 'spec_helper'

describe('icinga2::feature::idopgsql', :type => :class) do
  let(:pre_condition) { [
      "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('ido-pgsql').with({'ensure' => 'present'}) }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('ido-pgsql').with({'ensure' => 'absent'}) }
    end

    context "#{os} with all defaults" do
      it { is_expected.to contain_icinga2__feature('ido-pgsql').with({'ensure' => 'present'}) }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/host = "127.0.0.1"/)
                              .with_content(/port = 5432/)
                              .with_content(/user = "icinga"/)
                              .with_content(/password = "icinga"/)
                              .with_content(/table_prefix = "icinga_"/)
                              .with_content(/instance_name = "default"/)
                              .with_content(/enable_ha = true/)
                              .with_content(/failover_timeout = 60s/) }
    end


    context "#{os} with host => 127.0.0.2" do
      let(:params) { {:host => '127.0.0.2'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/host = "127.0.0.2"/) }
    end


    context "#{os} with host => foo (not a valid IP address)" do
      let(:params) { {:host => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a valid IP address/) }
    end


    context "#{os} with port => 4247" do
      let(:params) { {:port => '4247'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/port = 4247/) }
    end


    context "#{os} with port => foo (not a valid integer)" do
      let(:params) { {:port => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
    end


    context "#{os} with user => foo" do
      let(:params) { {:user => 'foo'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/user = "foo"/) }
    end


    context "#{os} with user => 4247 (not a valid string)" do
      let(:params) { {:user => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with database => foo" do
      let(:params) { {:database => 'foo'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/database = "foo"/) }
    end


    context "#{os} with database => 4247 (not a valid string)" do
      let(:params) { {:database => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with table_prefix => foo" do
      let(:params) { {:table_prefix => 'foo'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/table_prefix = "foo"/) }
    end


    context "#{os} with table_prefix => 4247 (not a valid string)" do
      let(:params) { {:table_prefix => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with instance_name => foo" do
      let(:params) { {:instance_name => 'foo'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/instance_name = "foo"/) }
    end


    context "#{os} with instance_name => 4247 (not a valid string)" do
      let(:params) { {:instance_name => 4247} }

      it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
    end


    context "#{os} with enable_ha => true" do
      let(:params) { {:enable_ha => true} }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/enable_ha = true/) }
    end


    context "#{os} with enable_ha => false" do
      let(:params) { {:enable_ha => false} }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/enable_ha = false/) }
    end


    context "#{os} with enable_ha => foo (not a valid boolean)" do
      let(:params) { {:enable_ha => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end


    context "#{os} with failover_timeout => 50s" do
      let(:params) { {:failover_timeout => '50s'} }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/failover_timeout = 50s/) }
    end


    context "#{os} with failover_timeout => foo (not a valid value)" do
      let(:params) { {:failover_timeout => "foo"} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
    end


    context "#{os} with cleanup => { foo => 'bar', bar => 'foo' }" do
      let(:params) { {:cleanup => { 'foo' => "bar", 'bar' => "foo" } } }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/cleanup = {\n\s+foo = "bar"\n\s+bar = "foo"\n\s+}/) }
    end


    context "#{os} with cleanup => 'foo' (not a valid hash)" do
      let(:params) { {:cleanup => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
    end


    context "#{os} with categories => ['foo', 'bar']" do
      let(:params) { {:categories => ['foo', 'bar'] } }

      it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                              .with({ 'target' => '/etc/icinga2/features-available/ido-pgsql.conf' })
                              .with_content(/categories = \[ "foo", "bar", \]/) }
    end


    context "#{os} with categories => 'foo' (not a valid array)" do
      let(:params) { {:categories => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not an Array/) }
    end


    context "#{os} with import_schema => true" do
      let(:params) { {:import_schema => true} }

      it { is_expected.to contain_exec('idopgsql_import_schema') }
    end


    context "#{os} with import_schema => false" do
      let(:params) { {:import_schema => false} }

      it { should_not contain_exec('idopgsql_import_schema') }
    end


    context "#{os} with import_schema => foo (not a valid boolean)" do
      let(:params) { {:import_schema => 'foo'} }

      it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
    end

  end

end

describe('icinga2::feature::idopgsql', :type => :class) do
  let(:pre_condition) { [
      "class { 'icinga2': features => [], }"
  ] }

  let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2',
      :path => 'C:/Program Files/Postgresql/bin'
  } }


  context "Windows 2012 R2 with ensure => present" do
    let(:params) { {:ensure => 'present'} }

    it { is_expected.to contain_icinga2__feature('ido-pgsql').with({'ensure' => 'present'}) }
  end


  context "Windows 2012 R2 with ensure => absent" do
    let(:params) { {:ensure => 'absent'} }

    it { is_expected.to contain_icinga2__feature('ido-pgsql').with({'ensure' => 'absent'}) }
  end

  context "Windows 2012 R2 with all defaults" do
    it { is_expected.to contain_icinga2__feature('ido-pgsql').with({'ensure' => 'present'}) }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/host = "127.0.0.1"/)
                            .with_content(/port = 5432/)
                            .with_content(/user = "icinga"/)
                            .with_content(/password = "icinga"/)
                            .with_content(/table_prefix = "icinga_"/)
                            .with_content(/instance_name = "default"/)
                            .with_content(/enable_ha = true/)
                            .with_content(/failover_timeout = 60s/) }
  end


  context "Windows 2012 R2 with host => 127.0.0.2" do
    let(:params) { {:host => '127.0.0.2'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/host = "127.0.0.2"/) }
  end


  context "Windows 2012 R2 with host => foo (not a valid IP address)" do
    let(:params) { {:host => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a valid IP address/) }
  end


  context "Windows 2012 R2 with port => 4247" do
    let(:params) { {:port => '4247'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/port = 4247/) }
  end


  context "Windows 2012 R2 with port => foo (not a valid integer)" do
    let(:params) { {:port => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /first argument to be an Integer/) }
  end


  context "Windows 2012 R2 with user => foo" do
    let(:params) { {:user => 'foo'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/user = "foo"/) }
  end


  context "Windows 2012 R2 with user => 4247 (not a valid string)" do
    let(:params) { {:user => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with database => foo" do
    let(:params) { {:database => 'foo'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/database = "foo"/) }
  end


  context "Windows 2012 R2 with database => 4247 (not a valid string)" do
    let(:params) { {:database => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with table_prefix => foo" do
    let(:params) { {:table_prefix => 'foo'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/table_prefix = "foo"/) }
  end


  context "Windows 2012 R2 with table_prefix => 4247 (not a valid string)" do
    let(:params) { {:table_prefix => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with instance_name => foo" do
    let(:params) { {:instance_name => 'foo'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/instance_name = "foo"/) }
  end


  context "Windows 2012 R2 with instance_name => 4247 (not a valid string)" do
    let(:params) { {:instance_name => 4247} }

    it { is_expected.to raise_error(Puppet::Error, /4247 is not a string/) }
  end


  context "Windows 2012 R2 with enable_ha => true" do
    let(:params) { {:enable_ha => true} }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/enable_ha = true/) }
  end


  context "Windows 2012 R2 with enable_ha => false" do
    let(:params) { {:enable_ha => false} }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/enable_ha = false/) }
  end


  context "Windows 2012 R2 with enable_ha => foo (not a valid boolean)" do
    let(:params) { {:enable_ha => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end


  context "Windows 2012 R2 with failover_timeout => 50s" do
    let(:params) { {:failover_timeout => '50s'} }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/failover_timeout = 50s/) }
  end


  context "Windows 2012 R2 with failover_timeout => foo (not a valid value)" do
    let(:params) { {:failover_timeout => "foo"} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" does not match/) }
  end


  context "Windows 2012 R2 with cleanup => { foo => 'bar', bar => 'foo' }" do
    let(:params) { {:cleanup => { 'foo' => "bar", 'bar' => "foo" } } }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/cleanup = {\r\n\s+foo = "bar"\r\n\s+bar = "foo"\r\n\s+}/) }
  end


  context "Windows 2012 R2 with cleanup => 'foo' (not a valid hash)" do
    let(:params) { {:cleanup => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
  end


  context "Windows 2012 R2 with categories => ['foo', 'bar']" do
    let(:params) { {:categories => ['foo', 'bar'] } }

    it { is_expected.to contain_concat__fragment('icinga2::object::IdoPgsqlConnection::ido-pgsql')
                            .with({ 'target' => 'C:/ProgramData/icinga2/etc/icinga2/features-available/ido-pgsql.conf' })
                            .with_content(/categories = \[ "foo", "bar", \]/) }
  end


  context "Windows 2012 R2 with categories => 'foo' (not a valid array)" do
    let(:params) { {:categories => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not an Array/) }
  end


  context "Windows 2012 R2 with import_schema => true" do
    let(:params) { {:import_schema => true} }

    it { is_expected.to contain_exec('idopgsql_import_schema') }
  end


  context "Windows 2012 R2 with import_schema => false" do
    let(:params) { {:import_schema => false} }

    it { should_not contain_exec('idopgsql_import_schema') }
  end


  context "Windows 2012 R2 with import_schema => foo (not a valid boolean)" do
    let(:params) { {:import_schema => 'foo'} }

    it { is_expected.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end

end
