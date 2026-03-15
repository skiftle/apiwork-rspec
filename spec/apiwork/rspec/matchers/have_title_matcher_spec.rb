# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveTitleMatcher do
  let(:info) do
    obj = Object.new
    obj.define_singleton_method(:title) { 'Billing API' }
    obj.define_singleton_method(:name) { 'test_info' }
    obj
  end

  describe '#matches?' do
    it 'returns true when title matches' do
      matcher = described_class.new('Billing API')

      expect(matcher.matches?(info)).to be(true)
    end

    it 'returns false when title does not match' do
      matcher = described_class.new('Other')

      expect(matcher.matches?(info)).to be(false)
    end

    it 'includes actual title in failure message' do
      matcher = described_class.new('Other')
      matcher.matches?(info)

      expect(matcher.failure_message).to eq(
        'expected test_info to have title "Other", but got "Billing API"',
      )
    end
  end

  describe '#description' do
    it 'includes the title' do
      expect(described_class.new('Billing API').description).to eq('have title "Billing API"')
    end
  end
end
