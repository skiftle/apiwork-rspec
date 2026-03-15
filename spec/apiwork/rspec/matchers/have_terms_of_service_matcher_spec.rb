# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveTermsOfServiceMatcher do
  let(:info) do
    obj = Object.new
    obj.define_singleton_method(:terms_of_service) { 'https://example.com/terms' }
    obj.define_singleton_method(:name) { 'test_info' }
    obj
  end

  describe '#matches?' do
    it 'returns true when terms of service matches' do
      matcher = described_class.new('https://example.com/terms')

      expect(matcher.matches?(info)).to be(true)
    end

    it 'returns false when terms of service does not match' do
      matcher = described_class.new('https://other.com/terms')

      expect(matcher.matches?(info)).to be(false)
    end

    it 'includes actual URL in failure message' do
      matcher = described_class.new('https://other.com/terms')
      matcher.matches?(info)

      expect(matcher.failure_message).to eq(
        'expected test_info to have terms of service "https://other.com/terms", but got "https://example.com/terms"',
      )
    end
  end

  describe '#description' do
    it 'includes the URL' do
      expect(described_class.new('https://example.com/terms').description).to eq(
        'have terms of service "https://example.com/terms"',
      )
    end
  end
end
