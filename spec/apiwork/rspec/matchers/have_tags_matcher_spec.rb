# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveTagsMatcher do
  describe '#matches?' do
    it 'returns true when tags match' do
      action = build_action(name: :create, tags: %i[billing admin])
      matcher = described_class.new(%i[billing admin])

      expect(matcher.matches?(action)).to be(true)
    end

    it 'returns false when tags do not match' do
      action = build_action(name: :create, tags: %i[billing])
      matcher = described_class.new(%i[billing admin])

      expect(matcher.matches?(action)).to be(false)
    end

    it 'includes actual tags in failure message' do
      action = build_action(name: :create, tags: %i[billing])
      matcher = described_class.new(%i[billing admin])
      matcher.matches?(action)

      expect(matcher.failure_message).to eq(
        'expected create to have tags [:billing, :admin], but got [:billing]',
      )
    end
  end

  describe '#description' do
    it 'returns expected description' do
      expect(described_class.new(%i[billing admin]).description).to eq('have tags [:billing, :admin]')
    end
  end
end
