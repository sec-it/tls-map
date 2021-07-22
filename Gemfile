# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in .gemspec
gemspec

# Needed for the CLI only
group :runtime, :cli do
  gem 'docopt', '~> 0.6' # for argument parsing
  gem 'paint', '~> 2.2' # for colorized ouput
end

# Needed for the CLI & library
group :runtime, :all do
  gem 'rexml', '~> 3.2' # XML parser
end

# Needed to install dependencies
group :development, :install do
  gem 'bundler', ['>= 2.1.0', '< 2.3']
end

# Needed to run tests
group :development, :test do
  gem 'minitest', '~> 5.12'
  gem 'minitest-skip', '~> 0.0' # skip dummy tests
  gem 'rake', '~> 13.0'
end

# Needed for linting
group :development, :lint do
  gem 'rubocop', '~> 1.10'
end

group :development, :docs do
  gem 'commonmarker', '~> 0.21' # for GMF support in YARD
  gem 'github-markup', '~> 4.0' # for GMF support in YARD
  gem 'redcarpet', '~> 3.5' # for GMF support in YARD
  gem 'webrick', '~> 1.7' # for server support in YARD
  gem 'yard', '~> 0.9'
end
