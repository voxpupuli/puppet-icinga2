# @summary
#   This function parse icinga object attributes.

# @return
#   The parsed string.
#
function icinga2::parse(
  Hash[String, Any] $attrs,
  Integer           $indent    = 0,
  Array[String]     $reserved  = [],
  Hash[String, Any] $constants = {},
) {
  # @param attr
  #   Object attributes to parse.
  #
  # @param indent
  #   Indent to use.
  #
  # @param reserved
  #   A list of addational reserved words.
  #
  # @param constants
  #   A hash of additional constants.
  #
  icinga2::icinga2_attributes(
    $attrs,
    concat($::icinga2::globals::reserved, $reserved),
    merge($::icinga2::_constants, $constants),
    $indent
  )
}
