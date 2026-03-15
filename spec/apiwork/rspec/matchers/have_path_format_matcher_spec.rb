# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HavePathFormatMatcher do
  let(:api) do
    obj = Object.new
    obj.define_singleton_method(:path_format) { :kebab }
    obj.define_singleton_method(:name) { 'TestApi' }
    obj
  end

  describe '#matches?' do
    it 'returns true when path format matches' do
      matcher = described_class.new(:kebab)

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false when path format does not match' do
      matcher = described_class.new(:camel)

      expect(matcher.matches?(api)).to be(false)
    end

    it 'includes actual format in failure message' do
      matcher = described_class.new(:camel)
      matcher.matches?(api)

      expect(matcher.failure_message).to eq(
        'expected TestApi to have path format :camel, but got :kebab',
      )
    end
  end

  describe '#description' do
    it 'includes the format' do
      expect(described_class.new(:kebab).description).to eq('have path format :kebab')
    end
  end
end
