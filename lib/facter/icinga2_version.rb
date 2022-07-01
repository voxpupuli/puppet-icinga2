Facter.add('icinga2_version') do
  confine { Facter::Core::Execution.which('icinga2') }
  setcode do
    icinga2_ver = Facter::Core::Execution.execute("icinga2 -V|grep 'version: r'")
    icinga2_ver.match(%r{\d+\.\d+\.\d+})[0] if icinga2_ver
  end
end
