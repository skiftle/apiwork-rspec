# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveTypeNameMatcher do
  let(:representation) do
    obj = Object.new
    obj.define_singleton_method(:type_name) { 'CustomInvoice' }
    obj.define_singleton_method(:name) { 'TestRepresentation' }
    obj
  end

  describe '#matches?' do
    it 'returns true when type name matches' do
      matcher = described_class.new('CustomInvoice')

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when type name does not match' do
      matcher = described_class.new('Other')

      expect(matcher.matches?(representation)).to be(false)
    end

    it 'includes actual type name in failure message' do
      matcher = described_class.new('Other')
      matcher.matches?(representation)

      expect(matcher.failure_message).to eq(
        'expected TestRepresentation to have type name "Other", but got "CustomInvoice"',
      )
    end
  end

  describe '#description' do
    it 'includes the type name' do
      expect(described_class.new('CustomInvoice').description).to eq(
        'have type name "CustomInvoice"',
      )
    end
  end
end
