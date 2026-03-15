# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveKeyFormatMatcher do
  let(:api) do
    obj = Object.new
    obj.define_singleton_method(:key_format) { :camel }
    obj.define_singleton_method(:name) { 'TestApi' }
    obj
  end

  describe '#matches?' do
    it 'returns true when key format matches' do
      matcher = described_class.new(:camel)

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false when key format does not match' do
      matcher = described_class.new(:kebab)

      expect(matcher.matches?(api)).to be(false)
    end

    it 'includes actual format in failure message' do
      matcher = described_class.new(:kebab)
      matcher.matches?(api)

      expect(matcher.failure_message).to eq(
        'expected TestApi to have key format :kebab, but got :camel',
      )
    end
  end

  describe '#description' do
    it 'includes the format' do
      expect(described_class.new(:camel).description).to eq('have key format :camel')
    end
  end
end
