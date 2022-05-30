# @summary DEPRECATED.  Use the namespaced function [`icinga2::attributes`](#attributes) instead.
Puppet::Functions.create_function(:icinga2_attributes) do
  # @param args
  #   The original array of arguments.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'icinga2_attributes', 'This method is deprecated, please use icinga2::attributes instead.')
    call_function('icinga2::attributes', *args)
  end
end
