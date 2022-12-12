# @summary
#   Replace newlines for Windows systems.
#
# @return
#    Text with correct newlines.
#
function icinga2::newline(
  Optional[String] $text,
) >> String {
  # @param text
  #   Text to replace the newlines.
  #

  if $text {
    $result = if $facts['os']['family'] != 'windows' {
      $text
    } else {
      regsubst($text, '\n', "\r\n", 'EMG')
    }
  } else {
    $result = undef
  }

  return $result
}
