
module Puppet::Parser::Functions
  newfunction(:icinga2_ticket_custom_id, :type => :rvalue) do |args|
    raise Puppet::ParseError, 'Must provide exactly two arguments to icinga2_ticket_id' if args.length != 2

    if !args[0] or args[0] == ''
      raise Puppet::ParseError, 'first argument (cn) can not be empty for icinga2_ticket_id'
    end
    if !args[1] or args[1] == ''
      raise Puppet::ParseError, 'second argument (salt) can not be empty for icinga2_ticket_id'
    end
  
    value = %x[ sudo /usr/sbin/icinga2 pki ticket --cn #{args[0]} 2>&1 ] 
    value.chomp()
  end
end
