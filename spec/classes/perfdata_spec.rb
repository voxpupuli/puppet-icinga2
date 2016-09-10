require 'spec_helper'

describe('icinga2::feature::perfdata', :type => :class) do
  let(:pre_condition) { [
    "class { 'icinga2': features => [], }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with ensure => present" do
      let(:params) { {:ensure => 'present'} }

      it { is_expected.to contain_icinga2__feature('perfdata').with({'ensure' => 'present'}) }
    end


    context "#{os} with ensure => absent" do
      let(:params) { {:ensure => 'absent'} }

      it { is_expected.to contain_icinga2__feature('perfdata').with({'ensure' => 'absent'}) }
    end


    context "#{os} with rotation_interval => 1m" do
      let(:params) { {:rotation_interval => '1m'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/perfdata.conf')
          .with_content(/rotation_interval = 1m/)
      }
    end


    context "#{os} with rotation_interval => foo (not a valid value)" do
      let(:params) { {:rotation_interval => 'foo'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('perfdata')
        }.to raise_error(Puppet::Error, /"foo" does not match/)
      end
    end


    context "#{os} with host_perfdata_path => /foo/bar" do
      let(:params) { {:host_perfdata_path => '/foo/bar'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/perfdata.conf')
          .with_content(/host_perfdata_path = "\/foo\/bar"/)
      }
    end


    context "#{os} with host_perfdata_path => foo/bar (not an absolute path)" do
      let(:params) { {:host_perfdata_path => 'foo/bar'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('perfdata')
        }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
      end
    end


    context "#{os} with service_perfdata_path => /foo/bar" do
      let(:params) { {:service_perfdata_path => '/foo/bar'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/perfdata.conf')
          .with_content(/service_perfdata_path = "\/foo\/bar"/)
      }
    end


    context "#{os} with service_perfdata_path => foo/bar (not an absolute path)" do
      let(:params) { {:service_perfdata_path => 'foo/bar'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('perfdata')
        }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
      end
    end


    context "#{os} with host_temp_path => /foo/bar" do
      let(:params) { {:host_temp_path => '/foo/bar'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/perfdata.conf')
          .with_content(/host_temp_path = "\/foo\/bar"/)
      }
    end


    context "#{os} with host_temp_path => foo/bar (not an absolute path)" do
      let(:params) { {:host_temp_path => 'foo/bar'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('perfdata')
        }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
      end
    end


    context "#{os} with service_temp_path => /foo/bar" do
      let(:params) { {:service_temp_path => '/foo/bar'} }

      it {
        is_expected.to contain_file('/etc/icinga2/features-available/perfdata.conf')
          .with_content(/service_temp_path = "\/foo\/bar"/)
      }
    end


    context "#{os} with service_temp_path => foo/bar (not an absolute path)" do
      let(:params) { {:service_temp_path => 'foo/bar'} }

      it do
        expect {
          is_expected.to contain_icinga2__feature('perfdata')
        }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
      end
    end
  end


  context 'Windows 2012 R2 with ensure => present' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ensure => 'present'} }

    it { is_expected.to contain_icinga2__feature('perfdata').with({'ensure' => 'present'}) }
  end


  context 'Windows 2012 R2 with ensure => absent' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:ensure => 'absent'} }

    it { is_expected.to contain_icinga2__feature('perfdata').with({'ensure' => 'absent'}) }
  end


  context 'Windows 2012 R2 with rotation_interval => 1m' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:rotation_interval => '1m'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/perfdata.conf')
        .with_content(/rotation_interval = 1m/)
    }
  end


  context 'Windows 2012 R2 with rotation_interval => foo (not a valid value)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:rotation_interval => 'foo'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('perfdata')
      }.to raise_error(Puppet::Error, /"foo" does not match/)
    end
  end


  context 'Windows 2012 R2 with host_perfdata_path => c:/foo/bar' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:host_perfdata_path => 'c:/foo/bar'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/perfdata.conf')
        .with_content(/host_perfdata_path = "c:\/foo\/bar"/)
    }
  end


  context 'Windows 2012 R2 with host_perfdata_path => foo/bar (not an absolute path)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:host_perfdata_path => 'foo/bar'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('perfdata')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end


  context 'Windows 2012 R2 with service_perfdata_path => c:/foo/bar' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:service_perfdata_path => 'c:/foo/bar'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/perfdata.conf')
        .with_content(/service_perfdata_path = "c:\/foo\/bar"/)
    }
  end


  context 'Windows 2012 R2 with service_perfdata_path => foo/bar (not an absolute path)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:service_perfdata_path => 'foo/bar'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('perfdata')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end


  context 'Windows 2012 R2 with host_temp_path => c:/foo/bar' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:host_temp_path => 'c:/foo/bar'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/perfdata.conf')
        .with_content(/host_temp_path = "c:\/foo\/bar"/)
    }
  end


  context 'Windows 2012 R2 with host_temp_path => foo/bar (not an absolute path)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:host_temp_path => 'foo/bar'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('perfdata')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end


  context 'Windows 2012 R2 with service_temp_path => c:/foo/bar' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:service_temp_path => 'c:/foo/bar'} }

    it {
      is_expected.to contain_file('C:/ProgramData/icinga2/etc/icinga2/features-available/perfdata.conf')
        .with_content(/service_temp_path = "c:\/foo\/bar"/)
    }
  end


  context 'Windows 2012 R2 with service_temp_path => foo/bar (not an absolute path)' do
    let(:facts) { {
      :kernel => 'Windows',
      :architecture => 'x86_64',
      :osfamily => 'Windows',
      :operatingsystem => 'Windows',
      :operatingsystemmajrelease => '2012 R2'
    } }
    let(:params) { {:service_temp_path => 'foo/bar'} }

    it do
      expect {
        is_expected.to contain_icinga2__feature('perfdata')
      }.to raise_error(Puppet::Error, /"foo\/bar" is not an absolute path/)
    end
  end
end
