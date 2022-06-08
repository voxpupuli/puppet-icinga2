# @summary DEPRECATED.  Use the namespaced function [`icinga2::icinga2_ticket_id`](#icinga2_ticket_id) instead.
Puppet::Functions.create_function(:icinga2_ticket_id) do
  # @param args
  #   The original array of arguments.
  #
  # @return [String]
  #   Calculated ticket to receive a certificate.
  #
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'icinga2_ticket_id', 'This method is deprecated, please use icinga2::icinga2_ticket_id instead.')
    call_function('icinga2::icinga2_ticket_id', *args)
  end
end
