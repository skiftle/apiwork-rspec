# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::HaveResourceMatcher do
  let(:lines_resource) { build_resource }
  let(:invoices_resource) { build_resource(resources: { lines: lines_resource }) }
  let(:api) { build_api(resources: { invoices: invoices_resource }) }

  describe '#matches?' do
    it 'returns true when resource exists' do
      matcher = described_class.new(:invoices)

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false when resource does not exist' do
      matcher = described_class.new(:missing)

      expect(matcher.matches?(api)).to be(false)
    end

    it 'sets failure message when resource not found' do
      matcher = described_class.new(:missing)
      matcher.matches?(api)

      expect(matcher.failure_message).to eq('expected TestApi to have resource :missing')
    end
  end

  describe '#under' do
    it 'returns true when nested resource exists' do
      matcher = described_class.new(:lines).under(:invoices)

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false when nested resource does not exist' do
      matcher = described_class.new(:missing).under(:invoices)

      expect(matcher.matches?(api)).to be(false)
    end

    it 'returns false when parent does not exist' do
      matcher = described_class.new(:lines).under(:orders)

      expect(matcher.matches?(api)).to be(false)
    end

    it 'includes parent in failure message when parent not found' do
      matcher = described_class.new(:lines).under(:orders)
      matcher.matches?(api)

      expect(matcher.failure_message).to include(':orders was not found')
    end

    it 'supports deep nesting' do
      adjustments = build_resource
      lines = build_resource(resources: { adjustments: })
      invoices = build_resource(resources: { lines: })
      api = build_api(resources: { invoices: })
      matcher = described_class.new(:adjustments).under(:invoices, :lines)

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false for deep nesting when leaf not found' do
      matcher = described_class.new(:missing).under(:invoices, :lines)

      expect(matcher.matches?(api)).to be(false)
    end
  end

  describe '#singular' do
    it 'returns true when resource is singular' do
      api = build_api(resources: { profile: build_resource(singular: true) })
      matcher = described_class.new(:profile).singular

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false when resource is not singular' do
      matcher = described_class.new(:invoices).singular

      expect(matcher.matches?(api)).to be(false)
    end

    it 'includes failure details' do
      matcher = described_class.new(:invoices).singular
      matcher.matches?(api)

      expect(matcher.failure_message).to include('that is singular, but it is not')
    end
  end

  describe '#with_only' do
    it 'returns true when only matches' do
      api = build_api(resources: { invoices: build_resource(only: %i[index show]) })
      matcher = described_class.new(:invoices).with_only(:index, :show)

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false when only does not match' do
      api = build_api(resources: { invoices: build_resource(only: %i[index]) })
      matcher = described_class.new(:invoices).with_only(:index, :show)

      expect(matcher.matches?(api)).to be(false)
    end

    it 'includes failure details' do
      api = build_api(resources: { invoices: build_resource(only: %i[index]) })
      matcher = described_class.new(:invoices).with_only(:index, :show)
      matcher.matches?(api)

      expect(matcher.failure_message).to include('with only [:index, :show], but got [:index]')
    end
  end

  describe '#with_except' do
    it 'returns true when except matches' do
      api = build_api(resources: { invoices: build_resource(except: %i[destroy]) })
      matcher = described_class.new(:invoices).with_except(:destroy)

      expect(matcher.matches?(api)).to be(true)
    end

    it 'returns false when except does not match' do
      api = build_api(resources: { invoices: build_resource(except: %i[destroy update]) })
      matcher = described_class.new(:invoices).with_except(:destroy)

      expect(matcher.matches?(api)).to be(false)
    end
  end

  describe 'chaining' do
    it 'combines under and singular' do
      profile = build_resource(singular: true)
      organizations = build_resource(resources: { profile: })
      api = build_api(resources: { organizations: })
      matcher = described_class.new(:profile).under(:organizations).singular

      expect(matcher.matches?(api)).to be(true)
    end
  end

  describe '#description' do
    it 'includes resource name' do
      expect(described_class.new(:invoices).description).to eq('have resource :invoices')
    end

    it 'includes under' do
      desc = described_class.new(:lines).under(:invoices).description

      expect(desc).to eq('have resource :lines under :invoices')
    end

    it 'includes deep under' do
      desc = described_class.new(:adjustments).under(:invoices, :lines).description

      expect(desc).to eq('have resource :adjustments under :invoices, :lines')
    end

    it 'includes singular' do
      desc = described_class.new(:profile).singular.description

      expect(desc).to eq('have resource :profile that is singular')
    end

    it 'includes only' do
      desc = described_class.new(:invoices).with_only(:index, :show).description

      expect(desc).to eq('have resource :invoices with only [:index, :show]')
    end

    it 'includes except' do
      desc = described_class.new(:invoices).with_except(:destroy).description

      expect(desc).to eq('have resource :invoices with except [:destroy]')
    end
  end
end
