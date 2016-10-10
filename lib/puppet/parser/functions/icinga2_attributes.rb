require File.join(File.dirname(__FILE__), '../..', 'icinga2/utils.rb')

module Puppet::Parser::Functions
  newfunction(:icinga2_attributes, :type => :rvalue) do |args|
    raise Puppet::ParseError, 'Must provide exactly one argument.' if args.length != 1

    Puppet::Icinga2::Utils.attributes(args[0], lookupvar('icinga2::_constants').keys.concat(lookupvar('icinga2::params::globals')))
  end
end
