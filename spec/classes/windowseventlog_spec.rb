require 'spec_helper'

describe('icinga2::feature::windowseventlog', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icinga2': features => [] }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      case facts[:kernel]
      when 'windows'
        let(:icinga2_conf_dir) { 'C:/ProgramData/icinga2/etc/icinga2' }

        context 'with defaults' do
          it { is_expected.to contain_icinga2__feature('windowseventlog').with({ 'ensure' => 'present' }) }

          it {
            is_expected.to contain_icinga2__object('icinga2::object::WindowsEventLogLogger::windowseventlog').with(
              { 'target' => "#{icinga2_conf_dir}/features-available/windowseventlog.conf" },
            ).that_notifies('Class[icinga2::service]')
          }
        end
      else
        it { is_expected.to raise_error(Puppet::Error, %r{only supported on Windows platforms}) }
      end

      context 'with ensure => absent' do
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it { is_expected.to contain_icinga2__feature('windowseventlog').with({ 'ensure' => 'absent' }) }
      end
    end
  end
end
