# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveAssociationMatcher do
  let(:association) { build_association(type: :has_many, writable: true) }
  let(:representation) { build_representation(associations: { lines: association }) }

  describe '#matches?' do
    it 'returns true when association exists' do
      matcher = described_class.new(:lines)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when association does not exist' do
      matcher = described_class.new(:missing)

      expect(matcher.matches?(representation)).to be(false)
    end

    it 'sets failure message when association not found' do
      matcher = described_class.new(:missing)
      matcher.matches?(representation)

      expect(matcher.failure_message).to eq('expected TestRepresentation to have association :missing')
    end
  end

  describe '#of_type' do
    it 'returns true when type matches' do
      matcher = described_class.new(:lines).of_type(:has_many)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when type does not match' do
      matcher = described_class.new(:lines).of_type(:belongs_to)

      expect(matcher.matches?(representation)).to be(false)
    end

    it 'includes actual type in failure message' do
      matcher = described_class.new(:lines).of_type(:belongs_to)
      matcher.matches?(representation)

      expect(matcher.failure_message).to include('of type :belongs_to, but got :has_many')
    end
  end

  describe '#writable' do
    context 'without action scope' do
      it 'returns true when writable' do
        matcher = described_class.new(:lines).writable

        expect(matcher.matches?(representation)).to be(true)
      end

      it 'returns false when not writable' do
        representation = build_representation(associations: { lines: build_association(writable: false) })
        matcher = described_class.new(:lines).writable

        expect(matcher.matches?(representation)).to be(false)
      end
    end

    context 'with action scope' do
      it 'returns true when writable for action' do
        representation = build_representation(associations: { lines: build_association(writable: :create) })
        matcher = described_class.new(:lines).writable(:create)

        expect(matcher.matches?(representation)).to be(true)
      end

      it 'returns false when not writable for action' do
        representation = build_representation(
          associations: { lines: build_association(writable: :update) },
        )
        matcher = described_class.new(:lines).writable(:create)

        expect(matcher.matches?(representation)).to be(false)
      end
    end
  end

  describe '#deprecated' do
    it 'returns true when deprecated' do
      representation = build_representation(associations: { lines: build_association(deprecated: true) })
      matcher = described_class.new(:lines).deprecated

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not deprecated' do
      matcher = described_class.new(:lines).deprecated

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#nullable' do
    it 'returns true when nullable' do
      representation = build_representation(associations: { customer: build_association(nullable: true) })
      matcher = described_class.new(:customer).nullable

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not nullable' do
      matcher = described_class.new(:lines).nullable

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#polymorphic' do
    it 'returns true when polymorphic' do
      representation = build_representation(associations: { target: build_association(polymorphic: true) })
      matcher = described_class.new(:target).polymorphic

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not polymorphic' do
      matcher = described_class.new(:lines).polymorphic

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#filterable' do
    it 'returns true when filterable' do
      representation = build_representation(associations: { customer: build_association(filterable: true) })
      matcher = described_class.new(:customer).filterable

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not filterable' do
      matcher = described_class.new(:lines).filterable

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#sortable' do
    it 'returns true when sortable' do
      representation = build_representation(associations: { customer: build_association(sortable: true) })
      matcher = described_class.new(:customer).sortable

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not sortable' do
      matcher = described_class.new(:lines).sortable

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#allow_destroy' do
    it 'returns true when allow_destroy' do
      representation = build_representation(associations: { lines: build_association(allow_destroy: true) })
      matcher = described_class.new(:lines).allow_destroy

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when not allow_destroy' do
      matcher = described_class.new(:lines).allow_destroy

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_include' do
    it 'returns true when include matches' do
      representation = build_representation(
        associations: { lines: build_association(include_strategy: :always) },
      )
      matcher = described_class.new(:lines).with_include(:always)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when include does not match' do
      matcher = described_class.new(:lines).with_include(:always)

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_representation' do
    it 'returns true when representation matches' do
      klass = Class.new
      representation = build_representation(
        associations: { lines: build_association(representation_class: klass) },
      )
      matcher = described_class.new(:lines).with_representation(klass)

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when representation does not match' do
      matcher = described_class.new(:lines).with_representation(Class.new)

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_description' do
    it 'returns true when description matches' do
      representation = build_representation(
        associations: { lines: build_association(description: 'Invoice line items') },
      )
      matcher = described_class.new(:lines).with_description('Invoice line items')

      expect(matcher.matches?(representation)).to be(true)
    end

    it 'returns false when description does not match' do
      matcher = described_class.new(:lines).with_description('Invoice line items')

      expect(matcher.matches?(representation)).to be(false)
    end
  end

  describe '#with_example' do
    it 'returns true when example matches' do
      representation = build_representation(
        associations: { lines: build_association(example: [{ id: 1 }]) },
      )
      matcher = described_class.new(:lines).with_example([{ id: 1 }])

      expect(matcher.matches?(representation)).to be(true)
    end
  end

  describe 'chaining' do
    it 'verifies multiple chains together' do
      matcher = described_class.new(:lines).of_type(:has_many).writable

      expect(matcher.matches?(representation)).to be(true)
    end
  end

  describe '#description' do
    it 'includes association name' do
      expect(described_class.new(:lines).description).to eq('have association :lines')
    end

    it 'includes type' do
      desc = described_class.new(:lines).of_type(:has_many).description

      expect(desc).to eq('have association :lines of type :has_many')
    end
  end
end
