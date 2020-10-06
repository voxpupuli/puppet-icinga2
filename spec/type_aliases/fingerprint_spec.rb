require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0

  describe 'Icinga2::Fingerprint' do
    describe 'valid handling' do
      ['68:ac:90:64:95:48:0a:34:04:be:ee:48:74:ed:85:3a:03:7a:7a:8f', '68:ac:90:64:95:48:0a:34:04:be:ee:48:74:ed:85:3a:03:7a:7a:8f:04:be:ee:48:74:ed:85:3a:03:7a:7a:8f'].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'invalid path handling' do
      context 'garbage inputs' do
        [nil, '', '68ac906495480a3404beee4874ed853a037a7a8f', '68ac906495480a3404beee4874ed853a037a7a8f04beee4874ed853a037a7a8f' ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end

end
