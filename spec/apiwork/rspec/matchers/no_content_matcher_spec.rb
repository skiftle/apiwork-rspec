# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::NoContentMatcher do
  describe '#matches?' do
    it 'returns true when response has no content' do
      action = build_action(response: build_response(no_content: true))
      matcher = described_class.new

      expect(matcher.matches?(action)).to be(true)
    end

    it 'returns false when response has content' do
      action = build_action
      matcher = described_class.new

      expect(matcher.matches?(action)).to be(false)
    end

    it 'sets failure message when response has content' do
      action = build_action(name: :create)
      matcher = described_class.new
      matcher.matches?(action)

      expect(matcher.failure_message).to eq('expected create to be no content, but it has content')
    end
  end

  describe '#description' do
    it 'returns expected description' do
      expect(described_class.new.description).to eq('be no content')
    end
  end
end
