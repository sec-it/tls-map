# frozen_string_literal: true

require_relative 'lib/tls_map/version'

Gem::Specification.new do |s|
  s.name          = 'tls-map'
  s.version       = TLSmap::VERSION
  s.platform      = Gem::Platform::RUBY
  s.summary       = 'CLI & library for mapping TLS cipher algorithm names: IANA, OpenSSL, GnuTLS, NSS'
  s.description   = 'CLI & library for mapping TLS cipher algorithm names: IANA, OpenSSL, GnuTLS, NSS'
  s.authors       = ['Alexandre ZANNI']
  s.email         = 'alexandre.zanni@engineer.com'
  s.homepage      = 'https://sec-it.github.io/tls-map/'
  s.license       = 'MIT'

  s.files         = Dir['bin/*'] + Dir['lib/**/*.rb'] + Dir['data/*'] + ['LICENSE']
  s.bindir        = 'bin'
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.metadata = {
    'yard.run'          => 'yard',
    'bug_tracker_uri'   => 'https://github.com/sec-it/tls-map/issues',
    'changelog_uri'     => 'https://github.com/sec-it/tls-map/blob/master/docs/CHANGELOG.md',
    'documentation_uri' => 'https://sec-it.github.io/tls-map/yard/',
    'homepage_uri'      => 'https://sec-it.github.io/tls-map/',
    'source_code_uri'   => 'https://github.com/sec-it/tls-map/'
  }

  s.required_ruby_version = ['>= 2.6.0', '< 3.1']

  s.add_runtime_dependency('docopt', '~> 0.6') # for argument parsing
  s.add_runtime_dependency('paint', '~> 2.2') # for colorized ouput
  s.add_runtime_dependency('rexml', '~> 3.2') # XML parser

  s.add_development_dependency('bundler', ['>= 2.1.0', '< 2.3'])
  s.add_development_dependency('commonmarker', '~> 0.21') # for GMF support in YARD
  s.add_development_dependency('github-markup', '~> 4.0') # for GMF support in YARD
  s.add_development_dependency('redcarpet', '~> 3.5') # for GMF support in YARD
  s.add_development_dependency('rubocop', '~> 1.10')
  s.add_development_dependency('yard', '~> 0.9')
end
