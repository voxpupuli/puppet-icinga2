require 'puppet'

module Puppet
  module Icinga2
    module Utils


      def self.attributes(attrs, consts, indent=2)

        def self.value_types(value)
          if value =~ /^\d+\.?\d*[d|h|m|s]?$/ || value =~ /^(true|false)$/
            result = value
          else
            if $constants.include?(value) || value =~ /^!?(host|service|user)\./ || value =~ /^{{.*}}$/
              result = value
            else
              result = "\"#{value}\""
            end
          end

          return result
        end


        def self.attribute_types(attr)
          if attr =~ /^[a-zA-Z0-9_]+$/
            result = attr
          else
            result = "\"#{attr}\""
          end

          return result
        end


        def self.parse(row)
          result = ''

          if row =~ /^(.+)\s([\+-]|\*|\/|==|!=|&&|\|{2}|in)\s(.+)$/
            result += "%s %s %s" % [ parse($1), $2, parse($3) ]
          else
            # fct(a, b)
            #if row =~ /^(.+)\((.*)\)$/
            #  result += "%s(%s)" % [ $1, $2.split(',').map {|x| parse(x.lstrip)}.join(', ') ]
            # fct(a, b + ...
            if row =~ /^(.+)\((.*)$/
              result += "%s(%s" % [ $1, $2.split(',').map {|x| parse(x.lstrip)}.join(', ') ]
            elsif row =~ /^(.*)\)$/
              result += "%s)" % [ $1.split(',').map {|x| parse(x.lstrip)}.join(', ') ]
            # (a + b)
            elsif row =~ /^\((.*)$/
              result += "(%s" % [ parse($1) ]
            # (a + b)
            #elsif row =~ /^(.*)\)$/
            #  result += "%s)" % [ parse($1) ]
            else
              result += value_types(row.to_s)
            end
          end

          return result.gsub(/" in "/, ' in ')
        end


        def self.process_array(items, indent=2)
          result = ''

          items.each do |value|
            if value.is_a?(Hash)
              result += "\n%s{\n%s%s}, " % [ ' ' * indent, process_hash(value, indent + 2), ' ' * indent ]
            elsif value.is_a?(Array)
              result += "[ %s], " % [ process_array(value, indent+2) ]
            else
              result += "%s, " % [ parse(value) ] if value != :undef
            end
          end

          return result
        end


        def self.process_hash(attrs, indent=2, level=3, prefix=' '*indent)
          result = ''

          attrs.each do |attr, value|
            if value.is_a?(Hash)
              result += case level
                when 1 then process_hash(value, indent, 2, "%s%s" % [ prefix, attr ])
                when 2 then "%s[\"%s\"] = {\n%s%s}\n" % [ prefix, attr, process_hash(value, indent), ' ' * (indent-2) ]
                else "%s%s = {\n%s%s}\n" % [ prefix, attribute_types(attr), process_hash(value, indent+2), ' ' * indent ]
              end
            elsif value.is_a?(Array)
              result += "%s%s = [ %s]\n" % [ prefix, attribute_types(attr), process_array(value) ]
            else
              if level > 1
                if level == 3
                  result += "%s%s = %s\n" % [ prefix, attribute_types(attr), parse(value) ] if value != :undef
                else
                  result += "%s[\"%s\"] = %s\n" % [ prefix, attribute_types(attr), parse(value) ] if value != :undef
                end
              else
                result += "%s%s = %s\n" % [ prefix, attr, parse(value) ] if value != :undef
              end
            end
          end

          return result
        end


        # globals (params.pp) and all keys of attrs hash itselfs must not quoted
        $constants = consts.concat(attrs.keys) << "name"
        # also with added not operetor '!'
        $constants += $constants.map {|x| "!#{x}"}

        # initialize returned configuration
        config = ''

        attrs.each do |attr, value|
          if attr =~ /^(assign|ignore) where$/
            value.each do |x|
              config += "%s%s %s\n" % [ ' ' * indent, attr, parse(x) ]
            end
          else
            if value.is_a?(Hash)
              if ['vars'].include?(attr)
                config += process_hash(value, indent+2, 1, "%s%s." % [ ' ' * indent, attr])
              else
                config += "%s%s = {\n%s%s}\n" % [ ' ' * indent, attr, process_hash(value, indent+2), ' ' * indent ]
              end
            elsif value.is_a?(Array)
              config += "%s%s = [ %s]\n" % [ ' ' * indent, attr, process_array(value) ]
            else
              config += "%s%s = %s\n" % [ ' ' * indent, attr, parse(value) ] if value != :undef
            end
          end
        end

        return config
      end

    end
  end
end
