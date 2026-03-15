# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveDescriptionMatcher do
  describe '#matches?' do
    it 'returns true when description matches' do
      action = build_action(description: 'Creates a new invoice', name: :create)
      matcher = described_class.new('Creates a new invoice')

      expect(matcher.matches?(action)).to be(true)
    end

    it 'returns false when description does not match' do
      action = build_action(description: 'Other', name: :create)
      matcher = described_class.new('Creates a new invoice')

      expect(matcher.matches?(action)).to be(false)
    end

    it 'includes actual description in failure message' do
      action = build_action(description: 'Other', name: :create)
      matcher = described_class.new('Creates a new invoice')
      matcher.matches?(action)

      expect(matcher.failure_message).to eq(
        'expected create to have description "Creates a new invoice", but got "Other"',
      )
    end
  end

  describe '#description' do
    it 'returns expected description' do
      expect(described_class.new('Creates a new invoice').description).to eq(
        'have description "Creates a new invoice"',
      )
    end
  end
end
