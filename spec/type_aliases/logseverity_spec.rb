require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0

  describe 'Icinga2::LogSeverity' do
    describe 'valid handling' do
      [
        'debug', 'information', 'notice', 'warning', 'critical'
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'invalid path handling' do
      context 'garbage inputs' do
        [nil, '', 'foo'].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end

end
