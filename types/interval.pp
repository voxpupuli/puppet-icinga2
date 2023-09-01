# A strict type for intervals
type Icinga2::Interval = Variant[Integer, Pattern[/\A\d+\.?\d*[d|h|m|s]?\Z/, /\A\$.+\$\Z/]]
