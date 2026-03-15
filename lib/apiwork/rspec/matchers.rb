# frozen_string_literal: true

module Apiwork
  module RSpec
    # @api public
    module Matchers
      class << self
        def included(base)
          base.extend(ClassMethods)
        end
      end

      module ClassMethods
        def describe_action(action_name, &block)
          context "action #{action_name.inspect}" do
            subject { super().actions[action_name] }
            class_exec(&block)
          end
        end

        def describe_body(&block)
          context 'body' do
            subject { super().body }
            class_exec(&block)
          end
        end

        def describe_query(&block)
          context 'query' do
            subject { super().query }
            class_exec(&block)
          end
        end

        def describe_response(&block)
          context 'response' do
            subject { super().response }
            class_exec(&block)
          end
        end

        def describe_request(&block)
          context 'request' do
            subject { super().request }
            class_exec(&block)
          end
        end

        def describe_param(param_name, &block)
          context "param #{param_name.inspect}" do
            subject do
              param = super().params[param_name]
              ParamWrapper.new(param_name, param)
            end
            class_exec(&block)
          end
        end

        def describe_info(&block)
          context 'info' do
            subject { super().info }
            class_exec(&block)
          end
        end

        def describe_object(type_name, &block)
          context "object #{type_name.inspect}" do
            subject do
              parent = super()
              if parent.respond_to?(:type_registry)
                parent.type_registry[type_name]
              elsif parent.respond_to?(:resolve_custom_type)
                parent.resolve_custom_type(type_name)
              end
            end
            class_exec(&block)
          end
        end

        def describe_union(type_name, &block)
          context "union #{type_name.inspect}" do
            subject do
              parent = super()
              if parent.respond_to?(:type_registry)
                parent.type_registry[type_name]
              elsif parent.respond_to?(:resolve_custom_type)
                parent.resolve_custom_type(type_name)
              end
            end
            class_exec(&block)
          end
        end
      end

      # @api public
      # Verifies a representation has a specific attribute.
      #
      # @param name [Symbol]
      #   The attribute name.
      # @return [HaveAttributeMatcher]
      def have_attribute(name)
        HaveAttributeMatcher.new(name)
      end

      # @api public
      # Verifies a representation has a specific association.
      #
      # @param name [Symbol]
      #   The association name.
      # @return [HaveAssociationMatcher]
      def have_association(name)
        HaveAssociationMatcher.new(name)
      end

      # @api public
      # Verifies an API defines a specific enum.
      #
      # @param name [Symbol]
      #   The enum name.
      # @return [DefineEnumMatcher]
      def define_enum(name)
        DefineEnumMatcher.new(name)
      end

      # @api public
      # Verifies a param exists with the expected properties.
      #
      # @param name [Symbol]
      #   The param name.
      # @return [HaveParamMatcher]
      def have_param(name)
        HaveParamMatcher.new(name)
      end

      # @api public
      # Verifies a union has a specific variant.
      #
      # @param name [Symbol]
      #   The variant name.
      # @return [HaveVariantMatcher]
      def have_variant(name)
        HaveVariantMatcher.new(name)
      end

      # @api public
      # Verifies an action has no response content.
      #
      # @return [NoContentMatcher]
      def be_no_content
        NoContentMatcher.new
      end

      # @api public
      # Verifies an action has the expected summary.
      #
      # @param text [String]
      #   The summary.
      # @return [HaveSummaryMatcher]
      def have_summary(text)
        HaveSummaryMatcher.new(text)
      end

      # @api public
      # Verifies a subject has the expected description.
      #
      # @param text [String]
      #   The description.
      # @return [HaveDescriptionMatcher]
      def have_description(text)
        HaveDescriptionMatcher.new(text)
      end

      # @api public
      # Verifies a union has the expected discriminator.
      #
      # @param field [Symbol]
      #   The discriminator field.
      # @return [HaveDiscriminatorMatcher]
      def have_discriminator(field)
        HaveDiscriminatorMatcher.new(field)
      end

      # @api public
      # Verifies a subject has the expected example.
      #
      # @param value [Object]
      #   The example value.
      # @return [HaveExampleMatcher]
      def have_example(value)
        HaveExampleMatcher.new(value)
      end

      # @api public
      # Verifies an action has the expected tags.
      #
      # @param tags [Array<Symbol>]
      #   The tags.
      # @return [HaveTagsMatcher]
      def have_tags(*tags)
        HaveTagsMatcher.new(tags.flatten)
      end

      # @api public
      # Verifies an action has the expected raises.
      #
      # @param codes [Array<Symbol>]
      #   The error codes.
      # @return [HaveRaisesMatcher]
      def have_raises(*codes)
        HaveRaisesMatcher.new(codes.flatten)
      end

      # @api public
      # Verifies an action has the expected operation ID.
      #
      # @param id [String]
      #   The operation ID.
      # @return [HaveOperationIdMatcher]
      def have_operation_id(id)
        HaveOperationIdMatcher.new(id)
      end

      # @api public
      # Verifies an API has a specific resource.
      #
      # @param name [Symbol]
      #   The resource name.
      # @return [HaveResourceMatcher]
      def have_resource(name)
        HaveResourceMatcher.new(name)
      end

      # @api public
      # Verifies a contract has the expected representation.
      #
      # @param klass [Class]
      #   The representation class.
      # @return [HaveRepresentationMatcher]
      def have_representation(klass)
        HaveRepresentationMatcher.new(klass)
      end

      # @api public
      # Verifies a contract has the expected identifier.
      #
      # @param value [Symbol]
      #   The identifier.
      # @return [HaveIdentifierMatcher]
      def have_identifier(value)
        HaveIdentifierMatcher.new(value)
      end

      # @api public
      # Verifies a representation has the expected model.
      #
      # @param klass [Class]
      #   The model class.
      # @return [HaveModelMatcher]
      def have_model(klass)
        HaveModelMatcher.new(klass)
      end

      # @api public
      # Verifies a representation has the expected root key.
      #
      # @param singular [Symbol]
      #   The singular root key.
      # @param plural [Symbol]
      #   The plural root key.
      # @return [HaveRootMatcher]
      def have_root(singular, plural)
        HaveRootMatcher.new(singular, plural)
      end

      # @api public
      # Verifies a representation has the expected type name.
      #
      # @param value [String]
      #   The type name.
      # @return [HaveTypeNameMatcher]
      def have_type_name(value)
        HaveTypeNameMatcher.new(value)
      end

      # @api public
      # Verifies an API has the expected key format.
      #
      # @param format [Symbol] [:camel, :kebab, :keep, :pascal, :underscore]
      #   The key format.
      # @return [HaveKeyFormatMatcher]
      def have_key_format(format)
        HaveKeyFormatMatcher.new(format)
      end

      # @api public
      # Verifies an API has the expected path format.
      #
      # @param format [Symbol] [:camel, :kebab, :keep, :pascal, :underscore]
      #   The path format.
      # @return [HavePathFormatMatcher]
      def have_path_format(format)
        HavePathFormatMatcher.new(format)
      end

      # @api public
      # Verifies an API info has the expected title.
      #
      # @param text [String]
      #   The title.
      # @return [HaveTitleMatcher]
      def have_title(text)
        HaveTitleMatcher.new(text)
      end

      # @api public
      # Verifies an API info has the expected version.
      #
      # @param text [String]
      #   The version.
      # @return [HaveVersionMatcher]
      def have_version(text)
        HaveVersionMatcher.new(text)
      end

      # @api public
      # Verifies an API info has the expected terms of service.
      #
      # @param url [String]
      #   The terms of service URL.
      # @return [HaveTermsOfServiceMatcher]
      def have_terms_of_service(url)
        HaveTermsOfServiceMatcher.new(url)
      end

      # @api public
      # Verifies an API info defines a contact.
      #
      # @param name [String]
      #   The contact name.
      # @return [DefineContactMatcher]
      def define_contact(name)
        DefineContactMatcher.new(name)
      end

      # @api public
      # Verifies an API info defines a license.
      #
      # @param name [String]
      #   The license name.
      # @return [DefineLicenseMatcher]
      def define_license(name)
        DefineLicenseMatcher.new(name)
      end

      # @api public
      # Verifies an API info defines a server.
      #
      # @param url [String]
      #   The server URL.
      # @return [DefineServerMatcher]
      def define_server(url)
        DefineServerMatcher.new(url)
      end

      # @api public
      # Verifies an API has a specific export enabled.
      #
      # @param name [Symbol] [:openapi, :sorbus, :typescript, :zod]
      #   The export name.
      # @return [HaveExportMatcher]
      def have_export(name)
        HaveExportMatcher.new(name)
      end

      # @api public
      # Verifies a contract imports another contract.
      #
      # @param klass [Class]
      #   The imported contract class.
      # @param as [Symbol]
      #   The import alias.
      # @return [HaveImportMatcher]
      def have_import(klass, as:)
        HaveImportMatcher.new(klass, as:)
      end
    end
  end
end
