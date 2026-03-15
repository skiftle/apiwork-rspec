# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apiwork::RSpec::Matchers::ClassMethods do
  describe '.describe_action' do
    subject { contract }

    let(:body) { build_body(params: { title: { type: :string } }) }
    let(:action) { build_action(name: :create, request: build_request(body:), summary: 'Create invoice') }
    let(:contract) { build_contract(actions: { create: action }) }

    describe_action :create do
      it { is_expected.to have_summary('Create invoice') }

      describe_request do
        describe_body do
          it { is_expected.to have_param(:title).of_type(:string) }
        end
      end
    end
  end

  describe '.describe_request with body and query' do
    subject { contract }

    let(:body) { build_body(params: { title: { type: :string } }) }
    let(:query) { build_body(params: { page: { type: :integer } }) }
    let(:action) { build_action(name: :create, request: build_request(body:, query:)) }
    let(:contract) { build_contract(actions: { create: action }) }

    describe_action :create do
      describe_request do
        describe_body do
          it { is_expected.to have_param(:title).of_type(:string) }
        end

        describe_query do
          it { is_expected.to have_param(:page).of_type(:integer) }
        end
      end
    end
  end

  describe '.describe_response' do
    subject { contract }

    let(:body) { build_body(params: { id: { type: :uuid } }) }
    let(:action) { build_action(name: :show, response: build_response(body:)) }
    let(:contract) { build_contract(actions: { show: action }) }

    describe_action :show do
      describe_response do
        describe_body do
          it { is_expected.to have_param(:id).of_type(:uuid) }
        end
      end
    end
  end

  describe '.describe_param' do
    subject { contract }

    let(:body) do
      build_body(
        params: {
          address: { params: { street: { type: :string }, zip: { type: :string } }, type: :object },
        },
      )
    end
    let(:action) { build_action(name: :create, request: build_request(body:)) }
    let(:contract) { build_contract(actions: { create: action }) }

    describe_action :create do
      describe_request do
        describe_body do
          it { is_expected.to have_param(:address).of_type(:object) }

          describe_param :address do
            it { is_expected.to have_param(:street).of_type(:string) }
            it { is_expected.to have_param(:zip).of_type(:string) }
          end
        end
      end
    end
  end

  describe '.describe_object' do
    subject { api }

    let(:definition) do
      build_type_definition(
        kind: :object,
        name: :address,
        params: { street: { type: :string }, zip: { type: :string } },
      )
    end
    let(:api) { build_api(type_registry: { address: definition }) }

    describe_object :address do
      it { is_expected.to have_param(:street).of_type(:string) }
      it { is_expected.to have_param(:zip).of_type(:string) }
    end
  end

  describe '.describe_union' do
    subject { api }

    let(:definition) do
      build_type_definition(
        discriminator: :type,
        kind: :union,
        name: :target,
        variants: [{ tag: 'user', type: :user }, { tag: 'team', type: :team }],
      )
    end
    let(:api) { build_api(type_registry: { target: definition }) }

    describe_union :target do
      it { is_expected.to have_variant(:user) }
      it { is_expected.to have_variant(:team) }
    end
  end

  describe '.describe_object with contract subject' do
    subject { contract }

    let(:definition) do
      build_type_definition(
        kind: :object,
        name: :address,
        params: { street: { type: :string } },
      )
    end
    let(:contract) { build_contract(type_definitions: { address: definition }) }

    describe_object :address do
      it { is_expected.to have_param(:street).of_type(:string) }
    end
  end
end
