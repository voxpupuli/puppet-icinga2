# A strict type for basic authentication
type Icinga2::BasicAuth = Struct[{
  'username' => String,
  'password' => Variant[String, Sensitive[String]],
}]
