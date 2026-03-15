# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveIdentifierMatcher do
  let(:contract) do
    obj = Object.new
    obj.define_singleton_method(:identifier) { :invoices }
    obj.define_singleton_method(:name) { 'TestContract' }
    obj
  end

  describe '#matches?' do
    it 'returns true when identifier matches' do
      matcher = described_class.new(:invoices)

      expect(matcher.matches?(contract)).to be(true)
    end

    it 'returns false when identifier does not match' do
      matcher = described_class.new(:payments)

      expect(matcher.matches?(contract)).to be(false)
    end

    it 'includes actual identifier in failure message' do
      matcher = described_class.new(:payments)
      matcher.matches?(contract)

      expect(matcher.failure_message).to eq(
        'expected TestContract to have identifier :payments, but got :invoices',
      )
    end
  end

  describe '#description' do
    it 'includes the identifier' do
      expect(described_class.new(:invoices).description).to eq('have identifier :invoices')
    end
  end
end
