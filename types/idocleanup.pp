# A type for the structure of settings to cleanup IDO databases
type Icinga2::IdoCleanup = Hash[
  Enum[
    'acknowledgements_age',
    'commenthistory_age',
    'contactnotifications_age',
    'contactnotificationmethods_age',
    'downtimehistory_age',
    'eventhandlers_age',
    'externalcommands_age',
    'flappinghistory_age',
    'hostchecks_age',
    'logentries_age',
    'notifications_age',
    'processevents_age',
    'statehistory_age',
    'servicechecks_age',
    'systemcommands_age',
  ], String]
