require 'puppet-lint/tasks/puppet-lint'

task :unit_tests => [:lint]

PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.send('disable_variable_scope')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]