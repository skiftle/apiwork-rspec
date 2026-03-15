# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::DefineServerMatcher do
  let(:server) do
    obj = Object.new
    obj.define_singleton_method(:url) { 'https://api.example.com' }
    obj.define_singleton_method(:description) { 'Production' }
    obj
  end

  let(:info) do
    s = server
    obj = Object.new
    obj.define_singleton_method(:servers) { [s] }
    obj.define_singleton_method(:name) { 'test_info' }
    obj
  end

  describe '#matches?' do
    it 'returns true when server exists' do
      matcher = described_class.new('https://api.example.com')

      expect(matcher.matches?(info)).to be(true)
    end

    it 'returns false when server does not exist' do
      matcher = described_class.new('https://other.com')

      expect(matcher.matches?(info)).to be(false)
    end

    it 'sets failure message when server not found' do
      matcher = described_class.new('https://other.com')
      matcher.matches?(info)

      expect(matcher.failure_message).to eq(
        'expected test_info to define server "https://other.com"',
      )
    end
  end

  describe '#with_description' do
    it 'returns true when description matches' do
      matcher = described_class.new('https://api.example.com').with_description('Production')

      expect(matcher.matches?(info)).to be(true)
    end

    it 'returns false when description does not match' do
      matcher = described_class.new('https://api.example.com').with_description('Staging')

      expect(matcher.matches?(info)).to be(false)
    end

    it 'includes actual description in failure message' do
      matcher = described_class.new('https://api.example.com').with_description('Staging')
      matcher.matches?(info)

      expect(matcher.failure_message).to eq(
        'expected test_info to define server "https://api.example.com" with description "Staging", but got "Production"',
      )
    end
  end

  describe '#description' do
    it 'includes the server url' do
      expect(described_class.new('https://api.example.com').description).to eq(
        'define server "https://api.example.com"',
      )
    end

    it 'includes description' do
      desc = described_class.new('https://api.example.com').with_description('Production').description

      expect(desc).to eq('define server "https://api.example.com" with description "Production"')
    end
  end
end
