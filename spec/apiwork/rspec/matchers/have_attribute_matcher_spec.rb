# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveAttributeMatcher do
  let(:attribute) { build_attribute(filterable: true, sortable: true, type: :string) }
  let(:representation) { build_representation(attributes: { number: attribute }) }

  describe '#matches?' do
    it 'returns true when attribute exists' do
      matcher = described_class.new(:number)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when attribute does not exist' do
      matcher = described_class.new(:missing)

      expect(matcher.matches?(representation)).to be(false)
    end

    it 'sets failure message when attribute not found' do
      matcher = described_class.new(:missing)
      matcher.matches?(representation)

      expect(matcher.failure_message).to eq('expected TestRepresentation to have attribute :missing')
    end
  end

  describe '#of_type' do
    it 'returns true when type matches' do
      matcher = described_class.new(:number).of_type(:string)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when type does not match' do
      matcher = described_class.new(:number).of_type(:integer)

      expect(matcher.matches?(representation)).to be(false)
    end

    it 'includes actual type in failure message' do
      matcher = described_class.new(:number).of_type(:integer)
      matcher.matches?(representation)

      expect(matcher.failure_message).to include('of type :integer, but got :string')
    end
  end

  describe '#writable' do
    context 'without action scope' do
      it 'returns true when writable' do
        representation = build_representation(attributes: { number: build_attribute(writable: true) })
        matcher = described_class.new(:number).writable

        expect(matcher.matches?(representation)).to be(true)
      end

      it 'returns false when not writable' do
        matcher = described_class.new(:number).writable

        expect(matcher.matches?(representation)).to be(false)
      end
    end

    context 'with action scope' do
      it 'returns true when writable for action' do
        representation = build_representation(attributes: { number: build_attribute(writable: :create) })
        matcher = described_class.new(:number).writable(:create)

        expect(matcher.matches?(representation)).to be(true)
      end

      it 'returns false when not writable for action' do
        representation = build_representation(attributes: { number: build_attribute(writable: :update) })
        matcher = described_class.new(:number).writable(:create)

        expect(matcher.matches?(representation)).to be(false)
      end
    end
  end

  describe '#empty' do
    it 'returns true when empty' do
      representation = build_representation(attributes: { notes: build_attribute(empty: true, type: :string) })
      matcher = described_class.new(:notes).empty

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not empty' do
      matcher = described_class.new(:number).empty

      expect(matcher.matches?(representation)).to be(false)
    end

    it 'includes failure details' do
      matcher = described_class.new(:number).empty
      matcher.matches?(representation)

      expect(matcher.failure_message).to include('that is empty, but it is not')
    end
  end

  describe '#deprecated' do
    it 'returns true when deprecated' do
      representation = build_representation(attributes: { number: build_attribute(deprecated: true) })
      matcher = described_class.new(:number).deprecated

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not deprecated' do
      matcher = described_class.new(:number).deprecated

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#optional' do
    it 'returns true when optional' do
      representation = build_representation(attributes: { number: build_attribute(optional: true) })
      matcher = described_class.new(:number).optional

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not optional' do
      matcher = described_class.new(:number).optional

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#nullable' do
    it 'returns true when nullable' do
      representation = build_representation(attributes: { number: build_attribute(nullable: true) })
      matcher = described_class.new(:number).nullable

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not nullable' do
      matcher = described_class.new(:number).nullable

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#filterable' do
    it 'returns true when filterable' do
      matcher = described_class.new(:number).filterable

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not filterable' do
      representation = build_representation(attributes: { number: build_attribute })
      matcher = described_class.new(:number).filterable

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#sortable' do
    it 'returns true when sortable' do
      matcher = described_class.new(:number).sortable

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not sortable' do
      representation = build_representation(attributes: { number: build_attribute })
      matcher = described_class.new(:number).sortable

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_enum' do
    it 'returns true when enum matches' do
      representation = build_representation(attributes: { status: build_attribute(enum: %w[draft sent]) })
      matcher = described_class.new(:status).with_enum(%w[draft sent])

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when enum does not match' do
      representation = build_representation(attributes: { status: build_attribute(enum: %w[draft sent]) })
      matcher = described_class.new(:status).with_enum(%w[draft paid])

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_format' do
    it 'returns true when format matches' do
      representation = build_representation(attributes: { email: build_attribute(format: :email) })
      matcher = described_class.new(:email).with_format(:email)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when format does not match' do
      representation = build_representation(attributes: { email: build_attribute(format: :url) })
      matcher = described_class.new(:email).with_format(:email)

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_min' do
    it 'returns true when min matches' do
      representation = build_representation(attributes: { amount: build_attribute(min: 0) })
      matcher = described_class.new(:amount).with_min(0)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when min does not match' do
      representation = build_representation(attributes: { amount: build_attribute(min: 1) })
      matcher = described_class.new(:amount).with_min(0)

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_max' do
    it 'returns true when max matches' do
      representation = build_representation(attributes: { number: build_attribute(max: 255) })
      matcher = described_class.new(:number).with_max(255)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when max does not match' do
      representation = build_representation(attributes: { number: build_attribute(max: 100) })
      matcher = described_class.new(:number).with_max(255)

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_default' do
    it 'returns true when default matches' do
      representation = build_representation(attributes: { status: build_attribute(default: 'draft') })
      matcher = described_class.new(:status).with_default('draft')

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when default does not match' do
      representation = build_representation(attributes: { status: build_attribute(default: 'sent') })
      matcher = described_class.new(:status).with_default('draft')

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_description' do
    it 'returns true when description matches' do
      representation = build_representation(attributes: { number: build_attribute(description: 'Invoice number') })
      matcher = described_class.new(:number).with_description('Invoice number')

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when description does not match' do
      representation = build_representation(attributes: { number: build_attribute(description: 'Other') })
      matcher = described_class.new(:number).with_description('Invoice number')

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_example' do
    it 'returns true when example matches' do
      representation = build_representation(attributes: { number: build_attribute(example: 'INV-001') })
      matcher = described_class.new(:number).with_example('INV-001')

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when example does not match' do
      representation = build_representation(attributes: { number: build_attribute(example: 'INV-999') })
      matcher = described_class.new(:number).with_example('INV-001')

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe 'chaining' do
    it 'verifies multiple chains together' do
      representation = build_representation(
        attributes: {
          amount: build_attribute(filterable: true, min: 0, sortable: true, type: :integer),
        },
      )
      matcher = described_class.new(:amount).of_type(:integer).filterable.sortable.with_min(0)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'fails on first mismatched chain' do
      matcher = described_class.new(:number).of_type(:integer).filterable

      expect(matcher.matches?(representation)).to be(false)
      expect(matcher.failure_message).to include('of type :integer, but got :string')
    end
  end

  describe '#description' do
    it 'includes attribute name' do
      expect(described_class.new(:number).description).to eq('have attribute :number')
    end

    it 'includes type' do
      expect(described_class.new(:number).of_type(:string).description).to eq('have attribute :number of type :string')
    end

    it 'includes boolean chains' do
      matcher = described_class.new(:number).filterable.sortable

      expect(matcher.description).to eq('have attribute :number that is filterable and sortable')
    end
  end

  describe '#failure_message_when_negated' do
    it 'returns negated description' do
      matcher = described_class.new(:number).of_type(:string)
      matcher.matches?(representation)

      expect(matcher.failure_message_when_negated).to eq(
        'expected TestRepresentation not to have attribute :number of type :string',
      )
    end
  end
end
