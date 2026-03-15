# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::DefineContactMatcher do
  let(:contact) do
    obj = Object.new
    obj.define_singleton_method(:name) { 'API Support' }
    obj.define_singleton_method(:email) { 'support@example.com' }
    obj.define_singleton_method(:url) { 'https://example.com/support' }
    obj
  end

  let(:info) do
    c = contact
    obj = Object.new
    obj.define_singleton_method(:contact) { c }
    obj.define_singleton_method(:name) { 'test_info' }
    obj
  end

  describe '#matches?' do
    it 'returns true when contact name matches' do
      matcher = described_class.new('API Support')

      expect(matcher.matches?(info)).to be(true)
    end

    it 'returns false when contact is nil' do
      no_contact = Object.new
      no_contact.define_singleton_method(:contact) { nil }
      no_contact.define_singleton_method(:name) { 'test_info' }
      matcher = described_class.new('API Support')

      expect(matcher.matches?(no_contact)).to be(false)
    end

    it 'returns false when contact name does not match' do
      matcher = described_class.new('Other')

      expect(matcher.matches?(info)).to be(false)
    end

    it 'includes actual name in failure message' do
      matcher = described_class.new('Other')
      matcher.matches?(info)

      expect(matcher.failure_message).to eq(
        'expected test_info to define contact "Other", but got "API Support"',
      )
    end
  end

  describe '#with_email' do
    it 'returns true when email matches' do
      matcher = described_class.new('API Support').with_email('support@example.com')

      expect(matcher.matches?(info)).to be(true)
    end

    it 'returns false when email does not match' do
      matcher = described_class.new('API Support').with_email('other@example.com')

      expect(matcher.matches?(info)).to be(false)
    end

    it 'includes actual email in failure message' do
      matcher = described_class.new('API Support').with_email('other@example.com')
      matcher.matches?(info)

      expect(matcher.failure_message).to eq(
        'expected test_info to define contact "API Support" with email "other@example.com", but got "support@example.com"',
      )
    end
  end

  describe '#with_url' do
    it 'returns true when url matches' do
      matcher = described_class.new('API Support').with_url('https://example.com/support')

      expect(matcher.matches?(info)).to be(true)
    end

    it 'returns false when url does not match' do
      matcher = described_class.new('API Support').with_url('https://other.com')

      expect(matcher.matches?(info)).to be(false)
    end
  end

  describe '#description' do
    it 'includes the contact name' do
      expect(described_class.new('API Support').description).to eq('define contact "API Support"')
    end

    it 'includes email and url' do
      desc = described_class.new('API Support').with_email('a@b.com').with_url('https://b.com').description

      expect(desc).to eq('define contact "API Support" with email "a@b.com" with url "https://b.com"')
    end
  end
end
