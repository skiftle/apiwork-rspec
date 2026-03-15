# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for representation attributes.
      class HaveAttributeMatcher < BaseMatcher
        BOOLEAN_CHECKS = {
          deprecated: :deprecated?,
          empty: :empty,
          filterable: :filterable?,
          nullable: :nullable?,
          optional: :optional?,
          sortable: :sortable?,
        }.freeze

        VALUE_CHECKS = {
          default: :default,
          description: :description,
          enum: :enum,
          example: :example,
          format: :format,
          max: :max,
          min: :min,
          type: :type,
        }.freeze

        def initialize(name)
          super()
          @name = name
          @checks = {}
        end

        # @api public
        # Requires the attribute to have the expected type.
        #
        # @param type [Symbol] [:array, :binary, :boolean, :date, :datetime, :decimal, :integer, :number, :object, :record, :string, :time, :unknown, :uuid]
        #   The type.
        # @return [self]
        def of_type(type)
          @checks[:type] = type
          self
        end

        # @api public
        # Requires the attribute to be writable.
        #
        # @param action [Symbol, Boolean] (true) [Symbol: :create, :update]
        #   The action to check writability for, or `true` for any action.
        # @return [self]
        def writable(action = true)
          @checks[:writable] = action
          self
        end

        # @api public
        # Requires the attribute to be empty.
        #
        # @return [self]
        def empty
          @checks[:empty] = true
          self
        end

        # @api public
        # Requires the attribute to be deprecated.
        #
        # @return [self]
        def deprecated
          @checks[:deprecated] = true
          self
        end

        # @api public
        # Requires the attribute to be optional.
        #
        # @return [self]
        def optional
          @checks[:optional] = true
          self
        end

        # @api public
        # Requires the attribute to be nullable.
        #
        # @return [self]
        def nullable
          @checks[:nullable] = true
          self
        end

        # @api public
        # Requires the attribute to be filterable.
        #
        # @return [self]
        def filterable
          @checks[:filterable] = true
          self
        end

        # @api public
        # Requires the attribute to be sortable.
        #
        # @return [self]
        def sortable
          @checks[:sortable] = true
          self
        end

        # @api public
        # Requires the attribute to have the expected enum values.
        #
        # @param values [Array]
        #   The enum values.
        # @return [self]
        def with_enum(values)
          @checks[:enum] = values
          self
        end

        # @api public
        # Requires the attribute to have the expected format.
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
        # Requires the attribute to have the expected minimum.
        #
        # @param value [Numeric]
        #   The minimum.
        # @return [self]
        def with_min(value)
          @checks[:min] = value
          self
        end

        # @api public
        # Requires the attribute to have the expected maximum.
        #
        # @param value [Numeric]
        #   The maximum.
        # @return [self]
        def with_max(value)
          @checks[:max] = value
          self
        end

        # @api public
        # Requires the attribute to have the expected default.
        #
        # @param value [Object]
        #   The default.
        # @return [self]
        def with_default(value)
          @checks[:default] = value
          self
        end

        # @api public
        # Requires the attribute to have the expected description.
        #
        # @param text [String]
        #   The description.
        # @return [self]
        def with_description(text)
          @checks[:description] = text
          self
        end

        # @api public
        # Requires the attribute to have the expected example.
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
          attribute = subject.attributes[@name]
          return fail_with("expected #{format_subject} to have attribute #{@name.inspect}") unless attribute

          verify_all(attribute)
        end

        def description
          parts = ["have attribute #{@name.inspect}"]
          parts << "of type #{@checks[:type].inspect}" if @checks.key?(:type)
          boolean_parts = boolean_description_parts
          parts << "that is #{join_sentence(boolean_parts)}" if boolean_parts.any?
          VALUE_CHECKS.except(:type).each_key do |key|
            parts << "with #{key} #{@checks[key].inspect}" if @checks.key?(key)
          end
          parts.join(' ')
        end

        private

        def verify_all(attribute)
          verify_value_checks(attribute) &&
            verify_boolean_checks(attribute) &&
            verify_writable(attribute)
        end

        def verify_value_checks(attribute)
          VALUE_CHECKS.each do |key, method|
            next unless @checks.key?(key)

            actual = attribute.public_send(method)
            next if actual == @checks[key]

            return fail_with(
              "expected #{format_subject} to have attribute #{@name.inspect} " \
              "#{format_value_check(key, @checks[key])}, but got #{actual.inspect}",
            )
          end
          true
        end

        def verify_boolean_checks(attribute)
          BOOLEAN_CHECKS.each do |key, method|
            next unless @checks.key?(key)
            next if attribute.public_send(method)

            return fail_with(
              "expected #{format_subject} to have attribute #{@name.inspect} that is #{key}, but it is not",
            )
          end
          true
        end

        def verify_writable(attribute)
          return true unless @checks.key?(:writable)

          expected = @checks[:writable]
          if expected == true
            return true if attribute.writable?

            return fail_with(
              "expected #{format_subject} to have attribute #{@name.inspect} that is writable, but it is not",
            )
          end

          return true if attribute.writable_for?(expected)

          fail_with(
            "expected #{format_subject} to have attribute #{@name.inspect} " \
            "that is writable for #{expected.inspect}, but it is not",
          )
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
          if @checks.key?(:writable)
            parts << (@checks[:writable] == true ? 'writable' : "writable for #{@checks[:writable].inspect}")
          end
          parts
        end
      end
    end
  end
end
