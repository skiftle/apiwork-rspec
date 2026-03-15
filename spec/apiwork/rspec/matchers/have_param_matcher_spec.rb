# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveParamMatcher do
  let(:definition) do
    build_type_definition(
      params: {
        street: { deprecated: false, nullable: false, optional: false, type: :string },
        zip: { optional: true, type: :string },
      },
    )
  end

  describe '#matches?' do
    it 'returns true when param exists' do
      matcher = described_class.new(:street)

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when param does not exist' do
      matcher = described_class.new(:missing)

      expect(matcher.matches?(definition)).to be(false)
    end

    it 'sets failure message when param not found' do
      matcher = described_class.new(:missing)
      matcher.matches?(definition)

      expect(matcher.failure_message).to eq('expected test_type to have param :missing')
    end
  end

  describe '#of_type' do
    it 'returns true when type matches' do
      matcher = described_class.new(:street).of_type(:string)

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when type does not match' do
      matcher = described_class.new(:street).of_type(:integer)

      expect(matcher.matches?(definition)).to be(false)
    end

    it 'includes actual type in failure message' do
      matcher = described_class.new(:street).of_type(:integer)
      matcher.matches?(definition)

      expect(matcher.failure_message).to include('of type :integer, but got :string')
    end
  end

  describe '#required' do
    it 'returns true when param is required' do
      matcher = described_class.new(:street).required

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when param is optional' do
      matcher = described_class.new(:zip).required

      expect(matcher.matches?(definition)).to be(false)
    end
  end

  describe '#optional' do
    it 'returns true when param is optional' do
      matcher = described_class.new(:zip).optional

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when param is required' do
      matcher = described_class.new(:street).optional

      expect(matcher.matches?(definition)).to be(false)
    end
  end

  describe '#nullable' do
    it 'returns true when param is nullable' do
      nullable_definition = build_type_definition(
        params: { notes: { nullable: true, type: :string } },
      )
      matcher = described_class.new(:notes).nullable

      expect(matcher.matches?(nullable_definition)).to be(true)
    end

    it 'returns false when param is not nullable' do
      matcher = described_class.new(:street).nullable

      expect(matcher.matches?(definition)).to be(false)
    end
  end

  describe '#deprecated' do
    it 'returns true when param is deprecated' do
      deprecated_definition = build_type_definition(
        params: { old_field: { deprecated: true, type: :string } },
      )
      matcher = described_class.new(:old_field).deprecated

      expect(matcher.matches?(deprecated_definition)).to be(true)
    end

    it 'returns false when param is not deprecated' do
      matcher = described_class.new(:street).deprecated

      expect(matcher.matches?(definition)).to be(false)
    end
  end

  describe '#with_enum' do
    it 'returns true when enum matches' do
      enum_definition = build_type_definition(
        params: { status: { enum: %w[draft sent], type: :string } },
      )
      matcher = described_class.new(:status).with_enum(%w[draft sent])

      expect(matcher.matches?(enum_definition)).to be(true)
    end

    it 'returns false when enum does not match' do
      enum_definition = build_type_definition(
        params: { status: { enum: %w[draft sent], type: :string } },
      )
      matcher = described_class.new(:status).with_enum(%w[draft paid])

      expect(matcher.matches?(enum_definition)).to be(false)
    end
  end

  describe '#with_min' do
    it 'returns true when min matches' do
      min_definition = build_type_definition(
        params: { amount: { min: 0, type: :integer } },
      )
      matcher = described_class.new(:amount).with_min(0)

      expect(matcher.matches?(min_definition)).to be(true)
    end
  end

  describe '#with_max' do
    it 'returns true when max matches' do
      max_definition = build_type_definition(
        params: { count: { max: 100, type: :integer } },
      )
      matcher = described_class.new(:count).with_max(100)

      expect(matcher.matches?(max_definition)).to be(true)
    end
  end

  describe '#with_default' do
    it 'returns true when default matches' do
      default_definition = build_type_definition(
        params: { status: { default: 'draft', type: :string } },
      )
      matcher = described_class.new(:status).with_default('draft')

      expect(matcher.matches?(default_definition)).to be(true)
    end
  end

  describe '#with_format' do
    it 'returns true when format matches' do
      format_definition = build_type_definition(
        params: { email: { format: :email, type: :string } },
      )
      matcher = described_class.new(:email).with_format(:email)

      expect(matcher.matches?(format_definition)).to be(true)
    end
  end

  describe '#with_description' do
    it 'returns true when description matches' do
      desc_definition = build_type_definition(
        params: { street: { description: 'Street name', type: :string } },
      )
      matcher = described_class.new(:street).with_description('Street name')

      expect(matcher.matches?(desc_definition)).to be(true)
    end
  end

  describe '#with_example' do
    it 'returns true when example matches' do
      example_definition = build_type_definition(
        params: { street: { example: '123 Main St', type: :string } },
      )
      matcher = described_class.new(:street).with_example('123 Main St')

      expect(matcher.matches?(example_definition)).to be(true)
    end
  end

  describe 'chaining' do
    it 'verifies multiple chains together' do
      matcher = described_class.new(:street).of_type(:string).required

      expect(matcher.matches?(definition)).to be(true)
    end
  end

  describe '#description' do
    it 'includes param name' do
      expect(described_class.new(:street).description).to eq('have param :street')
    end

    it 'includes type' do
      desc = described_class.new(:street).of_type(:string).description

      expect(desc).to eq('have param :street of type :string')
    end

    it 'includes boolean chains' do
      desc = described_class.new(:street).nullable.required.description

      expect(desc).to eq('have param :street that is nullable and required')
    end
  end
end
