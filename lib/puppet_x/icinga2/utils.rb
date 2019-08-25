# == Helper function attributes
#
# Returns formatted attributes for objects as strings.
#
# === Common Explanation:
#
# To generate a valid Icinga 2 configuration all object attributes are parsed. This
# simple parsing algorithm takes a decision for each attribute, whether part of the
# string is to be quoted or not, and how an array or dictionary is to be formatted.
#
# Parsing of a single attribute can be disabled by tagging it with -: at the front
# of the string.
#
#   attr => '-:"unparsed string with quotes"'
#
# An array, a hash or a string can be assigned to an object attribute. True and false
# are also valid values.
#
# Hashes and arrays are created recursively, and all parts – such as single items of an array,
# keys and its values – are parsed separately as strings.
#
# Strings are parsed in chunks, by splitting the original string into separate substrings
# at specific keywords (operators) such as +, -, in, &&, ||, etc.
#
# NOTICE: This splitting only works for keywords that are surrounded by whitespace, e.g.:
#
#   attr => 'string1 + string2 - string3'
#
# The algorithm will loop over the parameter and start by splitting it into 'string1' and 'string2 - string3'.
# 'string1' will be passed to the sub function 'value_types' and then the algorithm will continue parsing
# the rest of the string ('string2 - string3'), splitting it, passing it to value_types, etc.
#
# Brackets are parsed for expressions:
#
#   attr => '3 * (value1 - value2) / 2'
#
# The parser also detects function calls and will parse all parameters separately.
#
#   attr => 'function(param1, param2, ...)'
#
# True and false can be used as either booleans or strings.
#
#   attrs => true or  attr => 'true'
#
# In Icinga you can write your own lambda functions with {{ ... }}. For puppet use:
#
#   attrs => '{{ ... }}'
#
# The parser analyzes which parts of the string have to be quoted and which do not.
#
# As a general rule, all fragments are quoted except for the following:
#
#   - boolean: true, false
#   - numbers: 3 or 2.5
#   - time intervals: 3m or 2.5h  (s = seconds, m = minutes, h = hours, d = days)
#   - functions: {{ ... }} or function () {}
#   - all constants, which are declared in the constants parameter in main class icinga2:
#       NodeName
#   - names of attributes that belong to the same type of object:
#       e.g. name and check_command for a host object
#   - all attributes or variables (custom attributes) from the host, service or user contexts:
#       host.name, service.check_command, user.groups, ...
#
# Assignment with += and -=:
# 
# Now it's possible to build an Icinga DSL code snippet like
#
#  vars += config
#
# simply use a string with the prefix '+ ', e.g.
#
#  vars => '+ config',
#
# The blank between + and the proper string 'config' is imported for the parser because numbers
#
#   attr => '+ -14',
#
# are also possible now. For numbers -= can be built, too:
#
#   attr => '- -14', 
# 
# Arrays can also be marked to merge with '+' or reduce by '-' as the first item of the array:
#
#   attr => [ '+', item1, item2, ... ]
#
# Result: attr += [ item1, item2, ... ]
#
#   attr => [ '-' item1, item2, ... ]
#
# Result: attr -= [ item1, item2, ... ]
#
# That all works for attributes and custom attributes!
#
# Finally dictionaries can be merged when a key '+' is set:
#
#   attr => {
#     '+'    => true,
#     'key1' => 'val1',
#   }
#
# Result:
#
#   attr += {
#     "key1" = "val1"
#   }
#
# If 'attr' is a custom attribute this just works since level 3 of the dictionary:
#
#   vars => {
#     'level1' => {
#       'level2' => {
#         'level3' => {
#           '+' => true,
#           ...
#         },
#       },
#     },
#   },
#
# Parsed to:
#
#   vars.level1["level2"] += level3
#
# Now it's also possible to add multiple custom attributes:
#
#   vars => [
#     {
#       'a' => '1',
#       'b' => '2',
#     },
#     'config',
#     {
#       'c' => {
#         'd' => {
#           '+' => true,
#           'e' => '5',
#         },
#       },
#     },
#   ],
#
# And you'll get:
#
#   vars.a = "1"
#   vars.b = "2"
#   vars += config
#   vars.c["d"] += {
#     "e" = "5"
#   }
#
# Note: Using an Array always means merge '+=' all items to vars.
#
# === What isn't supported?
#
# It's not currently possible to use dictionaries in a string WITH nested array or hash, like
#
#   attr1 => 'hash1 + { item1 => value1, item2 => [ value1, value2 ], ... ]'
#   attr2 => 'hash2 + { item1 => value1, item2 => { ... },... }'
#
#
require 'puppet'

