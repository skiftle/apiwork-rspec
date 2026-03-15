# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveRepresentationMatcher do
  let(:representation_class) { Class.new }

  let(:contract) do
    klass = representation_class
    obj = Object.new
    obj.define_singleton_method(:representation_class) { klass }
    obj.define_singleton_method(:name) { 'TestContract' }
    obj
  end

  describe '#matches?' do
    it 'returns true when representation matches' do
      matcher = described_class.new(representation_class)

      expect(matcher.matches?(contract)).to be(true)
    end

    it 'returns false when representation does not match' do
      matcher = described_class.new(Class.new)

      expect(matcher.matches?(contract)).to be(false)
    end

    it 'includes actual class in failure message' do
      other = Class.new
      matcher = described_class.new(other)
      matcher.matches?(contract)

      expect(matcher.failure_message).to eq(
        "expected TestContract to have representation #{other.inspect}, but got #{representation_class.inspect}",
      )
    end
  end

  describe '#description' do
    it 'includes the class' do
      expect(described_class.new(representation_class).description).to eq(
        "have representation #{representation_class.inspect}",
      )
    end
  end
end
