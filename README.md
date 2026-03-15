# apiwork-rspec

RSpec matchers for [Apiwork](https://apiwork.dev).

## Installation

Add to your Gemfile:

```ruby
gem 'apiwork-rspec', group: :test
```

## Setup

Include the matchers in your `spec_helper.rb` or `rails_helper.rb`:

```ruby
RSpec.configure do |config|
  config.include Apiwork::RSpec::Matchers
end
```

## APIs

### have_key_format

```ruby
it { is_expected.to have_key_format(:camel) }
```

### have_path_format

```ruby
it { is_expected.to have_path_format(:kebab) }
```

### have_raises

```ruby
it { is_expected.to have_raises(:bad_request, :internal_server_error) }
```

### have_export

```ruby
it { is_expected.to have_export(:openapi) }
it { is_expected.to have_export(:typescript) }
```

### have_resource

```ruby
it { is_expected.to have_resource(:invoices) }
it { is_expected.to have_resource(:invoices).with_only(:index, :show) }
it { is_expected.to have_resource(:lines).under(:invoices).with_except(:destroy) }
it { is_expected.to have_resource(:adjustments).under(:invoices, :lines) }
it { is_expected.to have_resource(:profile).singular }
```

### describe_info

```ruby
describe_info do
  it { is_expected.to have_title('Billing API') }
  it { is_expected.to have_version('1.0.0') }
  it { is_expected.to have_summary('A billing API') }
  it { is_expected.to have_description('Invoice management and payments') }
  it { is_expected.to have_terms_of_service('https://example.com/terms') }
  it { is_expected.to define_contact('API Support').with_email('support@example.com').with_url('https://example.com/support') }
  it { is_expected.to define_license('MIT').with_url('https://opensource.org/licenses/MIT') }
  it { is_expected.to define_server('https://api.example.com').with_description('Production') }
end
```

## Definitions

### describe_object

```ruby
describe_object :address do
  it { is_expected.to have_description('Mailing address') }
  it { is_expected.to have_example({ street: '123 Main St' }) }
  it { is_expected.to have_param(:street).of_type(:string) }
  it { is_expected.to have_param(:city).of_type(:string) }
end
```

### describe_union

```ruby
describe_union :recipient do
  it { is_expected.to have_discriminator(:type) }
  it { is_expected.to have_description('Invoice recipient') }
  it { is_expected.to have_variant(:customer).of_type(:customer) }
  it { is_expected.to have_variant(:company).of_type(:company) }
  it { is_expected.to have_variant(:legacy_customer).deprecated.with_description('Use customer instead') }
end
```

### define_enum

```ruby
it { is_expected.to define_enum(:status).with_values(%w[draft sent paid]).with_description('Invoice status').with_example('draft') }
it { is_expected.to define_enum(:currency).deprecated }
```

## Contracts

### have_representation

```ruby
it { is_expected.to have_representation(InvoiceRepresentation) }
```

### have_identifier

```ruby
it { is_expected.to have_identifier(:invoices) }
```

### have_import

```ruby
it { is_expected.to have_import(SharedContract, as: :shared) }
```

### be_abstract

```ruby
it { is_expected.to be_abstract }
```

### describe_action

```ruby
describe_action :create do
  it { is_expected.to have_summary('Create invoice') }
  it { is_expected.to have_description('Creates a new invoice') }
  it { is_expected.to have_tags(:billing) }
  it { is_expected.to have_raises(:not_found, :conflict) }
  it { is_expected.to have_operation_id('createInvoice') }
  it { is_expected.to be_deprecated }
end

describe_action :destroy do
  it { is_expected.to be_no_content }
end
```

### describe_request / describe_response

Tests the request or response. Use with `describe_body` and `describe_query`.

### describe_body / describe_query

```ruby
describe_action :create do
  describe_request do
    describe_body do
      it { is_expected.to have_param(:title).of_type(:string).required.with_description('Invoice title').with_example('Q1 Consulting') }
      it { is_expected.to have_param(:notes).of_type(:string).optional.nullable }
      it { is_expected.to have_param(:status).with_enum(%w[draft sent]).with_default('draft') }
      it { is_expected.to have_param(:customer_email).with_format(:email) }
      it { is_expected.to have_param(:amount).of_type(:decimal).with_min(0).with_max(1_000_000) }
      it { is_expected.to have_param(:tax_code).deprecated }
    end

    describe_query do
      it { is_expected.to have_param(:include).of_type(:string).optional }
    end
  end

  describe_response do
    describe_body do
      it { is_expected.to have_param(:id).of_type(:uuid) }
    end
  end
end
```

### describe_param

Tests an inline type's params. Nestable.

```ruby
describe_action :create do
  describe_request do
    describe_body do
      it { is_expected.to have_param(:address).of_type(:object) }

      describe_param :address do
        it { is_expected.to have_param(:street).of_type(:string) }
        it { is_expected.to have_param(:city).of_type(:string) }
      end
    end
  end
end
```

## Representations

### have_model

```ruby
it { is_expected.to have_model(Invoice) }
```

### have_root

```ruby
it { is_expected.to have_root(:invoice, :invoices) }
```

### have_type_name

```ruby
it { is_expected.to have_type_name('CustomInvoice') }
```

### have_description / have_example

```ruby
it { is_expected.to have_description('An invoice') }
it { is_expected.to have_example({ number: 'INV-001', title: 'Q1 Consulting' }) }
```

### be_deprecated / be_abstract

```ruby
it { is_expected.to be_deprecated }
it { is_expected.to be_abstract }
```

### have_attribute

```ruby
it { is_expected.to have_attribute(:number).of_type(:string).with_description('Invoice number').with_example('INV-001') }
it { is_expected.to have_attribute(:total).of_type(:decimal).filterable.sortable }
it { is_expected.to have_attribute(:title).writable }
it { is_expected.to have_attribute(:title).writable(:create) }
it { is_expected.to have_attribute(:notes).optional.nullable }
it { is_expected.to have_attribute(:notes).empty }
it { is_expected.to have_attribute(:status).with_enum(%w[draft sent paid]).with_default('draft') }
it { is_expected.to have_attribute(:customer_email).with_format(:email) }
it { is_expected.to have_attribute(:amount).with_min(0).with_max(1_000_000) }
it { is_expected.to have_attribute(:tax_code).deprecated }
```

### have_association

```ruby
it { is_expected.to have_association(:lines).of_type(:has_many).writable.allow_destroy.filterable.sortable.with_description('Invoice line items') }
it { is_expected.to have_association(:lines).writable(:create) }
it { is_expected.to have_association(:customer).of_type(:belongs_to).with_include(:always) }
it { is_expected.to have_association(:payable).polymorphic }
it { is_expected.to have_association(:receipt).with_representation(ReceiptRepresentation) }
it { is_expected.to have_association(:lines).nullable }
it { is_expected.to have_association(:payments).deprecated }
```

## Full Example

```ruby
Apiwork::API.define '/api/v1' do
  key_format :camel
  export :openapi

  info do
    title 'Billing API'
    version '1.0.0'

    contact do
      name 'API Support'
      email 'support@example.com'
    end

    license do
      name 'MIT'
    end

    server do
      url 'https://api.example.com'
      description 'Production'
    end
  end

  enum :status, values: %i[draft sent paid]

  object :address, description: 'Mailing address' do
    string :street
    string :city
  end

  union :recipient, discriminator: :type do
    variant tag: :customer do
      object do
        string :name
      end
    end
    variant tag: :company do
      object do
        string :name
      end
    end
  end

  resources :invoices
  resource :profile
end

class InvoiceContract < Apiwork::Contract::Base
  representation InvoiceRepresentation
  import SharedContract, as: :shared

  enum :priority, values: %i[low normal high]

  object :line_detail do
    string :description
    decimal :amount
  end

  action :create do
    summary 'Create invoice'

    request do
      body do
        string :title
        decimal :amount
      end
    end

    response do
      body do
        uuid :id
      end
    end
  end

  action :destroy do
    response no_content: true
  end
end

class InvoiceRepresentation < Apiwork::Representation::Base
  model Invoice
  root :invoice, :invoices

  attribute :title, writable: true
  has_many :lines
end
```

```ruby
RSpec.describe 'API V1' do
  subject { Apiwork::API.find!('/api/v1') }

  it { is_expected.to have_key_format(:camel) }
  it { is_expected.to have_export(:openapi) }
  it { is_expected.to have_resource(:invoices) }
  it { is_expected.to have_resource(:profile).singular }
  it { is_expected.to define_enum(:status).with_values(%w[draft sent paid]) }

  describe_info do
    it { is_expected.to have_title('Billing API') }
    it { is_expected.to have_version('1.0.0') }
    it { is_expected.to define_contact('API Support').with_email('support@example.com') }
    it { is_expected.to define_license('MIT') }
    it { is_expected.to define_server('https://api.example.com').with_description('Production') }
  end

  describe_object :address do
    it { is_expected.to have_description('Mailing address') }
    it { is_expected.to have_param(:street).of_type(:string) }
    it { is_expected.to have_param(:city).of_type(:string) }
  end

  describe_union :recipient do
    it { is_expected.to have_discriminator(:type) }
    it { is_expected.to have_variant(:customer) }
    it { is_expected.to have_variant(:company) }
  end
end

RSpec.describe InvoiceContract do
  subject { described_class }

  it { is_expected.to have_representation(InvoiceRepresentation) }
  it { is_expected.to have_import(SharedContract, as: :shared) }
  it { is_expected.to define_enum(:priority).with_values(%w[low normal high]) }

  describe_object :line_detail do
    it { is_expected.to have_param(:description).of_type(:string) }
    it { is_expected.to have_param(:amount).of_type(:decimal) }
  end

  describe_action :create do
    it { is_expected.to have_summary('Create invoice') }

    describe_request do
      describe_body do
        it { is_expected.to have_param(:title).of_type(:string) }
        it { is_expected.to have_param(:amount).of_type(:decimal) }
      end
    end

    describe_response do
      describe_body do
        it { is_expected.to have_param(:id).of_type(:uuid) }
      end
    end
  end

  describe_action :destroy do
    it { is_expected.to be_no_content }
  end
end

RSpec.describe InvoiceRepresentation do
  subject { described_class }

  it { is_expected.to have_model(Invoice) }
  it { is_expected.to have_root(:invoice, :invoices) }
  it { is_expected.to have_attribute(:title).of_type(:string).writable }
  it { is_expected.to have_association(:lines).of_type(:has_many) }
end
```

## License

MIT
