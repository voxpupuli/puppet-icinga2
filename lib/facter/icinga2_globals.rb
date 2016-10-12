Facter.add('icinga2_globals') do
  setcode do
    Facter::Core::Execution.exec("icinga2 console -e 'var res = []; for (k => v in globals) { res.add(k) }; res'").sub(/^\[(.*)\]$/, '\1').delete('"')
  end
end
