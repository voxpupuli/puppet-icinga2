# Type for certificate fingerprints
type Icinga2::Fingerprint = Pattern[/^([0-9a-fA-F]{2}\:){19}(([0-9a-fA-F]{2}\:){12})?[0-9a-fA-F]{2}$/]
