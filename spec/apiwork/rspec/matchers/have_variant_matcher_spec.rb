# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveVariantMatcher do
  let(:definition) do
    build_type_definition(
      kind: :union,
      variants: [
        { tag: 'user', type: :user },
        { tag: 'team', type: :team },
        { deprecated: true, description: 'Use user instead', tag: 'legacy', type: :legacy },
        { partial: true, tag: 'partial_user', type: :user },
      ],
    )
  end

  describe '#matches?' do
    it 'returns true when variant exists' do
      matcher = described_class.new(:user)

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when variant does not exist' do
      matcher = described_class.new(:missing)

      expect(matcher.matches?(definition)).to be(false)
    end

    it 'sets failure message when variant not found' do
      matcher = described_class.new(:missing)
      matcher.matches?(definition)

      expect(matcher.failure_message).to eq('expected test_type to have variant :missing')
    end
  end

  describe '#of_type' do
    it 'returns true when type matches' do
      matcher = described_class.new(:user).of_type(:user)

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when type does not match' do
      matcher = described_class.new(:user).of_type(:admin)

      expect(matcher.matches?(definition)).to be(false)
    end

    it 'includes actual type in failure message' do
      matcher = described_class.new(:user).of_type(:admin)
      matcher.matches?(definition)

      expect(matcher.failure_message).to eq(
        'expected test_type to have variant :user of type :admin, but got :user',
      )
    end
  end

  describe '#deprecated' do
    it 'returns true when deprecated' do
      matcher = described_class.new(:legacy).deprecated

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when not deprecated' do
      matcher = described_class.new(:user).deprecated

      expect(matcher.matches?(definition)).to be(false)
    end

    it 'includes failure message' do
      matcher = described_class.new(:user).deprecated
      matcher.matches?(definition)

      expect(matcher.failure_message).to eq(
        'expected test_type to have variant :user that is deprecated, but it is not',
      )
    end
  end

  describe '#partial' do
    it 'returns true when partial' do
      matcher = described_class.new(:partial_user).partial

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when not partial' do
      matcher = described_class.new(:user).partial

      expect(matcher.matches?(definition)).to be(false)
    end
  end

  describe '#with_description' do
    it 'returns true when description matches' do
      matcher = described_class.new(:legacy).with_description('Use user instead')

      expect(matcher.matches?(definition)).to be(true)
    end

    it 'returns false when description does not match' do
      matcher = described_class.new(:legacy).with_description('Other')

      expect(matcher.matches?(definition)).to be(false)
    end

    it 'includes actual description in failure message' do
      matcher = described_class.new(:legacy).with_description('Other')
      matcher.matches?(definition)

      expect(matcher.failure_message).to eq(
        'expected test_type to have variant :legacy with description "Other", but got "Use user instead"',
      )
    end
  end

  describe '#description' do
    it 'includes variant name' do
      expect(described_class.new(:user).description).to eq('have variant :user')
    end

    it 'includes type' do
      desc = described_class.new(:user).of_type(:user).description

      expect(desc).to eq('have variant :user of type :user')
    end
  end
end
