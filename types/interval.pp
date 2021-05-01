# A strict type for intervals
type Icinga2::Interval = Variant[Integer, Pattern[/^\d+\.?\d*[d|h|m|s]?$/]]
