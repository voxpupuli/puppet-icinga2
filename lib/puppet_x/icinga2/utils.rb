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

module Puppet::Icinga2
  # Module: Utils with methods to parse Icinga 2 DSL config
  module Utils
    def self.value_types(value)
      if value.match?(%r{^(-?\d+\.?\d*[dhms]?|true|false|null|\{{2}.*\}{2})$|^!?(host|service|user)\.}) || @constants.index { |x| @hash_attrs.include?(x) ? value =~ %r{^!?(#{x})(\..+$|$)} : value =~ %r{^!?#{x}$} }
        value
      else
        value.dump
      end
    end

    def self.attribute_types(attr)
      if %r{^[a-zA-Z0-9_]+$}.match?(attr)
        attr
      else
        "\"#{attr}\""
      end
    end

    def self.parse(row)
      result = ''

      # parser is disabled
      if row =~ %r{^-:(.*)$}m
        return Regexp.last_match(1)
      end

      if row =~ %r{^\{{2}(.+)\}{2}$}m
        # scan function
        result += '{{%{expr}}}' % { expr: Regexp.last_match(1) }
      elsif row =~ %r{^(.+)\s([\+-]|\*|\/|==|!=|&&|\|{2}|in)\s\{{2}(.+)\}{2}$}m
        # scan expression + function (function should contain expressions, but we donno parse it)
        result += '%{expr} %{op} {{%{fct}}}' % { expr: parse(Regexp.last_match(1)), op: Regexp.last_match(2), fct: Regexp.last_match(3) }
      elsif row =~ %r{^(.+)\s([\+-]|\*|\/|==|!=|&&|\|{2}|in)\s(.+)$}
        # scan expression
        result += '%{expr1} %{op} %{expr2}' % { expr1: parse(Regexp.last_match(1)), op: Regexp.last_match(2), expr2: parse(Regexp.last_match(3)) }
      elsif row =~ %r{^(.+)\((.*)$}
        result += '%{fct}(%{param}' % { fct: Regexp.last_match(1), param: Regexp.last_match(2).split(',').map { |x| parse(x.lstrip) }.join(', ') }
      elsif row =~ %r{^(.*)\)(.+)?$}
        # closing bracket ) with optional access of an attribute e.g. '.arguments'
        result += '%{param})%{expr}' % { param: Regexp.last_match(1).split(',').map { |x| parse(x.lstrip) }.join(', '), expr: Regexp.last_match(2) }
      elsif row =~ %r{^\((.*)$}
        result += '(%{expr}' % { expr: parse(Regexp.last_match(1)) }
      elsif row =~ %r{^\s*\[\s*(.*)\s*\]\s?(.+)?$}
        # parse array
        result += '[ %{lst}]' % { lst: process_array(Regexp.last_match(1).split(',')) }
        result += ' %{expr}' % { expr: parse(Regexp.last_match(2)) } if Regexp.last_match(2)
      elsif row =~ %r{^\s*\{\s*(.*)\s*\}\s?(.+)?$}
        # parse hash
        result += "{\n%{expr}}" % { expr: process_hash(Hash[Regexp.last_match(1).gsub(%r{\s*=>\s*|\s*,\s*}, ',').split(',').each_slice(2).to_a]) }
        result += ' %{expr}' % { expr: parse(Regexp.last_match(2)) } if Regexp.last_match(2)
      else
        result += value_types(row.to_s.strip)
      end
      result.gsub(%r{" in "}, ' in ')
    end

    def self.process_array(items, indent = 2)
      result = ''
      items.each do |value_frozen|
        value = value_frozen.dup
        if value.is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive)
          value = value.unwrap
          value = '-:"' + value + '"' if value.is_a?(String)
        end
        if value.is_a?(Hash)
          result += "\n%{ind1}{\n%{expr}%{ind2}}, " % { ind1: ' ' * indent, expr: process_hash(value, indent + 2), ind2: ' ' * indent }
        elsif value.is_a?(Array)
          result += '[ %{lst}], ' % { lst: process_array(value, indent + 2) }
        else
          result += '%{expr}, ' % { expr: parse(value) } if value
        end
      end
      result
    end

    def self.process_hash(attrs, indent = 2, level = 3, prefix = ' ' * indent)
      result = ''
      attrs.each do |attr, value_frozen|
        value = value_frozen.dup
        if value.is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive)
          value = value.unwrap
          value = '-:"' + value + '"' if value.is_a?(String)
        end
        result += if value.is_a?(Hash)
                    op = '+' if value.delete('+')
                    if value.empty?
                      case level
                      when 1 then
                        "%{pre}%{att} #{op}= {}\n" % { pre: prefix, att: attribute_types(attr) }
                      when 2 then
                        "%{pre}[\"%{att}\"] #{op}= {}\n" % { pre: prefix, att: attr }
                      else
                        "%{pre}%{att} #{op}= {}\n" % { pre: prefix, att: attribute_types(attr) }
                      end
                    else
                      case level
                      when 1 then
                        process_hash(value, indent, 2, '%{pre}%{att}' % { pre: prefix, att: attr })
                      when 2 then
                        "%{pre}[\"%{att}\"] #{op}= {\n%{lst}%{ind}}\n" % { pre: prefix, att: attr, lst: process_hash(value, indent), ind: ' ' * (indent - 2) }
                      else
                        "%{pre}%{att} #{op}= {\n%{lst}%{ind}}\n" % { pre: prefix, att: attribute_types(attr), lst: process_hash(value, indent + 2), ind: ' ' * indent }
                      end
                    end
                  elsif value.is_a?(Array)
                    op = value.delete_at(0) if value[0] == '+' || value[0] == '-'
                    case level
                    when 2 then
                      "%{pre}[\"%{att}\"] #{op}= [ %{lst}]\n" % { pre: prefix, att: attribute_types(attr), lst: process_array(value) }
                    else
                      "%{pre}%{att} #{op}= [ %{lst}]\n" % { pre: prefix, att: attribute_types(attr), lst: process_array(value) }
                    end
                  else
                    # String: attr = '+ value' -> attr += 'value'
                    if value =~ %r{^([\+,-])\s+}
                      operator = "#{Regexp.last_match(1)}="
                      value = value.sub(%r{^[\+,-]\s+}, '')
                    else
                      operator = '='
                    end
                    if level == 3
                      "%{pre}%{att} #{operator} %{val}\n" % { pre: prefix, att: attribute_types(attr), val: parse(value) } if value != :nil
                    elsif level > 1
                      "%{pre}[\"%{att}\"] #{operator} %{val}\n" % { pre: prefix, att: attr, val: parse(value) } if value != :nil
                    else
                      "%{pre}%{att} #{operator} %{val}\n" % { pre: prefix, att: attr, val: parse(value) } if value != :nil
                    end
                  end
      end
      result
    end

    def self.attributes(attrs, globals, consts, indent = 2)
      # globals (params.pp) and all keys of attrs hash itselfs must not quoted
      @constants = globals.concat(consts.keys) << 'name'

      # select all attributes and constants if there value is a hash
      @hash_attrs = attrs.merge(consts).select { |_x, y| y.is_a?(Hash) }.keys

      # initialize returned configuration
      config = ''

      attrs.each do |attr, value_frozen|
        value = value_frozen.dup
        if value.is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive)
          value = value.unwrap
          value = '-:"' + value + '"' if value.is_a?(String) && !@constants.include?(value)
        end

        if %r{^(assign|ignore) where$}.match?(attr)
          value.each do |x|
            config += "%{ind}%{att} %{expr}\n" % { ind: ' ' * indent, att: attr, expr: parse(x) } if x
          end
        elsif attr == 'vars'
          if value.is_a?(Hash)
            # delete pair of key '+' because a merge at this point is not allowed
            value.delete('+')
            config += process_hash(value, indent + 2, 1, '%{ind}%{att}.' % { ind: ' ' * indent, att: attr })
          elsif value.is_a?(Array)
            value.each do |item_frozen|
              item = item_frozen.dup
              if item.is_a?(String)
                config += "%{ind}%{att} += %{lst}\n" % { ind: ' ' * indent, att: attr, lst: item.sub(%r{^[\+,-]\s+}, '') }
              else
                item.delete('+')
                config += if item.empty?
                            "%{ind}%{att} += {}\n" % { ind: ' ' * indent, att: attr }
                          else
                            process_hash(item, indent + 2, 1, '%{ind}%{att}.' % { ind: ' ' * indent, att: attr })
                          end
              end
            end
          else
            op = '+' if %r{^\+\s+}.match?(value)
            config += "%{ind}%{att} #{op}= %{val}\n" % { ind: ' ' * indent, att: attr, val: parse(value.sub(%r{^\+\s+}, '')) }
          end
        else
          config += if value.is_a?(Hash)
                      op = '+' if value.delete('+')
                      if !value.empty?
                        "%{ind}%{att} #{op}= {\n%{lst}%{blnk}}\n" % { ind: ' ' * indent, att: attr, lst: process_hash(value, indent + 2), blnk: ' ' * indent }
                      else
                        "%{ind}%{att} #{op}= {}\n" % { ind: ' ' * indent, att: attr }
                      end
                    elsif value.is_a?(Array)
                      op = value.delete_at(0) if value[0] == '+' || value[0] == '-'
                      "%{ind}%{att} #{op}= [ %{lst}]\n" % { ind: ' ' * indent, att: attr, lst: process_array(value) }
                    elsif value =~ %r{^([\+,-])\s+}
                      # String: attr = '+ config' -> attr += config
                      "%{ind}%{att} #{Regexp.last_match(1)}= %{expr}\n" % { ind: ' ' * indent, att: attr, expr: parse(value.sub(%r{^[\+,-]\s+}, '')) }
                    else
                      "%{ind}%{att} = %{expr}\n" % { ind: ' ' * indent, att: attr, expr: parse(value) }
                    end
        end
      end
      config
    end
  end
end
