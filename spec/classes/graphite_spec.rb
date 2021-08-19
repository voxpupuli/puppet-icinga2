require 'spec_helper'

describe('icinga2::feature::graphite', type: :class) do
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
      when 'FreeBSD'
        let(:icinga2_conf_dir) { '/usr/local/etc/icinga2' }
      else
        let(:icinga2_conf_dir) { '/etc/icinga2' }
      end

      context 'with defaults' do
        it { is_expected.to contain_icinga2__feature('graphite').with({ 'ensure' => 'present' }) }

        it {
          is_expected.to contain_icinga2__object('icinga2::object::GraphiteWriter::graphite').with(
            { 'target' => "#{icinga2_conf_dir}/features-available/graphite.conf" },
          ).that_notifies('Class[icinga2::service]')
        }

        it {
          is_expected.to contain_concat__fragment('icinga2::feature::graphite').with(
            {
              'target' => "#{icinga2_conf_dir}/features-available/graphite.conf",
              'order'  => '05',
            },
          ).with_content(%r{library \"perfdata\"$})
        }
      end

      context 'with ensure => absent' do
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it { is_expected.to contain_icinga2__feature('graphite').with({ 'ensure' => 'absent' }) }
      end
    end
  end
end
