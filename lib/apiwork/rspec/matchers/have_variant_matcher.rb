# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for variants in union type definitions.
      class HaveVariantMatcher < BaseMatcher
        BOOLEAN_CHECKS = {
          deprecated: :deprecated,
          partial: :partial,
        }.freeze

        VALUE_CHECKS = {
          description: :description,
          type: :type,
        }.freeze

        def initialize(name)
          super()
          @name = name
          @checks = {}
        end

        # @api public
        # Requires the variant to reference the expected type.
        #
        # @param type [Symbol]
        #   The type name.
        # @return [self]
        def of_type(type)
          @checks[:type] = type
          self
        end

        # @api public
        # Requires the variant to be deprecated.
        #
        # @return [self]
        def deprecated
          @checks[:deprecated] = true
          self
        end

        # @api public
        # Requires the variant to be partial.
        #
        # @return [self]
        def partial
          @checks[:partial] = true
          self
        end

        # @api public
        # Requires the variant to have the expected description.
        #
        # @param text [String]
        #   The description.
        # @return [self]
        def with_description(text)
          @checks[:description] = text
          self
        end

        def matches?(subject)
          @subject = subject
          variant = find_variant(subject)
          return fail_with("expected #{format_subject} to have variant #{@name.inspect}") unless variant

          verify_value_checks(variant) &&
            verify_boolean_checks(variant)
        end

        def description
          parts = ["have variant #{@name.inspect}"]
          parts << "of type #{@checks[:type].inspect}" if @checks.key?(:type)
          boolean_parts = BOOLEAN_CHECKS.each_key.select { |key| @checks.key?(key) }.map(&:to_s)
          parts << "that is #{join_sentence(boolean_parts)}" if boolean_parts.any?
          parts << "with description #{@checks[:description].inspect}" if @checks.key?(:description)
          parts.join(' ')
        end

        private

        def find_variant(subject)
          subject.variants.find { |variant| variant[:tag] == @name.to_s }
        end

        def verify_value_checks(variant)
          VALUE_CHECKS.each do |key, hash_key|
            next unless @checks.key?(key)

            actual = variant[hash_key]
            next if actual == @checks[key]

            return fail_with(
              "expected #{format_subject} to have variant #{@name.inspect} " \
              "#{format_value_check(key, @checks[key])}, but got #{actual.inspect}",
            )
          end
          true
        end

        def verify_boolean_checks(variant)
          BOOLEAN_CHECKS.each do |key, hash_key|
            next unless @checks.key?(key)
            next if variant[hash_key]

            return fail_with(
              "expected #{format_subject} to have variant #{@name.inspect} that is #{key}, but it is not",
            )
          end
          true
        end

        def format_value_check(key, value)
          case key
          when :type
            "of type #{value.inspect}"
          else
            "with #{key} #{value.inspect}"
          end
        end
      end
    end
  end
end
