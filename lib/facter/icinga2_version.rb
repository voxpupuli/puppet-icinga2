Facter.add('icinga2_version') do
  confine { Facter::Core::Execution.which('icinga2') }
  confine kernel: 'linux'
  setcode do
    icinga2_ver = Facter::Core::Execution.execute("icinga2 -V|grep -E 'icinga2.+version: (v|r)?'")
    icinga2_ver.match(%r{\d+\.\d+\.\d+})[0] if icinga2_ver
  end
end

Facter.add('icinga2_version') do
  confine kernel: 'windows'
  setcode do
    tmp = Facter::Core::Execution.which('icinga2.exe')
    file = if tmp
             tmp
           else
             'C:/Program Files/ICINGA2/sbin/icinga2.exe'
           end
    cmd  = "#{file.split(':').first}:\"#{file.split(':').last.tr('/', '\\')}\" -V 2>&1"
    Facter::Core::Execution.execute("cmd /C #{cmd}").lines.grep(%r{version: (r|v)?\d+\.\d+\d+}).first.split(':').last.delete('vr)').strip if File.executable?(file)
  end
end
