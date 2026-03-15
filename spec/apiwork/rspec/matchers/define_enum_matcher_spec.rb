# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::DefineEnumMatcher do
  let(:contract) { build_contract(enum_values: { status: %w[draft sent paid] }) }

  describe '#matches?' do
    it 'returns true when enum is defined' do
      matcher = described_class.new(:status)

      expect(matcher.matches?(contract)).to be(true)
    end

    it 'returns false when enum is not defined' do
      matcher = described_class.new(:missing)

      expect(matcher.matches?(contract)).to be(false)
    end

    it 'sets failure message when enum not found' do
      matcher = described_class.new(:missing)
      matcher.matches?(contract)

      expect(matcher.failure_message).to eq('expected TestContract to define enum :missing')
    end
  end

  describe '#with_values' do
    it 'returns true when values match' do
      matcher = described_class.new(:status).with_values(%w[draft sent paid])

      expect(matcher.matches?(contract)).to be(true)
    end

    it 'returns false when values do not match' do
      matcher = described_class.new(:status).with_values(%w[draft sent])

      expect(matcher.matches?(contract)).to be(false)
    end

    it 'includes actual values in failure message' do
      matcher = described_class.new(:status).with_values(%w[draft sent])
      matcher.matches?(contract)

      expect(matcher.failure_message).to include('with values ["draft", "sent"], but got ["draft", "sent", "paid"]')
    end
  end

  describe '#deprecated' do
    it 'returns true when enum is deprecated' do
      definition = build_enum_definition(deprecated: true, values: %w[old new])
      api = build_api(
        enum_registry: { legacy: definition },
        enum_values: { legacy: %w[old new] },
      )
      matcher = described_class.new(:legacy).deprecated

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false when enum is not deprecated' do
      definition = build_enum_definition(values: %w[draft sent paid])
      api = build_api(
        enum_registry: { status: definition },
        enum_values: { status: %w[draft sent paid] },
      )
      matcher = described_class.new(:status).deprecated

      expect(matcher.matches?(api)).to be(false)
    end

    it 'fails when subject does not support enum metadata' do
      matcher = described_class.new(:status).deprecated

      expect(matcher.matches?(contract)).to be(false)
      expect(matcher.failure_message).to include('support enum metadata')
    end
  end

  describe '#with_description' do
    it 'returns true when description matches' do
      definition = build_enum_definition(description: 'Invoice status', values: %w[draft sent])
      api = build_api(
        enum_registry: { status: definition },
        enum_values: { status: %w[draft sent] },
      )
      matcher = described_class.new(:status).with_description('Invoice status')

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false when description does not match' do
      definition = build_enum_definition(description: 'Other', values: %w[draft sent])
      api = build_api(
        enum_registry: { status: definition },
        enum_values: { status: %w[draft sent] },
      )
      matcher = described_class.new(:status).with_description('Invoice status')

      expect(matcher.matches?(api)).to be(false)
    end
  end

  describe '#with_example' do
    it 'returns true when example matches' do
      definition = build_enum_definition(example: 'draft', values: %w[draft sent])
      api = build_api(
        enum_registry: { status: definition },
        enum_values: { status: %w[draft sent] },
      )
      matcher = described_class.new(:status).with_example('draft')

      expect(matcher.matches?(api)).to be(true)
    end
  end

  describe 'with API subject' do
    it 'works with build_api' do
      api = build_api(enum_values: { priority: %w[low medium high] })
      matcher = described_class.new(:priority).with_values(%w[low medium high])

      expect(matcher.matches?(api)).to be(true)
    end
  end

  describe '#description' do
    it 'includes enum name' do
      expect(described_class.new(:status).description).to eq('define enum :status')
    end

    it 'includes values' do
      desc = described_class.new(:status).with_values(%w[draft sent]).description

      expect(desc).to eq('define enum :status with values ["draft", "sent"]')
    end

    it 'includes deprecated' do
      desc = described_class.new(:status).deprecated.description

      expect(desc).to eq('define enum :status that is deprecated')
    end
  end
end
