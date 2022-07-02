require 'base64'
require 'facter'

Facter.add('icinga2_version') do
  confine kernel: ['Linux', 'windows']

  setcode do
    icinga2_list = []
    icinga2_hash = {}

    # this should be cached somehow
    Dir['/**/icinga2', 'c:/**/icinga2.exe'].each do |file|
      icinga2_list << file if File.executable?(file) && File.file?(file)
    end

    icinga2_list.each do |icinga2|
      if Facter.value(:kernel) == 'windows'
        # base64 encode powershell command to escape some nasty quoting issues
        # split and rebuild path. Dir returns pathes like c:/some app/app.exe
        # and we need to reformat this to c:"\some app\app.exe"
        # so we have backslashes for windows path and quoting to escape all spaces in the pathes
        cmd         = "#{icinga2.split(':').first}:\"#{icinga2.split(':').last.tr('/', '\\')}\" -V"
        encoded_cmd = Base64.strict_encode64(cmd.encode('utf-16le'))
        exec_out = Facter::Core::Execution.execute("powershell -encodedCommand #{encoded_cmd} 2>&1")
      else
        exec_out = Facter::Core::Execution.execute("#{icinga2} -V 2>&1")
      end

      # use first line, spilt on colon, remove r from version for linux, v for windows and closing braket from output
      icinga2_hash[icinga2] = exec_out.lines.grep(%r{version}).first.split(':').last.delete('vr)').strip
    end

    # if we have only one bin, just give the version back
    # else give a hash with the path to bin as key and version as value
    if icinga2_hash.keys.count < 2
      _key, value = icinga2_hash.first
      value
    else
      icinga2_hash
    end
  end
end
