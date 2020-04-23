require File.join(File.dirname(__FILE__), '../../..', 'puppet_x/icinga2/utils.rb')

module Puppet::Parser::Functions
  # @summary
  #   Wrapper for config parser
  #
  # @return
  #   Parsed config as string
  #
  newfunction(:icinga2_attributes, :type => :rvalue) do |args|
    raise Puppet::ParseError, 'icinga2_atributes(): Must provide at least one argument.' if args.length > 4 || args.length < 1

    if args[1]
      indent = args[1]
    else
      indent = 0
    end

    if args[2]
      globals = args[2].concat(lookupvar('::icinga2::_reserved'))
    else
      globals = lookupvar('::icinga2::_reserved')
    end

    if args[3]
      constants = args[3].merge(lookupvar('::icinga2::_constants'))
    else
      constants = lookupvar('::icinga2::_constants')
    end

    Puppet::Icinga2::Utils.attributes(args[0], globals, constants, indent)
  end
end
