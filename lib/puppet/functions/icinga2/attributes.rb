require_relative '../../../puppet_x/icinga2/utils.rb'

# @summary
#   Calls the simple parser  to decide what to quote.
#   For more information, see lib/puppet_x/icinga2/utils.rb.
#
Puppet::Functions.create_function(:'icinga2::attributes') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end

  def default_impl(*args)
    raise Puppet::ParseError, 'icinga2::atributes(): Must provide at least one argument.' if args.length > 4 || args.empty?

    indent = if args[1]
               args[1]
             else
               0
             end

    globals = if args[2]
                closure_scope['::icinga2::_reserved'].concat(args[2])
              else
                closure_scope['::icinga2::_reserved']
              end

    constants = if args[3]
                  closure_scope['::icinga2::_constants'].merge(args[3])
                else
                  closure_scope['::icinga2::_constants']
                end

    PuppetX::Icinga2::Utils.attributes(args[0], globals, constants, indent)
  end
end
