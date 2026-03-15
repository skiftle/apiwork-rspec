# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for representation associations.
      class HaveAssociationMatcher < BaseMatcher
        BOOLEAN_CHECKS = {
          allow_destroy: :allow_destroy,
          deprecated: :deprecated?,
          filterable: :filterable?,
          nullable: :nullable?,
          polymorphic: :polymorphic?,
          sortable: :sortable?,
        }.freeze

        VALUE_CHECKS = {
          description: :description,
          example: :example,
          include: :include,
          representation: :representation_class,
        }.freeze

        def initialize(name)
          super()
          @name = name
          @checks = {}
        end

        # @api public
        # Requires the association to have the expected type.
        #
        # @param type [Symbol] [:belongs_to, :has_many, :has_one]
        #   The type.
        # @return [self]
        def of_type(type)
          @checks[:type] = type
          self
        end

        # @api public
        # Requires the association to be writable.
        #
        # @param action [Symbol, Boolean] (true) [Symbol: :create, :update]
        #   The action to check writability for, or `true` for any action.
        # @return [self]
        def writable(action = true)
          @checks[:writable] = action
          self
        end

        # @api public
        # Requires the association to allow destroy.
        #
        # @return [self]
        def allow_destroy
          @checks[:allow_destroy] = true
          self
        end

        # @api public
        # Requires the association to be deprecated.
        #
        # @return [self]
        def deprecated
          @checks[:deprecated] = true
          self
        end

        # @api public
        # Requires the association to be filterable.
        #
        # @return [self]
        def filterable
          @checks[:filterable] = true
          self
        end

        # @api public
        # Requires the association to be nullable.
        #
        # @return [self]
        def nullable
          @checks[:nullable] = true
          self
        end

        # @api public
        # Requires the association to be polymorphic.
        #
        # @return [self]
        def polymorphic
          @checks[:polymorphic] = true
          self
        end

        # @api public
        # Requires the association to be sortable.
        #
        # @return [self]
        def sortable
          @checks[:sortable] = true
          self
        end

        # @api public
        # Requires the association to have the expected inclusion strategy.
        #
        # @param value [Symbol] [:always, :optional]
        #   The inclusion strategy.
        # @return [self]
        def with_include(value)
          @checks[:include] = value
          self
        end

        # @api public
        # Requires the association to have the expected representation class.
        #
        # @param klass [Class]
        #   The representation class.
        # @return [self]
        def with_representation(klass)
          @checks[:representation] = klass
          self
        end

        # @api public
        # Requires the association to have the expected description.
        #
        # @param text [String]
        #   The description.
        # @return [self]
        def with_description(text)
          @checks[:description] = text
          self
        end

        # @api public
        # Requires the association to have the expected example.
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
          association = subject.associations[@name]
          return fail_with("expected #{format_subject} to have association #{@name.inspect}") unless association

          verify_all(association)
        end

        def description
          parts = ["have association #{@name.inspect}"]
          parts << "of type #{@checks[:type].inspect}" if @checks.key?(:type)
          boolean_parts = boolean_description_parts
          parts << "that is #{join_sentence(boolean_parts)}" if boolean_parts.any?
          VALUE_CHECKS.each_key do |key|
            parts << "with #{key} #{@checks[key].inspect}" if @checks.key?(key)
          end
          parts.join(' ')
        end

        private

        def verify_all(association)
          verify_type(association) &&
            verify_boolean_checks(association) &&
            verify_writable(association) &&
            verify_value_checks(association)
        end

        def verify_type(association)
          return true unless @checks.key?(:type)
          return true if association.type == @checks[:type]

          fail_with(
            "expected #{format_subject} to have association #{@name.inspect} " \
            "of type #{@checks[:type].inspect}, but got #{association.type.inspect}",
          )
        end

        def verify_boolean_checks(association)
          BOOLEAN_CHECKS.each do |key, method|
            next unless @checks.key?(key)
            next if association.public_send(method)

            return fail_with(
              "expected #{format_subject} to have association #{@name.inspect} that is #{key}, but it is not",
            )
          end
          true
        end

        def verify_writable(association)
          return true unless @checks.key?(:writable)

          expected = @checks[:writable]
          if expected == true
            return true if association.writable?

            return fail_with(
              "expected #{format_subject} to have association #{@name.inspect} that is writable, but it is not",
            )
          end

          return true if association.writable_for?(expected)

          fail_with(
            "expected #{format_subject} to have association #{@name.inspect} " \
            "that is writable for #{expected.inspect}, but it is not",
          )
        end

        def verify_value_checks(association)
          VALUE_CHECKS.each do |key, method|
            next unless @checks.key?(key)

            actual = association.public_send(method)
            next if actual == @checks[key]

            return fail_with(
              "expected #{format_subject} to have association #{@name.inspect} " \
              "with #{key} #{@checks[key].inspect}, but got #{actual.inspect}",
            )
          end
          true
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
