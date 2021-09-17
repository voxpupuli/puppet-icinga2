# A strict type of syslog facilities
type Icinga2::LogFacility = Variant[
  Enum[
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
    'LOG_UUCP'
  ], Pattern[/^LOG_LOCAL[0-7]$/]]
