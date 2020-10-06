# Type for certificate fingerprints
# SHA1: 160 bit (20 byte) digest
# SHA256: 256 bit (32 byte) digest
type Icinga2::Fingerprint = Pattern[/^([0-9a-fA-F]{2}\:){19}(([0-9a-fA-F]{2}\:){12})?[0-9a-fA-F]{2}$/]

