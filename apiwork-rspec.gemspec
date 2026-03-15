# frozen_string_literal: true

require_relative 'lib/apiwork/rspec/version'

Gem::Specification.new do |s|
  s.name = 'apiwork-rspec'
  s.version = Apiwork::RSpec::VERSION
  s.authors = ['skiftle']
  s.summary = 'RSpec matchers for Apiwork'
  s.description = 'Custom RSpec matchers for testing Apiwork resources, representations, and enums'
  s.homepage = 'https://apiwork.dev'
  s.license = 'MIT'

  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'apiwork', '>= 0.1'
  s.add_dependency 'rspec', '>= 3.0'

  s.add_development_dependency 'lefthook', '~> 1.0'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rubocop-skiftle', '~> 0.1'

  s.files = Dir['lib/**/*', 'LICENSE.txt', 'Rakefile']

  s.metadata['bug_tracker_uri'] = 'https://github.com/skiftle/apiwork-rspec/issues'
  s.metadata['homepage_uri'] = 'https://apiwork.dev'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.metadata['source_code_uri'] = 'https://github.com/skiftle/apiwork-rspec'
end
