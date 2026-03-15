# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::DefineLicenseMatcher do
  let(:license) do
    obj = Object.new
    obj.define_singleton_method(:name) { 'MIT' }
    obj.define_singleton_method(:url) { 'https://opensource.org/licenses/MIT' }
    obj
  end

  let(:info) do
    l = license
    obj = Object.new
    obj.define_singleton_method(:license) { l }
    obj.define_singleton_method(:name) { 'test_info' }
    obj
  end

  describe '#matches?' do
    it 'returns true when license name matches' do
      matcher = described_class.new('MIT')

      expect(matcher.matches?(info)).to be(true)
    end

    it 'returns false when license is nil' do
      no_license = Object.new
      no_license.define_singleton_method(:license) { nil }
      no_license.define_singleton_method(:name) { 'test_info' }
      matcher = described_class.new('MIT')

      expect(matcher.matches?(no_license)).to be(false)
    end

    it 'returns false when license name does not match' do
      matcher = described_class.new('Apache')

      expect(matcher.matches?(info)).to be(false)
    end

    it 'includes actual name in failure message' do
      matcher = described_class.new('Apache')
      matcher.matches?(info)

      expect(matcher.failure_message).to eq(
        'expected test_info to define license "Apache", but got "MIT"',
      )
    end
  end

  describe '#with_url' do
    it 'returns true when url matches' do
      matcher = described_class.new('MIT').with_url('https://opensource.org/licenses/MIT')

      expect(matcher.matches?(info)).to be(true)
    end

    it 'returns false when url does not match' do
      matcher = described_class.new('MIT').with_url('https://other.com')

      expect(matcher.matches?(info)).to be(false)
    end

    it 'includes actual url in failure message' do
      matcher = described_class.new('MIT').with_url('https://other.com')
      matcher.matches?(info)

      expect(matcher.failure_message).to eq(
        'expected test_info to define license "MIT" with url "https://other.com", but got "https://opensource.org/licenses/MIT"',
      )
    end
  end

  describe '#description' do
    it 'includes the license name' do
      expect(described_class.new('MIT').description).to eq('define license "MIT"')
    end

    it 'includes url' do
      desc = described_class.new('MIT').with_url('https://mit.com').description

      expect(desc).to eq('define license "MIT" with url "https://mit.com"')
    end
  end
end
