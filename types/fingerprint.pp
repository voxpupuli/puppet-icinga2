# Type for certificate fingerprints
type Icinga2::Fingerprint = Pattern[/^([0-9a-fA-F]{2}\:){19}[0-9,a-f,A-F]{2}$/]
