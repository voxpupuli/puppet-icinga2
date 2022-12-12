require 'spec_helper'

describe 'icinga2::parse' do
  let(:pre_condition) do
    [
      "class { 'icinga2': }",
    ]
  end

  let(:facts) do
    {
      kernel: 'Linux',
      os: {
        family: 'Debian',
        name: 'Debian',
      },
    }
  end

  # without knowing details about the implementation, this is the only test
  # case that we can autogenerate. You should add more examples below!
  it { is_expected.not_to eq(nil) }

  it 'assign a string' do
    # foo = "some string, connected to another. Yeah!"
    is_expected.to run.with_params(
      {
        'foo' => 'some string, connected to another. Yeah!',
      },
    ).and_return("foo = \"some string, connected to another. Yeah!\"\n")

    # foo += "some string"
    is_expected.to run.with_params(
      {
        'foo' => '+ some string, connected to another. Yeah!',
      },
    ).and_return("foo += \"some string, connected to another. Yeah!\"\n")

    # vars.foo = "some string"
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => 'some string, connected to another. Yeah!',
        },
      },
    ).and_return("vars.foo = \"some string, connected to another. Yeah!\"\n")

    # vars.foo += "some string"
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '+ some string, connected to another. Yeah!',
        },
      },
    ).and_return("vars.foo += \"some string, connected to another. Yeah!\"\n")

    # foo = "some string" + [ "bar", "baz", ]
    is_expected.to run.with_params(
      {
        'foo' => 'some string + [ bar, baz ]',
      },
    ).and_return("foo = \"some string\" + [ \"bar\", \"baz\", ]\n")

    # foo = "[ "bar", "baz", ] + "other string"
    is_expected.to run.with_params(
      {
        'foo' => '[ bar, baz ] + other string',
      },
    ).and_return("foo = [ \"bar\", \"baz\", ] + \"other string\"\n")

    # foo = "[ "bar", "baz", ] + [ "barbaz", ]
    is_expected.to run.with_params(
      {
        'foo' => '[ bar, baz ] + [ barbaz ]',
      },
    ).and_return("foo = [ \"bar\", \"baz\", ] + [ \"barbaz\", ]\n")

    # foo = "[ "bar", [ "baz", ], ]
    is_expected.to run.with_params(
      {
        'foo' => '[ bar, [ baz ] ]',
      },
    ).and_return("foo = [ \"bar\", [ \"baz\", ], ]\n")

    # result = "some string" + {
    #   foo = "baz"
    #   bar = "baz"
    # }
    is_expected.to run.with_params(
      {
        'result' => '{ foo => baz, bar => baz }',
      },
    ).and_return("result = {\n  foo = \"baz\"\n  bar = \"baz\"\n}\n")
  end

  it 'assign a boolean' do
    # foo = false
    is_expected.to run.with_params(
      {
        'foo' => 'false',
      },
    ).and_return("foo = false\n")

    # foo = true
    is_expected.to run.with_params(
      {
        'foo' => 'true',
      },
    ).and_return("foo = true\n")

    # foo = null
    is_expected.to run.with_params(
      {
        'foo' => 'null',
      },
    ).and_return("foo = null\n")

    # vars.foo = false
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => 'false',
        },
      },
    ).and_return("vars.foo = false\n")

    # vars.foo = true
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => 'true',
        },
      },
    ).and_return("vars.foo = true\n")

    # vars.foo = null
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => 'null',
        },
      },
    ).and_return("vars.foo = null\n")
  end

  it 'assign a number' do
    # foo = 42
    is_expected.to run.with_params(
      {
        'foo' => '42',
      },
    ).and_return("foo = 42\n")

    # foo += 42
    is_expected.to run.with_params(
      {
        'foo' => '+ 42',
      },
    ).and_return("foo += 42\n")

    # foo -= 42
    is_expected.to run.with_params(
      {
        'foo' => '- 42',
      },
    ).and_return("foo -= 42\n")

    # foo = -42
    is_expected.to run.with_params(
      {
        'foo' => '-42',
      },
    ).and_return("foo = -42\n")

    # foo += -42
    is_expected.to run.with_params(
      {
        'foo' => '+ -42',
      },
    ).and_return("foo += -42\n")

    # foo -= -42
    is_expected.to run.with_params(
      {
        'foo' => '- -42',
      },
    ).and_return("foo -= -42\n")

    # vars.foo = 42
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '42',
        },
      },
    ).and_return("vars.foo = 42\n")

    # vars.foo += 42
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '+ 42',
        },
      },
    ).and_return("vars.foo += 42\n")

    # vars.foo -= 42
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '- 42',
        },
      },
    ).and_return("vars.foo -= 42\n")

    # vars.foo = -42
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '-42',
        },
      },
    ).and_return("vars.foo = -42\n")

    # vars.foo += -42
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '+ -42',
        },
      },
    ).and_return("vars.foo += -42\n")

    # vars.foo -= -42
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '- -42',
        },
      },
    ).and_return("vars.foo -= -42\n")
  end

  it 'assign a floating point number' do
    # foo = 3.141
    is_expected.to run.with_params(
      {
        'foo' => '3.141',
      },
    ).and_return("foo = 3.141\n")

    # foo += 3.141
    is_expected.to run.with_params(
      {
        'foo' => '+ 3.141',
      },
    ).and_return("foo += 3.141\n")

    # foo -= 3.141
    is_expected.to run.with_params(
      {
        'foo' => '- 3.141',
      },
    ).and_return("foo -= 3.141\n")

    # foo = -3.141
    is_expected.to run.with_params(
      {
        'foo' => '-3.141',
      },
    ).and_return("foo = -3.141\n")

    # foo += -3.141
    is_expected.to run.with_params(
      {
        'foo' => '+ -3.141',
      },
    ).and_return("foo += -3.141\n")

    # foo -= -3.141
    is_expected.to run.with_params(
      {
        'foo' => '- -3.141',
      },
    ).and_return("foo -= -3.141\n")

    # vars.foo = 3.141
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '3.141',
        },
      },
    ).and_return("vars.foo = 3.141\n")

    # vars.foo += 3.141
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '+ 3.141',
        },
      },
    ).and_return("vars.foo += 3.141\n")

    # vars.foo -= 3.141
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '- 3.141',
        },
      },
    ).and_return("vars.foo -= 3.141\n")

    # vars.foo = -3.141
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '-3.141',
        },
      },
    ).and_return("vars.foo = -3.141\n")

    # vars.foo += -3.141
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '+ -3.141',
        },
      },
    ).and_return("vars.foo += -3.141\n")

    # vars.foo -= -3.141
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => '- -3.141',
        },
      },
    ).and_return("vars.foo -= -3.141\n")
  end

  it 'assign numbers with time units' do
    # foo_s = 60s
    # foo_m = 5m
    # foo_h = 2.5h
    # foo_d = 2d
    is_expected.to run.with_params(
      {
        'foo_s' => '60s',
        'foo_m' => '5m',
        'foo_h' => '2.5h',
        'foo_d' => '2d',
      },
    ).and_return("foo_s = 60s\nfoo_m = 5m\nfoo_h = 2.5h\nfoo_d = 2d\n")

    # vars.foo_s = 60s
    # vars.foo_m = 5m
    # vars.foo_h = 2.5h
    # vars.foo_d = 2d
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo_s' => '60s',
          'foo_m' => '5m',
          'foo_h' => '2.5h',
          'foo_d' => '2d',
        },
      },
    ).and_return("vars.foo_s = 60s\nvars.foo_m = 5m\nvars.foo_h = 2.5h\nvars.foo_d = 2d\n")
  end

  it 'assign an array' do
    # foo = [ "some string, connected to another. Yeah!", NodeName, 42, 3.141, 2d, true, ]
    is_expected.to run.with_params(
      {
        'foo' => ['some string, connected to another. Yeah!', 'NodeName', '42', '3.141', '2.5d', 'true'],
      },
    ).and_return("foo = [ \"some string, connected to another. Yeah!\", NodeName, 42, 3.141, 2.5d, true, ]\n")

    # foo += [ "some string, connected to another. Yeah!", NodeName, 42, 3.141, 2d, true, ]
    is_expected.to run.with_params(
      {
        'foo' => ['+', 'some string, connected to another. Yeah!', 'NodeName', '42', '3.141', '2.5d', 'true'],
      },
    ).and_return("foo += [ \"some string, connected to another. Yeah!\", NodeName, 42, 3.141, 2.5d, true, ]\n")

    # foo -= [ "some string, connected to another. Yeah!", NodeName, 42, 3.141, 2d, true, ]
    is_expected.to run.with_params(
      {
        'foo' => ['-', 'some string, connected to another. Yeah!', 'NodeName', '42', '3.141', '2.5d', 'true'],
      },
    ).and_return("foo -= [ \"some string, connected to another. Yeah!\", NodeName, 42, 3.141, 2.5d, true, ]\n")

    # vars.foo = [ "some string, connected to another. Yeah!", NodeName, 42, 3.141, 2d, true, ]
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => ['some string, connected to another. Yeah!', 'NodeName', '42', '3.141', '2.5d', 'true'],
        },
      },
    ).and_return("vars.foo = [ \"some string, connected to another. Yeah!\", NodeName, 42, 3.141, 2.5d, true, ]\n")

    # vars.foo += [ "some string, connected to another. Yeah!", NodeName, 42, 3.141, 2d, true, ]
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => ['+', 'some string, connected to another. Yeah!', 'NodeName', '42', '3.141', '2.5d', 'true'],
        },
      },
    ).and_return("vars.foo += [ \"some string, connected to another. Yeah!\", NodeName, 42, 3.141, 2.5d, true, ]\n")

    # vars.foo -= [ "some string, connected to another. Yeah!", NodeName, 42, 3.141, 2d, true, ]
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => ['-', 'some string, connected to another. Yeah!', 'NodeName', '42', '3.141', '2.5d', 'true'],
        },
      },
    ).and_return("vars.foo -= [ \"some string, connected to another. Yeah!\", NodeName, 42, 3.141, 2.5d, true, ]\n")
  end

  it 'assign a hash' do
    # foo = {}
    is_expected.to run.with_params(
      {
        'foo' => {},
      },
    ).and_return("foo = {}\n")

    # foo += {}
    is_expected.to run.with_params(
      {
        'foo' => {
          '+' => true,
        },
      },
    ).and_return("foo += {}\n")

    # foo = {
    #   string = "some string, connected to another. Yeah!"
    #   constant = NodeName
    #   numbers = [ 42, 3.141, -42, -3.141, ]
    #   time = 2.5d
    #   bool = true
    # }
    is_expected.to run.with_params(
      {
        'foo' => {
          'string' => 'some string, connected to another. Yeah!',
          'constant' => 'NodeName',
          'numbers' => ['42', '3.141', '-42', '-3.141'],
          'merge_array' => ['+', '42', '3.141', '-42', '-3.141'],
          'time' => '2.5d',
          'bool' => 'true',
        },
      },
    ).and_return(
      "foo = {\n  string = \"some string, connected to another. Yeah!\"\n  constant = NodeName\n" \
      "  numbers = [ 42, 3.141, -42, -3.141, ]\n  merge_array += [ 42, 3.141, -42, -3.141, ]\n  time = 2.5d\n  bool = true\n}\n",
    )

    # foo += {
    #   string = "some string, connected to another. Yeah!"
    #   constant = NodeName
    #   numbers = [ 42, 3.141, -42, -3.141, ]
    #   time = 2.5d
    #   bool = true
    # }
    is_expected.to run.with_params(
      {
        'foo' => {
          '+' => true,
          'string' => 'some string, connected to another. Yeah!',
          'constant' => 'NodeName',
          'numbers' => ['42', '3.141', '-42', '-3.141'],
          'merge_array' => ['+', '42', '3.141', '-42', '-3.141'],
          'time' => '2.5d',
          'bool' => 'true',
        },
      },
    ).and_return(
      "foo += {\n  string = \"some string, connected to another. Yeah!\"\n  constant = NodeName\n  numbers = [ 42, 3.141, -42, -3.141, ]\n" \
      "  merge_array += [ 42, 3.141, -42, -3.141, ]\n  time = 2.5d\n  bool = true\n}\n",
    )

    # vars.foo["string"] = "some string, connected to another. Yeah!"
    # vars.foo["constant"] = NodeName
    # vars.foo["numbers"] = [ 42, 3.141, -42, -3.141, ]
    # vars.foo["merge_array"] += [ 42, 3.141, -42, -3.141, ]
    # vars.foo["time"] = 2.5d
    # vars.foo["bool"] = true
    is_expected.to run.with_params(
      {
        'vars' => {
          'foo' => {
            'string' => 'some string, connected to another. Yeah!',
            'constant' => 'NodeName',
            'numbers' => ['42', '3.141', '-42', '-3.141'],
            'merge_array' => ['+', '42', '3.141', '-42', '-3.141'],
            'time' => '2.5d',
            'bool' => 'true',
          },
        },
      },
    ).and_return(
      "vars.foo[\"string\"] = \"some string, connected to another. Yeah!\"\nvars.foo[\"constant\"] = NodeName\nvars.foo[\"numbers\"] = [ 42, 3.141, -42, -3.141, ]\n" \
      "vars.foo[\"merge_array\"] += [ 42, 3.141, -42, -3.141, ]\nvars.foo[\"time\"] = 2.5d\nvars.foo[\"bool\"] = true\n",
    )
  end

  it 'assign a nested hash' do
    # foobar = {
    #   foo += {
    #     string = "some string, connected to another. Yeah!"
    #     constant = NodeName
    #     bool = true
    #   }
    #   fooz += {}
    #   bar = {
    #     numbers = [ 42, 3.141, -42, -3,141, ]
    #     merge_array += [ 42, 3.141, -42, -3,141, ]
    #     time = 2.5d
    #   }
    #   baz = {}
    # }
    is_expected.to run.with_params(
      {
        'foobar' => {
          'foo' => {
            '+' => true,
            'string' => 'some string, connected to another. Yeah!',
            'constant' => 'NodeName',
            'bool' => 'true',
          },
          'fooz' => {
            '+' => true,
          },
          'bar' => {
            'numbers' => [ '42', '3.141', '-42', '-3.141' ],
            'merge_array' => [ '+', '42', '3.141', '-42', '-3.141' ],
            'time' => '2.5d',
          },
          'baz' => {},
        },
      },
    ).and_return("foobar = {\n  foo += {\n    string = \"some string, connected to another. Yeah!\"\n    constant = NodeName\n    bool = true\n  }\n" \
      "  fooz += {}\n  bar = {\n    numbers = [ 42, 3.141, -42, -3.141, ]\n    merge_array += [ 42, 3.141, -42, -3.141, ]\n    time = 2.5d\n  }\n  baz = {}\n}\n")

    # vars.foobar["foo"] += {
    #   string = "some string, connected to another. Yeah!"
    #   constant = NodeName
    #   bool = true
    # }
    # vars.foobar["fooz"] += {}
    # vars.foobar["bar"] = {
    #   numbers = [ 42, 3.141, -42, -3,141, ]
    #   merge_array += [ 42, 3.141, -42, -3,141, ]
    #   time = 2.5d
    # }
    # vars.foobar["baz"] = {}
    is_expected.to run.with_params(
      {
        'vars' => {
          'foobar' => {
            'foo' => {
              '+' => true,
              'string' => 'some string, connected to another. Yeah!',
              'constant' => 'NodeName',
              'bool' => 'true',
            },
            'fooz' => {
              '+' => true,
            },
            'bar' => {
              'numbers' => ['42', '3.141', '-42', '-3.141'],
              'merge_array' => ['+', '42', '3.141', '-42', '-3.141'],
              'time' => '2.5d',
            },
            'baz' => {},
          },
        },
      },
    ).and_return(
      "vars.foobar[\"foo\"] += {\n  string = \"some string, connected to another. Yeah!\"\n  constant = NodeName\n  bool = true\n}\n" \
      "vars.foobar[\"fooz\"] += {}\nvars.foobar[\"bar\"] = {\n  numbers = [ 42, 3.141, -42, -3.141, ]\n  merge_array += [ 42, 3.141, -42, -3.141, ]\n  time = 2.5d\n}\nvars.foobar[\"baz\"] = {}\n",
    )
  end

  it 'assign multiple custom attributes' do
    # vars += config1
    is_expected.to run.with_params(
      {
        'vars' => '+ config',
      },
      0,
      ['config'],
    ).and_return("vars += config\n")

    # vars = vars + config1
    is_expected.to run.with_params(
      {
        'vars' => 'vars + config',
      },
      0,
      [ 'vars', 'config' ],
    ).and_return("vars = vars + config\n")

    # vars += config1
    # vars += {}
    # vars.foo = "some string"
    # vars.bar += [ 42, 3.141, -42, -3.141, ]
    # vars.baz["number"] -= 42
    # vars.baz["floating"] += 3.141
    # vars += config2
    is_expected.to run.with_params(
      {
        'vars' => [
          '+ config1',
          {},
          {
            'foo' => 'some string',
            'bar' => [ '+', '42', '3.141', '-42', '-3.141' ],
            'baz' => {
              '+' => true,
              'number' => '- 42',
              'floating' => '+ 3.141',
            },
          },
          '+ config2',
        ],
      },
    ).and_return("vars += config1\nvars += {}\nvars.foo = \"some string\"\nvars.bar += [ 42, 3.141, -42, -3.141, ]\nvars.baz[\"number\"] -= 42\nvars.baz[\"floating\"] += 3.141\nvars += config2\n")
  end

  it 'arithmetic and logical expressions' do
    # result = 3 + 2 * 4 - (4 + (-2.5)) * 8 + func(3 * 2 + 1, funcN(-42)) + str(NodeName, "some string", "another string")
    is_expected.to run.with_params(
      {
        'result' => '3 + 2 * 4 - (4 + (-2.5)) * 8 + func(3 * 2 + 1, funcN(-42)) + str(NodeName, some string, another string)',
      },
    ).and_return("result = 3 + 2 * 4 - (4 + (-2.5)) * 8 + func(3 * 2 + 1, funcN(-42)) + str(NodeName, \"some string\", \"another string\")\n")

    # result += 3 + 2 * 4 - (4 + (-2.5)) * 8 + func(3 * 2 + 1, funcN(-42)) + str(NodeName, "some string", "another string")
    is_expected.to run.with_params(
      {
        'result' => '+ 3 + 2 * 4 - (4 + (-2.5)) * 8 + func(3 * 2 + 1, funcN(-42)) + str(NodeName, some string, another string)',
      },
    ).and_return("result += 3 + 2 * 4 - (4 + (-2.5)) * 8 + func(3 * 2 + 1, funcN(-42)) + str(NodeName, \"some string\", \"another string\")\n")

    # result = [ 3 + 4, 4 - (4 + (-2.5)) * 8, func(3 * 2 + 1, funcN(-42)) + str(NodeName, "some string", "another string"), ]
    is_expected.to run.with_params(
      {
        'result' => [
          '3 + 4',
          '4 - (4 + (-2.5)) * 8',
          'func(3 * 2 + 1, funcN(-42)) + str(NodeName, some string, another string)',
        ],
      },
    ).and_return("result = [ 3 + 4, 4 - (4 + (-2.5)) * 8, func(3 * 2 + 1, funcN(-42)) + str(NodeName, \"some string\", \"another string\"), ]\n")

    # result = {
    #   add = 3 + 4
    #   expr = 4 - (4 + (-2.5)) * 8
    #   func = func(3 * 2 + 1, funcN(-42)) + str(NodeName, "some string", "another string")
    # }
    is_expected.to run.with_params(
      {
        'result' => {
          'add' => '3 + 4',
          'expr' => '4 - (4 + (-2.5)) * 8',
          'func' => 'func(3 * 2 + 1, funcN(-42)) + str(NodeName, some string, another string)',
        },
      },
    ).and_return("result = {\n  add = 3 + 4\n  expr = 4 - (4 + (-2.5)) * 8\n  func = func(3 * 2 + 1, funcN(-42)) + str(NodeName, \"some string\", \"another string\")\n}\n")

    # result = get_object("Endpoint", host.name).host + "host.example.org"
    is_expected.to run.with_params(
      {
        'result' => 'get_object(Endpoint, host.name).attribute + string',
      },
    ).and_return("result = get_object(\"Endpoint\", host.name).attribute + \"string\"\n")

    # assign where (host.address || host.address6) && host.vars.os == "Linux"
    # assign where get_object("Endpoint", host.name)
    is_expected.to run.with_params(
      {
        'assign where' => [
          '(host.address || host.address6) && host.vars.os == Linux',
          'get_object(Endpoint, host.name)',
        ],
      },
    ).and_return("assign where (host.address || host.address6) && host.vars.os == \"Linux\"\nassign where get_object(\"Endpoint\", host.name)\n")

    # ignore where get_object("Endpoint", host.name) || host.vars.os != "Windows"
    is_expected.to run.with_params(
      {
        'ignore where' => [
          'get_object(Endpoint, host.name) || host.vars.os != Windows',
        ],
      },
    ).and_return("ignore where get_object(\"Endpoint\", host.name) || host.vars.os != \"Windows\"\n")
  end

  it 'disable parsing' do
    # result = "unparsed string NodeName with quotes"
    is_expected.to run.with_params(
      {
        'result' => '-:"unparsed string NodeName with quotes"',
      },
    ).and_return("result = \"unparsed string NodeName with quotes\"\n")

    # result = [ "unparsed string NodeName with quotes", ]
    is_expected.to run.with_params(
      {
        'result' => [ '-:"unparsed string NodeName with quotes"' ],
      },
    ).and_return("result = [ \"unparsed string NodeName with quotes\", ]\n")

    # result = {
    #   string = "unparsed string NodeName with quotes",
    # }
    is_expected.to run.with_params(
      {
        'result' => { 'string' => '-:"unparsed string NodeName with quotes"' },
      },
    ).and_return("result = {\n  string = \"unparsed string NodeName with quotes\"\n}\n")
  end
end
