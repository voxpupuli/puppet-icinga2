# @summary
#   This function returns a string to connect databases
#   with or without TLS information.
#
# @return
#   Connection string to connect database.
#
# @param db
#    Data hash with database information.
#
# @param tls
#   Data hash with TLS connection information.
#
# @param use_tls
#   Wether or not to use TLS encryption.
#
# @param ssl_mode
#   Enable SSL connection mode.
#
function icinga2::db::connect(
  Struct[{
      type     => Enum['pgsql','mysql','mariadb'],
      host     => Stdlib::Host,
      port     => Optional[Stdlib::Port],
      database => String,
      username => String,
      password => Optional[Variant[String, Sensitive[String]]],
  }]                   $db,
  Hash[String, Any]    $tls,
  Optional[Boolean]    $use_tls = undef,
  Optional[Enum['verify-full', 'verify-ca']] $ssl_mode = undef,
) >> String {
  if $use_tls {
    case $db['type'] {
      'pgsql': {
        $real_ssl_mode = if $ssl_mode { $ssl_mode } else { 'verify-full' }
        $tls_options = regsubst(join(any2array(delete_undef_values({
                  'sslmode='     => if $tls['noverify'] { 'require' } else { $real_ssl_mode },
                  'sslcert='     => $tls['cert_file'],
                  'sslkey='      => $tls['key_file'],
                  'sslrootcert=' => $tls['cacert_file'],
        })), ' '), '= ', '=', 'G')
      }
      'mariadb': {
        $tls_options = join(any2array(delete_undef_values({
                '--ssl'        => '',
                '--ssl-ca'     => if $tls['noverify'] { undef } else { $tls['cacert_file'] },
                '--ssl-cert'   => $tls['cert_file'],
                '--ssl-key'    => $tls['key_file'],
                '--ssl-capath' => if $tls['noverify'] { undef } else { $tls['capath'] },
                '--ssl-cipher' => $tls['cipher'],
        })), ' ')
      }
      'mysql': {
        $tls_options = join(any2array(delete_undef_values({
                '--ssl-mode'   => if $tls['noverify'] { 'REQUIRED' } else { 'VERIFY_CA' },
                '--ssl-ca'     => if $tls['noverify'] { undef } else { $tls['cacert_file'] },
                '--ssl-cert'   => $tls['cert_file'],
                '--ssl-key'    => $tls['key_file'],
                '--ssl-capath' => if $tls['noverify'] { undef } else { $tls['capath'] },
                '--ssl-cipher' => $tls['cipher'],
        })), ' ')
      }
      default: {
        fail('The database type you provided is not supported.')
      }
    }
  } else {
    $tls_options = ''
  }

  if $db['type'] == 'pgsql' {
    $options = regsubst(join(any2array(delete_undef_values({
              'host='        => $db['host'],
              'user='        => $db['username'],
              'port='        => $db['port'],
              'dbname='      => $db['database'],
    })), ' '), '= ', '=', 'G')
  } else {
    $_password = icinga2::unwrap($db['password'])
    $options = join(any2array(delete_undef_values({
            '-h'               => $db['host'] ? {
              /localhost/  => undef,
              default      => $db['host'],
            },
            '-P'               => $db['port'],
            '-u'               => $db['username'],
            "-p'${_password}'" => if $db['password'] { '' } else { undef },
            '-D'               => $db['database'],
    })), ' ')
  }

  strip(regsubst("${options} ${tls_options}", '\s{2,}', ' '))
}
