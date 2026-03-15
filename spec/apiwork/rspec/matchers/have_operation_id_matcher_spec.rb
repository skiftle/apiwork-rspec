# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveOperationIdMatcher do
  describe '#matches?' do
    it 'returns true when operation ID matches' do
      action = build_action(name: :create, operation_id: 'createInvoice')
      matcher = described_class.new('createInvoice')

      expect(matcher.matches?(action)).to be(true)
    end

    it 'returns false when operation ID does not match' do
      action = build_action(name: :create)
      matcher = described_class.new('createInvoice')

      expect(matcher.matches?(action)).to be(false)
    end

    it 'includes actual operation ID in failure message' do
      action = build_action(name: :create, operation_id: 'other')
      matcher = described_class.new('createInvoice')
      matcher.matches?(action)

      expect(matcher.failure_message).to eq(
        'expected create to have operation ID "createInvoice", but got "other"',
      )
    end
  end

  describe '#description' do
    it 'returns expected description' do
      expect(described_class.new('createInvoice').description).to eq('have operation ID "createInvoice"')
    end
  end
end
