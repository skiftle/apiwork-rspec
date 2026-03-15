# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveDiscriminatorMatcher do
  describe '#matches?' do
    it 'returns true when discriminator matches' do
      definition = build_type_definition(discriminator: :type, kind: :union, name: :target)
      matcher = described_class.new(:type)

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when discriminator does not match' do
      definition = build_type_definition(discriminator: :kind, kind: :union, name: :target)
      matcher = described_class.new(:type)

      expect(matcher.matches?(definition)).to be(false)
    end

    it 'includes actual discriminator in failure message' do
      definition = build_type_definition(discriminator: :kind, kind: :union, name: :target)
      matcher = described_class.new(:type)
      matcher.matches?(definition)

      expect(matcher.failure_message).to eq(
        'expected target to have discriminator :type, but got :kind',
      )
    end
  end

  describe '#description' do
    it 'returns expected description' do
      expect(described_class.new(:type).description).to eq('have discriminator :type')
    end
  end
end
