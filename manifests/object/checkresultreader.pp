# @summary
#   Manage Icinga 2 CheckResultReader objects.
#
# @param ensure
#   Set to present enables the object, absent disables it.
#
# @param checkresultreader_name
#   Set the Icinga 2 name of the ceckresultreader object.
#
# @param spool_dir
#   The directory which contains the check result files.
#
# @param target
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# @param order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
define icinga2::object::checkresultreader (
  Stdlib::Absolutepath               $target,
  Enum['absent', 'present']          $ensure                 = present,
  String                             $checkresultreader_name = $title,
  Optional[Stdlib::Absolutepath]     $spool_dir              = undef,
  Variant[String, Integer]           $order                  = '05',
){

  # compose the attributes
  $attrs = {
    'spool_dir'   => $spool_dir,
  }

  # create object
  icinga2::object { "icinga2::object::CheckResultReader::${title}":
    ensure      => $ensure,
    object_name => $checkresultreader_name,
    object_type => 'CheckResultReader',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => $target,
    order       => $order,
  }

  # import library
  concat::fragment { "icinga2::object::CheckResultReader::${title}-library":
    target  => $target,
    content => "library \"compat\"\n\n",
    order   => $order,
  }
}
