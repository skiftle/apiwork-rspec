# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveExportMatcher do
  let(:api) do
    obj = Object.new
    obj.define_singleton_method(:export_configs) { { openapi: true, typescript: true } }
    obj.define_singleton_method(:name) { 'TestApi' }
    obj
  end

  describe '#matches?' do
    it 'returns true when export exists' do
      matcher = described_class.new(:openapi)

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false when export does not exist' do
      matcher = described_class.new(:zod)

      expect(matcher.matches?(api)).to be(false)
    end

    it 'sets failure message when export not found' do
      matcher = described_class.new(:zod)
      matcher.matches?(api)

      expect(matcher.failure_message).to eq(
        'expected TestApi to have export :zod',
      )
    end
  end

  describe '#description' do
    it 'includes the export name' do
      expect(described_class.new(:openapi).description).to eq('have export :openapi')
    end
  end
end
