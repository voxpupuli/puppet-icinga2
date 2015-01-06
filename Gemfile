source ENV['GEM_SOURCE'] || "https://rubygems.org"

#Install the gems but don't run `require gemname` when bundler runs
#Source: http://stackoverflow.com/questions/4800721/bundler-what-does-require-false-in-a-gemfile-mean
#Source of the list of gems: https://github.com/puppetlabs/puppetlabs-ntp/blob/master/Gemfile
group :development, :unit_tests do
  gem 'rake',                    :require => false
  gem 'rspec-puppet',            :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'puppet-lint',             :require => false
  gem 'simplecov',               :require => false
  gem 'puppet_facts',            :require => false
  gem 'json',                    :require => false
end