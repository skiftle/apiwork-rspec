# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveExampleMatcher do
  describe '#matches?' do
    it 'returns true when example matches' do
      definition = build_type_definition(example: { street: '123 Main St' }, kind: :object, name: :address)
      matcher = described_class.new({ street: '123 Main St' })

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when example does not match' do
      definition = build_type_definition(example: { street: 'Other' }, kind: :object, name: :address)
      matcher = described_class.new({ street: '123 Main St' })

      expect(matcher.matches?(definition)).to be(false)
    end

    it 'includes actual example in failure message' do
      definition = build_type_definition(example: { street: 'Other' }, kind: :object, name: :address)
      matcher = described_class.new({ street: '123 Main St' })
      matcher.matches?(definition)

      expect(matcher.failure_message).to eq(
        "expected address to have example #{{ street: '123 Main St' }.inspect}, but got #{{ street: 'Other' }.inspect}",
      )
    end
  end

  describe '#description' do
    it 'returns expected description' do
      expect(described_class.new('draft').description).to eq('have example "draft"')
    end
  end
end
