# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for enum definitions.
      class DefineEnumMatcher < BaseMatcher
        VALUE_CHECKS = {
          description: :description,
          example: :example,
        }.freeze

        def initialize(name)
          super()
          @name = name
          @expected_values = nil
          @checks = {}
        end

        # @api public
        # Requires the enum to have the expected values.
        #
        # @param values [Array]
        #   The enum values.
        # @return [self]
        def with_values(values)
          @expected_values = values
          self
        end

        # @api public
        # Requires the enum to be deprecated.
        #
        # @return [self]
        def deprecated
          @checks[:deprecated] = true
          self
        end

        # @api public
        # Requires the enum to have the expected description.
        #
        # @param text [String]
        #   The description.
        # @return [self]
        def with_description(text)
          @checks[:description] = text
          self
        end

        # @api public
        # Requires the enum to have the expected example.
        #
        # @param value [Object]
        #   The example.
        # @return [self]
        def with_example(value)
          @checks[:example] = value
          self
        end

        def matches?(subject)
          @subject = subject
          values = subject.enum_values(@name)
          return fail_with("expected #{format_subject} to define enum #{@name.inspect}") unless values

          verify_values(values) &&
            verify_metadata(subject)
        end

        def description
          parts = ["define enum #{@name.inspect}"]
          parts << 'that is deprecated' if @checks.key?(:deprecated)
          parts << "with values #{@expected_values.inspect}" if @expected_values
          VALUE_CHECKS.each_key do |key|
            parts << "with #{key} #{@checks[key].inspect}" if @checks.key?(key)
          end
          parts.join(' ')
        end

        private

        def verify_values(values)
          return true unless @expected_values
          return true if values == @expected_values

          fail_with(
            "expected #{format_subject} to define enum #{@name.inspect} " \
            "with values #{@expected_values.inspect}, but got #{values.inspect}",
          )
        end

        def verify_metadata(subject)
          definition = find_enum_definition(subject)
          return true unless definition_required?
          return fail_with("expected #{format_subject} to support enum metadata (use API class)") unless definition

          verify_deprecated(definition) &&
            verify_value_checks(definition)
        end

        def find_enum_definition(subject)
          return unless subject.respond_to?(:enum_registry)

          subject.enum_registry[@name]
        end

        def definition_required?
          @checks.key?(:deprecated) || @checks.key?(:description) || @checks.key?(:example)
        end

        def verify_deprecated(definition)
          return true unless @checks.key?(:deprecated)
          return true if definition.deprecated?

          fail_with(
            "expected #{format_subject} to define enum #{@name.inspect} that is deprecated, but it is not",
          )
        end

        def verify_value_checks(definition)
          VALUE_CHECKS.each do |key, method|
            next unless @checks.key?(key)

            actual = definition.public_send(method)
            next if actual == @checks[key]

            return fail_with(
              "expected #{format_subject} to define enum #{@name.inspect} " \
              "with #{key} #{@checks[key].inspect}, but got #{actual.inspect}",
            )
          end
          true
        end
      end
    end
  end
end
