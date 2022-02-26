file { '/etc/mysql':
  ensure => directory,
}

file { '/etc/mysql/cacert.pem':
  ensure  => file,
  content => '-----BEGIN CERTIFICATE-----
MIIDUzCCAjugAwIBAgIJANSq2QtWyTjcMA0GCSqGSIb3DQEBCwUAMEAxCzAJBgNV
BAYTAkRFMQwwCgYDVQQIDANCYXkxEjAQBgNVBAcMCU51cmVtYmVyZzEPMA0GA1UE
CgwGSUNJTkdBMB4XDTE5MDIxMjE1MDE0OFoXDTIyMDIxMTE1MDE0OFowQDELMAkG
A1UEBhMCREUxDDAKBgNVBAgMA0JheTESMBAGA1UEBwwJTnVyZW1iZXJnMQ8wDQYD
VQQKDAZJQ0lOR0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDDj7Vf
9aykh1a5dgjZXfO7Me8cLAFOIMwRwdexY6w7lvZu0IMQJIzkBi3LRM+vwn0Db8tP
+If7598gFYh40ogshTFaIK8QSii1Q9P6x5I44R4FvHvSiI+73dsGyG0SiSnxEF+e
Y5Wi5mDY9iJFFKGe7bqF52VojuXAljQm+9KAyfELShFVQ8cO+K5Wg39z5GwcgdHI
Yf0el2xkzoDIgU7vtQ6YX8RgELCmEHRyZb3UBTKJ3wlI1q3VmxCDGEVGkBnVdKFE
bagpalUecI+G+Id2TNj71c2CKreF8hEmlbp1mW06/Sm8BpK4/vQfgUBwKn1biFlz
3sRCVdIbpjxnyIE/AgMBAAGjUDBOMB0GA1UdDgQWBBRHSaJKlC7NqIhg6XgDAMj9
95EkgDAfBgNVHSMEGDAWgBRHSaJKlC7NqIhg6XgDAMj995EkgDAMBgNVHRMEBTAD
AQH/MA0GCSqGSIb3DQEBCwUAA4IBAQCuVmrbL6CXt/F1HYbEMIqKCHDs3jcaQrti
PkVQFFC6EYEcv/TXE9tvH94ohMV8rs8EN/8dFfylTT3yntpwbeXubl6NYDNYBjhM
kUDujVEzKU1+Bt2KLlUIrJ6MxRjJ9firAOQ8qc2YilTFs4k+VjNaaVE4GbBFncJ+
ucIsXTOue0I6X0QJb+0GU3v90k2I+cISEGGsEQcR+0JI6b6eJ4/IxOEiKgdaAbYa
uwRWzHVoISNlZGfoaH3iFrg62zdZYqK6gKCSgrgVWsJqDq4G/hTWWw5h56zVX8e0
Bs3EbV7Yqdxw/5noROP2oF4uaZoZhb6heZneF7u6kpbZxXkfmKot
-----END CERTIFICATE-----',
}

file { '/etc/mysql/server-key.pem':
  ensure  => file,
  content => '-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA9bftj7SJfMpBqk7eza3I1Tp4n3VbjkEo7pq9ft6hCpSHaThN
OU362GyeLawZNTCtROePj3g2StB3UFQTGRe5Xbl510UaoRwSpHnUSTaDfjPeT8SX
GTtViQiXuLptPui4HoLXl4E2QC6kFm/QA2wy+bnJ0l3OLio6PwuXqQuz/p26gjrb
0hpIUSvjRMoaYLqSCVhasL48dboeVBiCyPBhH46gEDFi3usvMIHvXknCrwCglF7u
xVXO7B1K4OSHeGnwk/K/HZr+qg49Dvsuet2reVZhhks9UWX7Eipujqd8VbdGnaL6
yOm2I0hRHl5PDW7K7jsFKXHtOhJLdPrdVwgUtQIDAQABAoIBAQCsr4iLGAwP4Wzo
rekzj1C3WhJvrmCbxvtnROSsBvYSo3PO5LyQ61bBRwSbgHluwjjjVgG0iH1PctaH
Y67QUbX6QmF4gp5GX55SbTReB6u9w+IXGUg/eU2RsrI+Jvaj4ZWUC8xMM4jW7nBv
PEFqRl5E1ucZqsc99ntc117MdOcYpoxbOlWjmR82kpH645vLulJ5MisoE0ownTfw
AbsyuyjG6/a56iUMmDzMM1SaoEoEtKLMEjEq2dFD4gj+LyA7TBpFP4ookRyfvVqR
cIb2HGJercyYEDsOTrKKeN+odNkMswOA+fjjexCohivEY29EdqzePBFT05l0hqhj
Dz7Snz6BAoGBAP8Eiku7me0Yi3LoTwpuGx/FBw7EUl3/CYFRlMbQTzoj24w+YYR9
CVaoDSuXhBxf9KOIjqcqjtfJS2vmXOGyd/fM36ANbKmvmzCPGEYHNmroeX7Bqyrr
GHCpwhdwKIqbxKeVmfNaHworj7COYGLZdbwxc0rms+NnREiEp++d0NkRAoGBAPaq
N934Szn5Q6tZFNT3vFkRkUq14blKdgEmnIc+U9RGzx1vms3+HccfTiF3QzHkYZOX
hOz9JuvxhbrTqo0A5MpFKH2KgpZ4tbZXyImi5AAyJmcZQtfm69Vv6hcl2iVl4pFn
GDyu948fclj7EdWGreoPLlWlh18vjGLdKUmDM2FlAoGAVwPblH/Mw+PuISU3Yx2y
z6JRCC7g1AXj3mZR14zYm8QEc9QNPkHT3+ezpr4qa+wp82rzEgMpfmPHAmg2JSTa
XolffKNYAoZS87y/0ZVAcjYkzqWSnDBfxIGIIqs4iiMgdPZM84Y6tSOsAdhy9wew
bqiI6HPTybJA0GXDT7WPv6ECgYBUOLCUqNe+tr6FPghf4yq7WsU6NjoZUzRRlkZx
4zUqUPcc/ONlnHO8bpL12EvoOCudAmpPpOxqOXBI50bfmEOGUPDPVMDb8eFRnk2J
uUWST41PPI/XOjCiEvFh7/m5NT2UGhhrd+5tPvaDLU7cknzFY2OVuMwtEwYjJ5KW
WCbuBQKBgQDXIDVOHGEYG1Rii+qNQBJwTwfnMcpCzm+FD3B91AFtLQlZMOWsWqT9
nh0c2NOM2YaGl1J0/WUnzsg7ZDMY6S9zQQ/KZP6LVm4P5yn3k8h8B9FL13a9AK83
89RotRTzKPEAh7SjI84GAVUn6BcxsrVroe3p45E9KpX1bgYCkvu45Q==
-----END RSA PRIVATE KEY-----',
}

