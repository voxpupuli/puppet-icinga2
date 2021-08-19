require File.join(File.dirname(__FILE__), '../../..', 'puppet_x/icinga2/utils.rb')

module Puppet::Parser::Functions
  # @summary
  #   Wrapper for config parser
  #
  # @return
  #   Parsed config as string
  #
  newfunction(:icinga2_attributes, type: :rvalue) do |args|
    raise Puppet::ParseError, 'icinga2_atributes(): Must provide at least one argument.' if args.length > 4 || args.empty?

    indent = if args[1]
               args[1]
             else
               0
             end

    globals = if args[2]
                args[2].concat(lookupvar('::icinga2::_reserved'))
              else
                lookupvar('::icinga2::_reserved')
              end

    constants = if args[3]
                  args[3].merge(lookupvar('::icinga2::_constants'))
                else
                  lookupvar('::icinga2::_constants')
                end

    Puppet::Icinga2::Utils.attributes(args[0], globals, constants, indent)
  end
end
