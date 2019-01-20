require 'spec_helper'

describe('icinga2::feature::mainlog', :type => :class) do
  let(:pre_condition) do
    [
      "class { 'icinga2': features => [], }"
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      before(:each) do
        case facts[:kernel]
        when 'windows'
          @icinga2_conf_dir = 'C:/ProgramData/icinga2/etc/icinga2'
        when 'FreeBSD'
          @icinga2_conf_dir = '/usr/local/etc/icinga2'
        else
          @icinga2_conf_dir = '/etc/icinga2'
        end
      end

      context "with defaults" do
        let(:params) do
          {
            :ensure => 'present'
          }
        end

        it { is_expected.to contain_icinga2__feature('mainlog').with({'ensure' => 'present'}) }

        it { is_expected.to contain_icinga2__object('icinga2::object::FileLogger::mainlog')
          .with({ 'target' => "#{@icinga2_conf_dir}/features-available/mainlog.conf" })
          .that_notifies('Class[icinga2::service]') }

        case facts[:osfamily]
        when 'windows'
          it { is_expected.to contain_concat__fragment('icinga2::object::FileLogger::mainlog')
            .with({
              'target' => "#{@icinga2_conf_dir}/features-available/mainlog.conf", })
            .with_content(/path = \"C:\/ProgramData\/icinga2\/var\/log\/icinga2\/icinga2.log\"/) }
        else
          it { is_expected.to contain_concat__fragment('icinga2::object::FileLogger::mainlog')
            .with({
              'target' => "#{@icinga2_conf_dir}/features-available/mainlog.conf", })
            .with_content(/path = \"\/var\/log\/icinga2\/icinga2.log\"/) }
        end
      end

      context "#{os} with ensure => absent" do
        let(:params) do
          {
            :ensure => 'absent'
          }
        end

        it { is_expected.to contain_icinga2__feature('mainlog').with({'ensure' => 'absent'}) }
      end
    end

  end
end
