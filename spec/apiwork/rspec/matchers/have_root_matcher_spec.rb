# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveRootMatcher do
  let(:root_key) do
    obj = Object.new
    obj.define_singleton_method(:singular) { :invoice }
    obj.define_singleton_method(:plural) { :invoices }
    obj
  end

  let(:representation) do
    key = root_key
    obj = Object.new
    obj.define_singleton_method(:root_key) { key }
    obj.define_singleton_method(:name) { 'TestRepresentation' }
    obj
  end

  describe '#matches?' do
    it 'returns true when root matches' do
      matcher = described_class.new(:invoice, :invoices)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when singular does not match' do
      matcher = described_class.new(:payment, :invoices)

      expect(matcher.matches?(representation)).to be(false)
    end

    it 'returns false when plural does not match' do
      matcher = described_class.new(:invoice, :payments)

      expect(matcher.matches?(representation)).to be(false)
    end

    it 'includes actual root in failure message' do
      matcher = described_class.new(:payment, :payments)
      matcher.matches?(representation)

      expect(matcher.failure_message).to eq(
        'expected TestRepresentation to have root :payment, :payments, but got :invoice, :invoices',
      )
    end
  end

  describe '#description' do
    it 'includes singular and plural' do
      expect(described_class.new(:invoice, :invoices).description).to eq(
        'have root :invoice, :invoices',
      )
    end
  end
end
