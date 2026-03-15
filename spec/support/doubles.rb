# frozen_string_literal: true

module TestDoubles
  def build_representation(associations: {}, attributes: {}, name: 'TestRepresentation')
    obj = Object.new
    obj.define_singleton_method(:attributes) { attributes }
    obj.define_singleton_method(:associations) { associations }
    obj.define_singleton_method(:name) { name }
    obj
  end

  def build_attribute(
    default: nil,
    deprecated: false,
    description: nil,
    empty: false,
    enum: nil,
    example: nil,
    filterable: false,
    format: nil,
    max: nil,
    min: nil,
    nullable: false,
    optional: false,
    sortable: false,
    type: :string,
    writable: false
  )
    obj = Object.new
    obj.define_singleton_method(:type) { type }
    obj.define_singleton_method(:empty) { empty }
    obj.define_singleton_method(:deprecated?) { deprecated }
    obj.define_singleton_method(:optional?) { optional }
    obj.define_singleton_method(:nullable?) { nullable }
    obj.define_singleton_method(:writable?) { !!writable }
    obj.define_singleton_method(:writable_for?) { |action| [true, action].include?(writable) }
    obj.define_singleton_method(:filterable?) { filterable }
    obj.define_singleton_method(:sortable?) { sortable }
    obj.define_singleton_method(:enum) { enum }
    obj.define_singleton_method(:format) { format }
    obj.define_singleton_method(:min) { min }
    obj.define_singleton_method(:max) { max }
    obj.define_singleton_method(:default) { default }
    obj.define_singleton_method(:description) { description }
    obj.define_singleton_method(:example) { example }
    obj
  end

  def build_association(
    allow_destroy: false,
    deprecated: false,
    description: nil,
    example: nil,
    filterable: false,
    include_strategy: :optional,
    nullable: false,
    polymorphic: false,
    representation_class: nil,
    sortable: false,
    type: :has_many,
    writable: false
  )
    obj = Object.new
    obj.define_singleton_method(:type) { type }
    obj.define_singleton_method(:allow_destroy) { allow_destroy }
    obj.define_singleton_method(:deprecated?) { deprecated }
    obj.define_singleton_method(:filterable?) { filterable }
    obj.define_singleton_method(:nullable?) { nullable }
    obj.define_singleton_method(:polymorphic?) { polymorphic }
    obj.define_singleton_method(:sortable?) { sortable }
    obj.define_singleton_method(:writable?) { !!writable }
    obj.define_singleton_method(:writable_for?) { |action| [true, action].include?(writable) }
    obj.define_singleton_method(:include) { include_strategy }
    obj.define_singleton_method(:representation_class) { representation_class }
    obj.define_singleton_method(:description) { description }
    obj.define_singleton_method(:example) { example }
    obj
  end

  def build_contract(actions: {}, enum_values: {}, name: 'TestContract', type_definitions: {})
    obj = Object.new
    obj.define_singleton_method(:actions) { actions }
    obj.define_singleton_method(:enum_values) { |enum_name| enum_values[enum_name] }
    obj.define_singleton_method(:resolve_custom_type) { |type_name| type_definitions[type_name] }
    obj.define_singleton_method(:name) { name }
    obj
  end

  def build_action(
    deprecated: false,
    description: nil,
    name: :test_action,
    operation_id: nil,
    raises: nil,
    request: build_request,
    response: build_response,
    summary: nil,
    tags: nil
  )
    obj = Object.new
    obj.define_singleton_method(:name) { name }
    obj.define_singleton_method(:request) { request }
    obj.define_singleton_method(:response) { response }
    obj.define_singleton_method(:deprecated?) { deprecated }
    obj.define_singleton_method(:summary) { summary }
    obj.define_singleton_method(:description) { description }
    obj.define_singleton_method(:raises) { raises }
    obj.define_singleton_method(:tags) { tags }
    obj.define_singleton_method(:operation_id) { operation_id }
    obj
  end

  def build_request(body: nil, query: nil)
    obj = Object.new
    obj.define_singleton_method(:body) { body }
    obj.define_singleton_method(:query) { query }
    obj
  end

  def build_response(body: nil, no_content: false)
    obj = Object.new
    obj.define_singleton_method(:body) { body }
    obj.define_singleton_method(:no_content?) { no_content }
    obj
  end

  def build_body(params: {})
    obj = Object.new
    obj.define_singleton_method(:params) { params }
    obj
  end

  def build_type_definition(
    deprecated: false,
    description: nil,
    discriminator: nil,
    example: nil,
    kind: :object,
    name: :test_type,
    params: {},
    variants: []
  )
    obj = Object.new
    obj.define_singleton_method(:kind) { kind }
    obj.define_singleton_method(:name) { name }
    obj.define_singleton_method(:object?) { kind == :object }
    obj.define_singleton_method(:union?) { kind == :union }
    obj.define_singleton_method(:deprecated?) { deprecated }
    obj.define_singleton_method(:description) { description }
    obj.define_singleton_method(:discriminator) { discriminator }
    obj.define_singleton_method(:example) { example }
    obj.define_singleton_method(:params) { params }
    obj.define_singleton_method(:variants) { variants }
    obj
  end

  def build_api(enum_registry: {}, enum_values: {}, name: 'TestApi', resources: {}, type_registry: {})
    root = build_root_resource(resources:)
    obj = Object.new
    obj.define_singleton_method(:root_resource) { root }
    obj.define_singleton_method(:enum_values) { |enum_name| enum_values[enum_name] }
    obj.define_singleton_method(:enum_registry) { enum_registry }
    obj.define_singleton_method(:type_registry) { type_registry }
    obj.define_singleton_method(:name) { name }
    obj
  end

  def build_root_resource(resources: {})
    obj = Object.new
    obj.define_singleton_method(:resources) { resources }
    obj
  end

  def build_resource(except: nil, only: nil, resources: {}, singular: false)
    obj = Object.new
    obj.define_singleton_method(:resources) { resources }
    obj.define_singleton_method(:singular) { singular }
    obj.define_singleton_method(:only) { only }
    obj.define_singleton_method(:except) { except }
    obj
  end

  def build_enum_definition(deprecated: false, description: nil, example: nil, values: [])
    obj = Object.new
    obj.define_singleton_method(:deprecated?) { deprecated }
    obj.define_singleton_method(:description) { description }
    obj.define_singleton_method(:example) { example }
    obj.define_singleton_method(:values) { values }
    obj
  end
end
