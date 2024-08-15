# A strict type for basic authentication
type Icinga2::BasicAuth = Struct[{
    'username' => String[1],
    'password' => Variant[String[1], Sensitive[String[1]]],
}]
