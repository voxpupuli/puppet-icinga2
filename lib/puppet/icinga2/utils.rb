require 'puppet'

module Puppet
  module Icinga2
    module Utils


      def self.attributes(attrs, consts)

        def self.types(value)
          if value.is_a?(Integer) || value =~ /^\d+\.?\d*[d|h|m|s]?$/ || value.is_a?(TrueClass) || value.is_a?(FalseClass)
            result = value
          else
            if $constants.include?(value) || value =~ /^(host|service)\./ || value =~ /^{{.*}}$/
              result = value
            else
               result = "\"#{value}\""
            end
          end
          return result
        end

        def self.recurse(attrs, indent=2)
          result = ''
          if attrs.is_a?(Hash)
            attrs.each do |attr, value|
              txt = [ ' ' * indent, attr, recurse(value, indent+2), ' ' * indent ]
              if value.is_a?(Hash)
                result += "%s%s = {\n%s%s}\n" % txt
              elsif value.is_a?(Array)
                result += "%s%s = [ %s]\n" % txt
              else
                result += "%s%s = %s" % txt if value != :undef
              end
            end
          elsif attrs.is_a?(Array)
            attrs.each do |value|
              txt = [ ' ' * indent, recurse(value, indent+2), ' ' * indent ]
              if value.is_a?(Hash)
                result += "\n%s{\n%s%s}, " % txt
              elsif value.is_a?(Array)
                result += "[%s], " % [ recurse(value, indent+2) ]
              else
                result += "%s, " % [ types(value) ] if value != :undef
              end
            end
          else
            if attrs =~ /\s+\+\s+/
              result += "%s\n" % [ attrs.split(/\s+\+\s+/).map {|x| types(x)}.join(' + ') ]
            else
              result += "%s\n" % [ types(attrs) ]
            end
          end
          return result
        end

        $constants = consts.concat(attrs.keys)
        return recurse(attrs)
      end

    end
  end
end