module Puppet
  module Icinga2
    module Utils

      def self.attributes(attrs, globals, consts, indent=2)

        def self.value_types(value)

          if value =~ /^-?\d+\.?\d*[dhms]?$/ || value =~ /^(true|false|null)$/ || value =~ /^!?(host|service|user)\./ || value =~ /^\{{2}.*\}{2}$/
            result = value
          else
            if $constants.index { |x| if $hash_attrs.include?(x) then value =~ /^!?(#{x})(\..+$|$)/ else value =~ /^!?#{x}$/ end }
              result = value
            else
              result = value.dump
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

          # parser is disabled
          if row =~ /^-:(.*)$/m
            return $1
          end

          if row =~ /^\{{2}(.+)\}{2}$/m
            # scan function
            result += "{{%s}}" % [ $1 ]
          elsif row =~ /^(.+)\s([\+-]|\*|\/|==|!=|&&|\|{2}|in)\s\{{2}(.+)\}{2}$/m
            # scan expression + function (function should contain expressions, but we donno parse it)
            result += "%s %s {{%s}}" % [ parse($1), $2, $3 ]
          elsif row =~ /^(.+)\s([\+-]|\*|\/|==|!=|&&|\|{2}|in)\s(.+)$/
            # scan expression
            result += "%s %s %s" % [ parse($1), $2, parse($3) ]
          else
            if row =~ /^(.+)\((.*)$/
              result += "%s(%s" % [ $1, $2.split(',').map {|x| parse(x.lstrip)}.join(', ') ]
            elsif row =~ /^(.*)\)(.+)?$/
              # closing bracket ) with optional access of an attribute e.g. '.arguments'
              result += "%s)%s" % [ $1.split(',').map {|x| parse(x.lstrip)}.join(', '), $2 ]
            elsif row =~ /^\((.*)$/
              result += "(%s" % [ parse($1) ]
            elsif row =~ /^\s*\[\s*(.*)\s*\]\s?(.+)?$/
              # parse array
              result += "[ %s]" % [ process_array($1.split(',')) ]
              result += " %s" % [ parse($2) ] if $2
            elsif row =~ /^\s*\{\s*(.*)\s*\}\s?(.+)?$/
              # parse hash
              result += "{\n%s}" % [ process_hash(Hash[$1.gsub(/\s*=>\s*|\s*,\s*/, ',').split(',').each_slice(2).to_a]) ]
              result += " %s" % [ parse($2) ] if $2
            else
              result += value_types(row.to_s.strip)
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
              result += "%s, " % [ parse(value) ] if value
            end
          end

          return result
        end


        def self.process_hash(attrs, indent=2, level=3, prefix=' '*indent)
          result = ''
          attrs.each do |attr, value|
            if value.is_a?(Hash)
              op = '+' if value.delete('+')
              if value.empty?
                result += case level
                  when 1 then "%s%s #{op}= {}\n" % [ prefix, attribute_types(attr) ]
                  when 2 then "%s[\"%s\"] #{op}= {}\n" % [ prefix, attr ]
                  else "%s%s #{op}= {}\n" % [ prefix, attribute_types(attr) ]
                end
              else
                result += case level
                  when 1 then process_hash(value, indent, 2, "%s%s" % [ prefix, attr ])
                  when 2 then "%s[\"%s\"] #{op}= {\n%s%s}\n" % [ prefix, attr, process_hash(value, indent), ' ' * (indent-2) ]
                  else "%s%s #{op}= {\n%s%s}\n" % [ prefix, attribute_types(attr), process_hash(value, indent+2), ' ' * indent ]
                end
              end
            elsif value.is_a?(Array)
              op = value.delete_at(0) if value[0] == '+' or value[0] == '-'
              result += case level
                when 2 then "%s[\"%s\"] #{op}= [ %s]\n" % [ prefix, attribute_types(attr), process_array(value) ]
                else "%s%s #{op}= [ %s]\n" % [ prefix, attribute_types(attr), process_array(value) ]
              end
            else
              # String: attr = '+ value' -> attr += 'value'
              if value =~ /^([\+,-])\s+/
                operator = "#{$1}="
                value = value.sub(/^[\+,-]\s+/, '')
              else
                operator = '='
              end
              if level > 1
                if level == 3
                  result += "%s%s #{operator} %s\n" % [ prefix, attribute_types(attr), parse(value) ] if value != :nil
                else
                  result += "%s[\"%s\"] #{operator} %s\n" % [ prefix, attr, parse(value) ] if value != :nil
                end
              else
                result += "%s%s #{operator} %s\n" % [ prefix, attr, parse(value) ] if value != :nil
              end
            end
          end

          return result
        end


        # globals (params.pp) and all keys of attrs hash itselfs must not quoted
        $constants = globals.concat(consts.keys) << "name"

        # select all attributes and constants if there value is a hash
        $hash_attrs = attrs.merge(consts).select { |x,y| y.is_a?(Hash) }.keys

        # initialize returned configuration
        config = ''

        attrs.each do |attr, value|

          if attr =~ /^(assign|ignore) where$/
            value.each do |x|
              config += "%s%s %s\n" % [ ' ' * indent, attr, parse(x) ] if x
            end
          elsif attr == 'vars'
            if value.is_a?(Hash)
              # delete pair of key '+' because a merge at this point is not allowed
              value.delete('+')
              config += process_hash(value, indent+2, 1, "%s%s." % [ ' ' * indent, attr])
            elsif value.is_a?(Array)
              value.each do |item|
                if item.is_a?(String)
                  config += "%s%s += %s\n" % [ ' ' * indent, attr, item.sub(/^[\+,-]\s+/, '') ]
                else
                  item.delete('+')
                  if item.empty?
                    config += "%s%s += {}\n" % [ ' ' * indent, attr]
                  else
                    config += process_hash(item, indent+2, 1, "%s%s." % [ ' ' * indent, attr])
                  end
                end
              end
            else
              op = '+' if value =~ /^\+\s+/
              config += "%s%s #{op}= %s\n" % [ ' ' * indent, attr, parse(value.sub(/^\+\s+/, '')) ]
            end
          else
            if value.is_a?(Hash)
              op = '+' if value.delete('+')
              unless value.empty?
                config += "%s%s #{op}= {\n%s%s}\n" % [ ' ' * indent, attr, process_hash(value, indent+2), ' ' * indent ]
              else
                config += "%s%s #{op}= {}\n" % [ ' ' * indent, attr ]
              end
            elsif value.is_a?(Array)
              op = value.delete_at(0) if value[0] == '+' or value[0] == '-'
              config += "%s%s #{op}= [ %s]\n" % [ ' ' * indent, attr, process_array(value) ]
            else
              # String: attr = '+config' -> attr += config 
              if value =~ /^([\+,-])\s+/
                config += "%s%s #{$1}= %s\n" % [ ' ' * indent, attr, parse(value.sub(/^[\+,-]\s+/, '')) ]
              else
                config += "%s%s = %s\n" % [ ' ' * indent, attr, parse(value) ]
              end
            end
          end
        end

        return config
      end

    end
  end
end
