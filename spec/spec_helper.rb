# frozen_string_literal: true

require 'apiwork-rspec'
require_relative 'support/doubles'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.include Apiwork::RSpec::Matchers
  config.include TestDoubles
end
