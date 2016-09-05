include icinga2
icinga2::feature { 'debuglog': }
icinga2::feature { 'notification': ensure => absent }
