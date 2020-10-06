require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0

  describe 'Icinga2::LogFacility' do
    describe 'valid handling' do
      [
        'LOG_AUTH',
        'LOG_AUTHPRIV',
        'LOG_CRON',
        'LOG_DAEMON',
        'LOG_FTP',
        'LOG_KERN',
        'LOG_LPR',
        'LOG_MAIL',
        'LOG_NEWS',
        'LOG_SYSLOG',
        'LOG_USER',
        'LOG_UUCP',
        'LOG_LOCAL0',
        'LOG_LOCAL1',
        'LOG_LOCAL2',
        'LOG_LOCAL3',
        'LOG_LOCAL4',
        'LOG_LOCAL5',
        'LOG_LOCAL6',
        'LOG_LOCAL7',
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
