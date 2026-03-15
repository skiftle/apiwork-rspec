# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveRaisesMatcher do
  describe '#matches?' do
    it 'returns true when raises match' do
      action = build_action(name: :create, raises: %i[not_found conflict])
      matcher = described_class.new(%i[not_found conflict])

      expect(matcher.matches?(action)).to be(true)
    end

    it 'returns false when raises do not match' do
      action = build_action(name: :create, raises: %i[not_found])
      matcher = described_class.new(%i[not_found conflict])

      expect(matcher.matches?(action)).to be(false)
    end

    it 'includes actual raises in failure message' do
      action = build_action(name: :create, raises: %i[not_found])
      matcher = described_class.new(%i[not_found conflict])
      matcher.matches?(action)

      expect(matcher.failure_message).to eq(
        'expected create to have raises [:not_found, :conflict], but got [:not_found]',
      )
    end
  end

  describe '#description' do
    it 'returns expected description' do
      expect(described_class.new(%i[not_found conflict]).description).to eq(
        'have raises [:not_found, :conflict]',
      )
    end
  end
end
