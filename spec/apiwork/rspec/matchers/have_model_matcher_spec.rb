# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveModelMatcher do
  let(:model_class) { Class.new }

  let(:representation) do
    klass = model_class
    obj = Object.new
    obj.define_singleton_method(:model_class) { klass }
    obj.define_singleton_method(:name) { 'TestRepresentation' }
    obj
  end

  describe '#matches?' do
    it 'returns true when model matches' do
      matcher = described_class.new(model_class)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when model does not match' do
      matcher = described_class.new(Class.new)

      expect(matcher.matches?(representation)).to be(false)
    end

    it 'includes actual class in failure message' do
      other = Class.new
      matcher = described_class.new(other)
      matcher.matches?(representation)

      expect(matcher.failure_message).to eq(
        "expected TestRepresentation to have model #{other.inspect}, but got #{model_class.inspect}",
      )
    end
  end

  describe '#description' do
    it 'includes the class' do
      expect(described_class.new(model_class).description).to eq(
        "have model #{model_class.inspect}",
      )
    end
  end
end
