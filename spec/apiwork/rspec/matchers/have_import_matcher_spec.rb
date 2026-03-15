# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveImportMatcher do
  let(:shared_contract) { Class.new }

  let(:contract) do
    klass = shared_contract
    obj = Object.new
    obj.define_singleton_method(:imports) { { shared: klass } }
    obj.define_singleton_method(:name) { 'TestContract' }
    obj
  end

  describe '#matches?' do
    it 'returns true when import matches' do
      matcher = described_class.new(shared_contract, as: :shared)

      expect(matcher.matches?(contract)).to be(true)
    end

    it 'returns false when alias does not exist' do
      matcher = described_class.new(shared_contract, as: :other)

      expect(matcher.matches?(contract)).to be(false)
    end

    it 'returns false when class does not match' do
      matcher = described_class.new(Class.new, as: :shared)

      expect(matcher.matches?(contract)).to be(false)
    end

    it 'sets failure message when alias not found' do
      matcher = described_class.new(shared_contract, as: :other)
      matcher.matches?(contract)

      expect(matcher.failure_message).to eq(
        'expected TestContract to have import :other',
      )
    end

    it 'includes actual class in failure message when class does not match' do
      other = Class.new
      matcher = described_class.new(other, as: :shared)
      matcher.matches?(contract)

      expect(matcher.failure_message).to eq(
        "expected TestContract to have import :shared of #{other.inspect}, but got #{shared_contract.inspect}",
      )
    end
  end

  describe '#description' do
    it 'includes the class and alias' do
      expect(described_class.new(shared_contract, as: :shared).description).to eq(
        "have import #{shared_contract.inspect} as :shared",
      )
    end
  end
end
