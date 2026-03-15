# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveSummaryMatcher do
  describe '#matches?' do
    it 'returns true when summary matches' do
      action = build_action(name: :create, summary: 'Create invoice')
      matcher = described_class.new('Create invoice')

      expect(matcher.matches?(action)).to be(true)
    end

    it 'returns false when summary does not match' do
      action = build_action(name: :create, summary: 'Other')
      matcher = described_class.new('Create invoice')

      expect(matcher.matches?(action)).to be(false)
    end

    it 'includes actual summary in failure message' do
      action = build_action(name: :create, summary: 'Other')
      matcher = described_class.new('Create invoice')
      matcher.matches?(action)

      expect(matcher.failure_message).to eq(
        'expected create to have summary "Create invoice", but got "Other"',
      )
    end
  end

  describe '#description' do
    it 'returns expected description' do
      expect(described_class.new('Create invoice').description).to eq('have summary "Create invoice"')
    end
  end
end
