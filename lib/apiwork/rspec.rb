# frozen_string_literal: true

require 'zeitwerk'
require_relative 'rspec/version'

# @api public
module Apiwork
  # @api public
  module RSpec
  end
end

loader = Zeitwerk::Loader.new
loader.tag = 'apiwork-rspec'
loader.push_dir("#{__dir__}/..", namespace: Object)

loader.inflector.inflect(
  'rspec' => 'RSpec',
)

loader.ignore(__FILE__)
loader.ignore("#{__dir__}/../apiwork-rspec.rb")
loader.ignore("#{__dir__}/rspec/version.rb")

loader.setup
