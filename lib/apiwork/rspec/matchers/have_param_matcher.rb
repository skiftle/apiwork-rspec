# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for params in type definitions.
      class HaveParamMatcher < BaseMatcher
        BOOLEAN_CHECKS = {
          deprecated: { expected: true, key: :deprecated },
          nullable: { expected: true, key: :nullable },
          optional: { expected: true, key: :optional },
          required: { expected: false, key: :optional },
        }.freeze

        VALUE_CHECKS = %i[default description enum example format max min type].freeze

        def initialize(name)
          super()
          @name = name
          @checks = {}
        end

        # @api public
        # Requires the param to have the expected type.
        #
        # @param type [Symbol] [:array, :binary, :boolean, :date, :datetime, :decimal, :integer, :number, :object, :record, :string, :time, :unknown, :uuid]
        #   The type.
        # @return [self]
        def of_type(type)
          @checks[:type] = type
          self
        end

        # @api public
        # Requires the param to be required.
        #
        # @return [self]
        def required
          @checks[:required] = true
          self
        end

        # @api public
        # Requires the param to be optional.
        #
        # @return [self]
        def optional
          @checks[:optional] = true
          self
        end

        # @api public
        # Requires the param to be nullable.
        #
        # @return [self]
        def nullable
          @checks[:nullable] = true
          self
        end

        # @api public
        # Requires the param to be deprecated.
        #
        # @return [self]
        def deprecated
          @checks[:deprecated] = true
          self
        end

        # @api public
        # Requires the param to have the expected enum values.
        #
        # @param values [Array]
        #   The enum values.
        # @return [self]
        def with_enum(values)
          @checks[:enum] = values
          self
        end

        # @api public
        # Requires the param to have the expected format.
        #
        # @param format [Symbol] [:date, :datetime, :double, :email, :float, :hostname, :int32, :int64, :ipv4, :ipv6, :password, :text, :url, :uuid]
        #   The format. Valid formats by type: `:decimal`/`:number` (`:double`, `:float`), `:integer` (`:int32`, `:int64`),
        #   `:string` (`:date`, `:datetime`, `:email`, `:hostname`, `:ipv4`, `:ipv6`, `:password`, `:text`, `:url`, `:uuid`).
        # @return [self]
        def with_format(format)
          @checks[:format] = format
          self
        end

        # @api public
        # Requires the param to have the expected minimum.
        #
        # @param value [Numeric]
        #   The minimum.
        # @return [self]
        def with_min(value)
          @checks[:min] = value
          self
        end

        # @api public
        # Requires the param to have the expected maximum.
        #
        # @param value [Numeric]
        #   The maximum.
        # @return [self]
        def with_max(value)
          @checks[:max] = value
          self
        end

        # @api public
        # Requires the param to have the expected default.
        #
        # @param value [Object]
        #   The default.
        # @return [self]
        def with_default(value)
          @checks[:default] = value
          self
        end

        # @api public
        # Requires the param to have the expected description.
        #
        # @param text [String]
        #   The description.
        # @return [self]
        def with_description(text)
          @checks[:description] = text
          self
        end

        # @api public
        # Requires the param to have the expected example.
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
          param = subject.params[@name]
          return fail_with("expected #{format_subject} to have param #{@name.inspect}") unless param

          verify_all(param)
        end

        def description
          parts = ["have param #{@name.inspect}"]
          parts << "of type #{@checks[:type].inspect}" if @checks.key?(:type)
          boolean_parts = boolean_description_parts
          parts << "that is #{join_sentence(boolean_parts)}" if boolean_parts.any?
          (VALUE_CHECKS - [:type]).each do |key|
            parts << "with #{key} #{@checks[key].inspect}" if @checks.key?(key)
          end
          parts.join(' ')
        end

        private

        def verify_all(param)
          verify_value_checks(param) &&
            verify_boolean_checks(param)
        end

        def verify_value_checks(param)
          VALUE_CHECKS.each do |key|
            next unless @checks.key?(key)

            actual = param[key]
            next if actual == @checks[key]

            return fail_with(
              "expected #{format_subject} to have param #{@name.inspect} " \
              "#{format_value_check(key, @checks[key])}, but got #{actual.inspect}",
            )
          end
          true
        end

        def verify_boolean_checks(param)
          BOOLEAN_CHECKS.each do |check_name, config|
            next unless @checks.key?(check_name)

            actual = param[config[:key]]
            next if actual == config[:expected]

            return fail_with(
              "expected #{format_subject} to have param #{@name.inspect} " \
              "that is #{check_name}, but it is not",
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

        def boolean_description_parts
          parts = []
          BOOLEAN_CHECKS.each_key { |key| parts << key.to_s if @checks.key?(key) }
          parts
        end
      end
    end
  end
end