file { '/etc/mysql/server-cert.pem':
  ensure  => file,
  content => '-----BEGIN CERTIFICATE-----
MIIDBjCCAe4CAQEwDQYJKoZIhvcNAQELBQAwQDELMAkGA1UEBhMCREUxDDAKBgNV
BAgMA0JheTESMBAGA1UEBwwJTnVyZW1iZXJnMQ8wDQYDVQQKDAZJQ0lOR0EwHhcN
MTkwMjEyMTUwMzA2WhcNMjIwMjExMTUwMzA2WjBSMQswCQYDVQQGEwJERTEMMAoG
A1UECAwDQmF5MRIwEAYDVQQHDAlOdXJlbWJlcmcxDzANBgNVBAoMBklDSU5HQTEQ
MA4GA1UEAwwHY2VudG9zNzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
APW37Y+0iXzKQapO3s2tyNU6eJ91W45BKO6avX7eoQqUh2k4TTlN+thsni2sGTUw
rUTnj494NkrQd1BUExkXuV25eddFGqEcEqR51Ek2g34z3k/Elxk7VYkIl7i6bT7o
uB6C15eBNkAupBZv0ANsMvm5ydJdzi4qOj8Ll6kLs/6duoI629IaSFEr40TKGmC6
kglYWrC+PHW6HlQYgsjwYR+OoBAxYt7rLzCB715Jwq8AoJRe7sVVzuwdSuDkh3hp
8JPyvx2a/qoOPQ77Lnrdq3lWYYZLPVFl+xIqbo6nfFW3Rp2i+sjptiNIUR5eTw1u
yu47BSlx7ToSS3T63VcIFLUCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAoyPSTcOx
EeZtK0W7zrgiaF1cTxMZ7hoUzprim1ruppcoCYfm0ME5omilE1AKGruw/tN9aJB3
CBFm0fB98ZT2v73lYDX99hb8lE2sAJXeM8QA80vOKQ/qwpCO/pVpydlu5MSCXbIe
CgJFa73pp7WVjsnbH1LmbrldFMsOOEUEHL06kgdY0YSHWeZ4/mhP142WHG8VcIJM
Ce9k+yRhc9MBvHPCBAIRSdpi9CNh0ABPunHurtw6s1Kmnne10duCCYEACebHmfEj
ew5H/BZONAQpUuOkN5LerCj7NfMurqMMePOp+hFM97t0vOX02BzOeYGO3Fp0TGk/
eKnWdHh+iX5B8g==
-----END CERTIFICATE-----',
}

class { 'mysql::server':
  override_options => {
    mysqld => {
      ssl => true,
    },
  }
}

mysql::db { 'icinga':
  user        => 'icinga',
  password    => 'supersecret',
  host        => 'localhost',
  grant       => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'INDEX', 'EXECUTE', 'ALTER'],
  tls_options => [ 'X509' ],
}

class { '::icinga2':
  manage_repos => true,
}

class{ '::icinga2::feature::idomysql':
  user            => 'icinga',
  password        => 'supersecret',
  database        => 'icinga',
  import_schema   => $::mysql::params::provider,
  enable_ssl      => true,
  ssl_key_path    => '/etc/mysql/server-key.pem',
  ssl_cert_path   => '/etc/mysql/server-cert.pem',
  ssl_cacert_path => '/etc/mysql/cacert.pem',
  require         => Mysql::Db['icinga'],
}

