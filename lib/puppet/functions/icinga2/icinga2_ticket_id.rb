require_relative '../../../puppet_x/icinga2/pbkdf2.rb'

# @summary
#   Summarise what the function does here
#
Puppet::Functions.create_function(:'icinga2::icinga2_ticket_id') do
  # @param cn
  #   The common name of the Icinga host certificate.
  #
  # @param salt
  #   The ticket salt of the Icinga CA.
  #
  # @return [String]
  #   Calculated ticket to receive a certificate.
  #
  dispatch :ticket do
    required_param 'String', :cn
    required_param 'Variant[String, Sensitive[String]]', :salt
    return_type 'String'
  end

  def ticket(cn, salt)
    if salt.is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive)
      salt = salt.unwrap
    end

    PBKDF2.new(
      password: cn,
      salt: salt,
      iterations: 50_000,
      hash_function: OpenSSL::Digest.new('sha1'),
    ).hex_string
  end
end
