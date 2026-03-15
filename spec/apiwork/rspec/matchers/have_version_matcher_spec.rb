# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveVersionMatcher do
  let(:info) do
    obj = Object.new
    obj.define_singleton_method(:version) { '1.0.0' }
    obj.define_singleton_method(:name) { 'test_info' }
    obj
  end

  describe '#matches?' do
    it 'returns true when version matches' do
      matcher = described_class.new('1.0.0')

      expect(matcher.matches?(info)).to be(true)
    end

    it 'returns false when version does not match' do
      matcher = described_class.new('2.0.0')

      expect(matcher.matches?(info)).to be(false)
    end

    it 'includes actual version in failure message' do
      matcher = described_class.new('2.0.0')
      matcher.matches?(info)

      expect(matcher.failure_message).to eq(
        'expected test_info to have version "2.0.0", but got "1.0.0"',
      )
    end
  end

  describe '#description' do
    it 'includes the version' do
      expect(described_class.new('1.0.0').description).to eq('have version "1.0.0"')
    end
  end
end
