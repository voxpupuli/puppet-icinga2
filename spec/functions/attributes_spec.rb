require 'spec_helper'

describe 'icinga2_attributes' do
  let(:pre_condition) { [
    "class { 'icinga2': }"
  ] }
  let(:facts) { {:kernel => 'Linux', :os => {:family => 'Debian', :name => 'Debian'}, :osfamily => 'Debian',} }

  it 'raises a ArgumentError if there is less than 1 arguments' do
    is_expected.to run.with_params.and_raise_error(Puppet::ParseError)
  end


  it 'raises a ArgumentError if there are more than 4 arguments' do
    is_expected.to run.with_params('one','two','three','four','five').and_raise_error(Puppet::ParseError)
  end


  it 'assign a string' do

    # foo = "some string"
    is_expected.to run.with_params({
      'foo' => 'some string, connected to another. Yeah!'
    }).and_return("foo = \"some string, connected to another. Yeah!\"\n")

    # vars.foo = "some string"
    is_expected.to run.with_params({
      'vars' => {
        'foo' => 'some string, connected to another. Yeah!'
      }
    }).and_return("vars.foo = \"some string, connected to another. Yeah!\"\n")
  end


  it 'assign a boolean' do

    # foo = false
    is_expected.to run.with_params({
      'foo' => 'false'
    }).and_return("foo = false\n")

    # foo = true
    is_expected.to run.with_params({
      'foo' => 'true'
    }).and_return("foo = true\n")

    # foo = null
    is_expected.to run.with_params({
      'foo' => 'null'
    }).and_return("foo = null\n")

    # vars.foo = false
    is_expected.to run.with_params({
      'vars' => {
        'foo' => 'false'
      }
    }).and_return("vars.foo = false\n")

    # vars.foo = true
    is_expected.to run.with_params({
      'vars' => {
        'foo' => 'true'
      }
    }).and_return("vars.foo = true\n")

    # vars.foo = null
    is_expected.to run.with_params({
      'vars' => {
        'foo' => 'null'
      }
    }).and_return("vars.foo = null\n")
  end


  it 'assign a number' do

    # foo = 42
    is_expected.to run.with_params({
      'foo' => '42'
    }).and_return("foo = 42\n")

    # foo = -42
    is_expected.to run.with_params({
      'foo' => '-42'
    }).and_return("foo = -42\n")

    # vars.foo = 42
    is_expected.to run.with_params({
      'vars' => {
        'foo' => '42'
      }
    }).and_return("vars.foo = 42\n")

    # vars.foo = -42
    is_expected.to run.with_params({
      'vars' => {
        'foo' => '-42'
      }
    }).and_return("vars.foo = -42\n")
  end


  it 'assign a floating point number' do

    # foo = 3.141
    is_expected.to run.with_params({
      'foo' => '3.141'
    }).and_return("foo = 3.141\n")

    # foo = -3.141
    is_expected.to run.with_params({
      'foo' => '3.141'
    }).and_return("foo = 3.141\n")

    # vars.foo = 3.141
    is_expected.to run.with_params({
      'vars' => {
        'foo' => '3.141'
      }
    }).and_return("vars.foo = 3.141\n")

    # vars.foo = -3.141
    is_expected.to run.with_params({
      'vars' => {
        'foo' => '-3.141'
      }
    }).and_return("vars.foo = -3.141\n")
  end


  it 'assign numbers with time units' do

    # foo_s = 60s
    # foo_m = 5m
    # foo_h = 2.5h
    # foo_d = 2d
    is_expected.to run.with_params({
      'foo_s' => '60s',
      'foo_m' => '5m',
      'foo_h' => '2.5h',
      'foo_d' => '2d'
    }).and_return("foo_s = 60s\nfoo_m = 5m\nfoo_h = 2.5h\nfoo_d = 2d\n")

    # vars.foo_s = 60s
    # vars.foo_m = 5m
    # vars.foo_h = 2.5h
    # vars.foo_d = 2d
    is_expected.to run.with_params({
      'vars' => {
        'foo_s' => '60s',
        'foo_m' => '5m',
        'foo_h' => '2.5h',
        'foo_d' => '2d'
      }
    }).and_return("vars.foo_s = 60s\nvars.foo_m = 5m\nvars.foo_h = 2.5h\nvars.foo_d = 2d\n")
  end


  it 'assign an array' do

    # foo = [ "some string, connected to another. Yeah!", NodeName, 42, 3.141, 2d, true, ]
    is_expected.to run.with_params({
      'foo' => ['some string, connected to another. Yeah!', 'NodeName', '42', '3.141', '2.5d', 'true']
    }).and_return("foo = [ \"some string, connected to another. Yeah!\", NodeName, 42, 3.141, 2.5d, true, ]\n")

    # vars.foo = [ "some string, connected to another. Yeah!", NodeName, 42, 3.141, 2d, true, ]
    is_expected.to run.with_params({
      'vars' => {
        'foo' => ['some string, connected to another. Yeah!', 'NodeName', '42', '3.141', '2.5d', 'true']
      }
    }).and_return("vars.foo = [ \"some string, connected to another. Yeah!\", NodeName, 42, 3.141, 2.5d, true, ]\n")
  end


  it 'assign a hash' do

    # foo = {
    #   string = "some string, connected to another. Yeah!"
    #   constant = NodeName
    #   numbers = [ 42, 3.141, -42, -3.141, ]
    #   time = 2.5d
    #   bool = true
    # }
    is_expected.to run.with_params({
      'foo' => {
        'string' => 'some string, connected to another. Yeah!',
        'constant' => 'NodeName',
        'numbers' => ['42', '3.141', '-42', '-3.141'],
        'time' => '2.5d',
        'bool' => 'true'
      }
    }).and_return("foo = {\n  string = \"some string, connected to another. Yeah!\"\n  constant = NodeName\n  numbers = [ 42, 3.141, -42, -3.141, ]\n  time = 2.5d\n  bool = true\n}\n")

    # vars.foo["string"] = "some string, connected to another. Yeah!"
    # vars.foo["constant"] = NodeName
    # vars.foo["numbers"] = [ 42, 3.141, -42, -3.141, ]
    # vars.foo["time"] = 2.5d
    # vars.foo["bool"] = true
    is_expected.to run.with_params({
      'vars' => {
        'foo' => {
          'string' => 'some string, connected to another. Yeah!',
          'constant' => 'NodeName',
          'numbers' => ['42', '3.141', '-42', '-3.141'],
          'time' => '2.5d',
          'bool' => 'true'
        }
      }
    }).and_return("vars.foo[\"string\"] = \"some string, connected to another. Yeah!\"\nvars.foo[\"constant\"] = NodeName\nvars.foo[\"numbers\"] = [ 42, 3.141, -42, -3.141, ]\nvars.foo[\"time\"] = 2.5d\nvars.foo[\"bool\"] = true\n")
  end


  it 'assign a nested hash' do

    # foobar = {
    #   foo = {
    #     string = "some string, connected to another. Yeah!"
    #     constant = NodeName
    #     bool = true
    #   }
    #   bar = {
    #     numbers = [ 42, 3.141, -42, -3,141, ]
    #     time = 2.5d
    #   }
    # }
    is_expected.to run.with_params({
      'foobar' => {
        'foo' => {
          'string' => 'some string, connected to another. Yeah!',
          'constant' => 'NodeName',
          'bool' => 'true'
        },
        'bar' => {
          'numbers' => ['42', '3.141', '-42', '-3.141'],
          'time' => '2.5d'
        }
      }
    }).and_return("foobar = {\n  foo = {\n    string = \"some string, connected to another. Yeah!\"\n    constant = NodeName\n    bool = true\n  }\n  bar = {\n    numbers = [ 42, 3.141, -42, -3.141, ]\n    time = 2.5d\n  }\n}\n")

    # vars.foobar["foo"] = {
    #   string = "some string, connected to another. Yeah!"
    #   constant = NodeName
    #   bool = true
    # }
    # vars.foobar["bar"] = {
    #   numbers = [ 42, 3.141, -42, -3,141, ]
    #   time = 2.5d
    # }
    is_expected.to run.with_params({
      'vars' => {
        'foobar' => {
          'foo' => {
            'string' => 'some string, connected to another. Yeah!',
            'constant' => 'NodeName',
            'bool' => 'true'
          },
          'bar' => {
            'numbers' => ['42', '3.141', '-42', '-3.141'],
            'time' => '2.5d'
          }
        }
      }
    }).and_return("vars.foobar[\"foo\"] = {\n  string = \"some string, connected to another. Yeah!\"\n  constant = NodeName\n  bool = true\n}\nvars.foobar[\"bar\"] = {\n  numbers = [ 42, 3.141, -42, -3.141, ]\n  time = 2.5d\n}\n")
  end


  it 'arithmetic and logical expressions' do

    # result = 3 + 2 * 4 - (4 + (-2.5)) * 8 + func(3 * 2 + 1, funcN(-42)) + str(NodeName, "some string", "another string")
    is_expected.to run.with_params({
      'result' => '3 + 2 * 4 - (4 + (-2.5)) * 8 + func(3 * 2 + 1, funcN(-42)) + str(NodeName, some string, another string)'
    }).and_return("result = 3 + 2 * 4 - (4 + (-2.5)) * 8 + func(3 * 2 + 1, funcN(-42)) + str(NodeName, \"some string\", \"another string\")\n")

    # result = [ 3 + 4, 4 - (4 + (-2.5)) * 8, func(3 * 2 + 1, funcN(-42)) + str(NodeName, "some string", "another string"), ]
    is_expected.to run.with_params({
      'result' => [
        '3 + 4',
        '4 - (4 + (-2.5)) * 8',
        'func(3 * 2 + 1, funcN(-42)) + str(NodeName, some string, another string)'
      ]
    }).and_return("result = [ 3 + 4, 4 - (4 + (-2.5)) * 8, func(3 * 2 + 1, funcN(-42)) + str(NodeName, \"some string\", \"another string\"), ]\n")

    # result = {
    #   add = 3 + 4
    #   expr = 4 - (4 + (-2.5)) * 8
    #   func = func(3 * 2 + 1, funcN(-42)) + str(NodeName, "some string", "another string")
    # }
    is_expected.to run.with_params({
      'result' => {
        'add' => '3 + 4',
        'expr' => '4 - (4 + (-2.5)) * 8',
        'func' => 'func(3 * 2 + 1, funcN(-42)) + str(NodeName, some string, another string)'
      }
    }).and_return("result = {\n  add = 3 + 4\n  expr = 4 - (4 + (-2.5)) * 8\n  func = func(3 * 2 + 1, funcN(-42)) + str(NodeName, \"some string\", \"another string\")\n}\n")

    # assign where (host.address || host.address6) && host.vars.os == "Linux"
    # assign where get_object("Endpoint", host.name)
    is_expected.to run.with_params({
      'assign where' => [
        '(host.address || host.address6) && host.vars.os == Linux',
        'get_object(Endpoint, host.name)'
      ]
    }).and_return("assign where (host.address || host.address6) && host.vars.os == \"Linux\"\nassign where get_object(\"Endpoint\", host.name)\n")

    # ignore where get_object("Endpoint", host.name) || host.vars.os != "Windows"
    is_expected.to run.with_params({
      'ignore where' => [
        'get_object(Endpoint, host.name) || host.vars.os != Windows'
      ]
    }).and_return("ignore where get_object(\"Endpoint\", host.name) || host.vars.os != \"Windows\"\n")
  end

  it 'disable parsing' do

    # result = "unparsed string NodeName with quotes"
    is_expected.to run.with_params({
      'result' => '-:"unparsed string NodeName with quotes"'
    }).and_return("result = \"unparsed string NodeName with quotes\"\n")

    # result = "unparsed string NodeName with quotes", ]
    is_expected.to run.with_params({
      'result' => [ '-:"unparsed string NodeName with quotes"' ]
    }).and_return("result = [ \"unparsed string NodeName with quotes\", ]\n")

    # result = {
    #   string = "unparsed string NodeName with quotes",
    # }
    is_expected.to run.with_params({
      'result' => { 'string' =>  '-:"unparsed string NodeName with quotes"' }
    }).and_return("result = {\n  string = \"unparsed string NodeName with quotes\"\n}\n")

  end

end
