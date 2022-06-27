require_relative '../../../puppet_x/icinga2/utils.rb'

# @summary
#   Calls the simple parser  to decide what to quote.
#   For more information, see lib/puppet_x/icinga2/utils.rb.
#
Puppet::Functions.create_function(:'icinga2::icinga2_attributes') do
  # @param attrs
  #   Object attributes to parse.
  #
  # @param globals
  #   A list of addational reserved words.
  #
  # @param constants
  #   A hash of additional constants.
  #
  # @return [String]
  #   Parsed attributes as String.
  #
  # @param indent
  #   Indent to use.
  #
  dispatch :icinga2_attributes do
    required_param 'Hash',    :attrs
    required_param 'Array',   :globals
    required_param 'Hash',    :constants
    optional_param 'Numeric', :indent
    return_type    'String'
  end

  def icinga2_attributes(attrs, globals, constants, indent = 0)
    Puppet::Icinga2::Utils.attributes(attrs, globals, constants, indent)
  end
end
