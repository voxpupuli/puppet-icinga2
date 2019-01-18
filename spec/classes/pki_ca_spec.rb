require 'spec_helper'

describe('icinga2::pki::ca', :type => :class) do
  let(:pre_condition) { [
      "class { 'icinga2': features => [], constants => {'NodeName' => 'host.example.org'} }"
  ] }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        case facts[:kernel]
        when 'windows'
          facts.merge({
            :icinga2_puppet_hostcert => 'C:/ProgramData/PuppetLabs/puppet/ssl/certs/host.example.org.pem',
            :icinga2_puppet_hostprivkey => 'C:/ProgramData/PuppetLabs/puppet/ssl/private_keys/host.example.org.pem',
            :icinga2_puppet_localcacert => 'C:/ProgramData/PuppetLabs/var/lib/puppet/ssl/certs/ca.pem',
          })
        else
          facts.merge({
            :icinga2_puppet_hostcert => '/etc/puppetlabs/puppet/ssl/certs/host.example.org.pem',
            :icinga2_puppet_hostprivkey => '/etc/puppetlabs/puppet/ssl/private_keys/host.example.org.pem',
            :icinga2_puppet_localcacert => '/etc/lib/puppetlabs/puppet/ssl/certs/ca.pem',
          })
        end
      end

      before(:each) do
        case facts[:kernel]
        when 'windows'
          @icinga2_bin = 'C:/Program Files/icinga2/sbin/icinga2.exe'
          @icinga2_conf_dir = 'C:/ProgramData/icinga2/etc/icinga2'
          @icinga2_pki_dir = 'C:/ProgramData/icinga2/var/lib/icinga2/certs'
          @icinga2_ca_dir = 'C:/ProgramData/icinga2/var/lib/icinga2/ca'
          @icinga2_sslkey_mode = nil
          @icinga2_user = nil
          @icinga2_group = nil
        when 'FreeBSD'
          @icinga2_bin = '/usr/local/sbin/icinga2'
          @icinga2_conf_dir = '/usr/local/etc/icinga2'
          @icinga2_pki_dir = '/var/lib/icinga2/certs'
          @icinga2_ca_dir = '/var/lib/icinga2/ca'
          @icinga2_sslkey_mode = '0600'
          @icinga2_user = 'icinga'
          @icinga2_group = 'icinga'
        else
          @icinga2_conf_dir = '/etc/icinga2'
          @icinga2_pki_dir = '/var/lib/icinga2/certs'
          @icinga2_ca_dir = '/var/lib/icinga2/ca'
          @icinga2_sslkey_mode = '0600'
          case facts[:osfamily]
          when 'Debian'
            @icinga2_user = 'nagios'
            @icinga2_group = 'nagios'
            @icinga2_bin = '/usr/sbin/icinga2'
          else
            @icinga2_user = 'icinga'
            @icinga2_group = 'icinga'
            if facts[:osfamily] != 'RedHat'
              @icinga2_bin = '/usr/sbin/icinga2'
            else
              case facts[:operatingsystemmajrelease]
              when '5'
                @icinga2_bin = '/usr/sbin/icinga2'
              when '6'
                @icinga2_bin = '/usr/sbin/icinga2'
              else
                @icinga2_bin = '/sbin/icinga2'
              end
            end
          end
        end
      end

      context "with defaults" do
        it { is_expected.to contain_exec('create-icinga2-ca')
          .with({
            'command' => "#{@icinga2_bin} pki new-ca",
            'creates' => "#{@icinga2_ca_dir}/ca.crt", })
          .that_notifies('Class[icinga2::service]')
          .that_comes_before("File[#{@icinga2_pki_dir}/ca.crt]") }

        it { is_expected.to contain_exec('icinga2 pki create certificate signing request')
          .with({
            'command' => "#{@icinga2_bin} pki new-cert --cn host.example.org --key #{@icinga2_pki_dir}/host.example.org.key --csr #{@icinga2_pki_dir}/host.example.org.csr",
            'creates' => "#{@icinga2_pki_dir}/host.example.org.key", })
          .that_requires("File[#{@icinga2_pki_dir}/ca.crt]") }
       
        it { is_expected.to contain_exec('icinga2 pki sign certificate')
          .with({
            'command'     => "#{@icinga2_bin} pki sign-csr --csr #{@icinga2_pki_dir}/host.example.org.csr --cert #{@icinga2_pki_dir}/host.example.org.crt",
            'refreshonly' => true, })
          .that_notifies('Class[icinga2::service]')
          .that_subscribes_to('Exec[icinga2 pki create certificate signing request]') }

        it { is_expected.to contain_file("#{@icinga2_pki_dir}/ca.crt")
          .with({
            'ensure' => 'file',
            'owner'  => @icinga2_user,
            'group'  => @icinga2_group, }) }

        it { is_expected.to contain_file("#{@icinga2_pki_dir}/host.example.org.key")
          .with({
            'ensure' => 'file',
            'owner'  => @icinga2_user,
            'group'  => @icinga2_group,
            'mode'   => @icinga2_sslkey_mode, })
          .that_requires('Exec[icinga2 pki create certificate signing request]') }

        it { is_expected.to contain_file("#{@icinga2_pki_dir}/host.example.org.crt")
          .with({
            'ensure' => 'file',
            'owner'  => @icinga2_user,
            'group'  => @icinga2_group, })
          .that_requires('Exec[icinga2 pki sign certificate]') }

        it { is_expected.to contain_file("#{@icinga2_pki_dir}/host.example.org.csr")
          .with({
            'ensure' => 'absent', })
          .that_requires('Exec[icinga2 pki sign certificate]') }
      end


      context "with ca_cert => 'foo', ca_key => 'bar'" do
        let(:params) {{:ca_cert => 'foo', :ca_key => 'bar'}}

        it { is_expected.to contain_exec('icinga2 pki create certificate signing request')
         .with({
           'command' => "#{@icinga2_bin} pki new-cert --cn host.example.org --key #{@icinga2_pki_dir}/host.example.org.key --csr #{@icinga2_pki_dir}/host.example.org.csr",
           'creates' => "#{@icinga2_pki_dir}/host.example.org.key", })
         .that_requires("File[#{@icinga2_pki_dir}/ca.crt]") }
       
        it { is_expected.to contain_exec('icinga2 pki sign certificate')
         .with({
           'command' => "#{@icinga2_bin} pki sign-csr --csr #{@icinga2_pki_dir}/host.example.org.csr --cert #{@icinga2_pki_dir}/host.example.org.crt",
           'refreshonly' => true, })
         .that_notifies('Class[icinga2::service]')
         .that_subscribes_to('Exec[icinga2 pki create certificate signing request]') }

        it { is_expected.to contain_file("#{@icinga2_ca_dir}/ca.crt")
          .with({
            'ensure' => 'file',
            'owner'  => @icinga2_user,
            'group'  => @icinga2_group,
            'tag'    => 'icinga2::config::file', }) 
          .with_content(/^foo$/)
          .that_comes_before("File[#{@icinga2_pki_dir}/ca.crt]") }

        it { is_expected.to contain_file("#{@icinga2_ca_dir}/ca.key")
          .with({
            'ensure' => 'file',
            'owner'  => @icinga2_user,
            'group'  => @icinga2_group,
            'mode'   => @icinga2_sslkey_mode,
            'tag'    => 'icinga2::config::file', })
          .with_content(/bar/)  }
      end
    end

  end
end
