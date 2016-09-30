require 'facter'

Puppet.settings.preferred_run_mode= :agent

Facter.add(:icinga2_puppet_hostcert) do
  setcode do
    Puppet.settings[:hostcert]
  end
end

Facter.add(:icinga2_puppet_hostprivkey) do
  setcode do
    Puppet.settings[:hostprivkey]
  end
end

Facter.add(:icinga2_puppet_localcacert) do
  setcode do
    Puppet.settings[:localcacert]
  end
end
