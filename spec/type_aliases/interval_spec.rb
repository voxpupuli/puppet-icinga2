require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0

  describe 'Icinga2::Interval' do
    describe 'valid handling' do
      [60, '3d', '3.5d', '4h', '4.1h', '5m', '5.2m', '60s', '60.4', '300', '300.25'].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'invalid path handling' do
      context 'garbage inputs' do
        [nil, '', 'foo' ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end

end
