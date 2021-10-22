include icinga2

class { '::icinga2::feature::elasticsearch':
  password => Sensitive('super(secret'),
}
