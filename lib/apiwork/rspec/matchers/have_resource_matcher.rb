# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for API resource structure.
      class HaveResourceMatcher < BaseMatcher
        VALUE_CHECKS = {
          except: :except,
          only: :only,
        }.freeze

        def initialize(name)
          super()
          @name = name
          @parents = []
          @checks = {}
        end

        # @api public
        # Specifies the parent resources for a nested resource.
        #
        # @param parents [Array<Symbol>]
        #   The parent resource names.
        # @return [self]
        def under(*parents)
          @parents = parents
          self
        end

        # @api public
        # Requires the resource to be singular.
        #
        # @return [self]
        def singular
          @checks[:singular] = true
          self
        end

        # @api public
        # Requires the resource to have the expected allowed actions.
        #
        # @param actions [Array<Symbol>] [:create, :destroy, :index, :show, :update]
        #   The allowed actions.
        # @return [self]
        def with_only(*actions)
          @checks[:only] = actions.flatten
          self
        end

        # @api public
        # Requires the resource to have the expected excluded actions.
        #
        # @param actions [Array<Symbol>] [:create, :destroy, :index, :show, :update]
        #   The excluded actions.
        # @return [self]
        def with_except(*actions)
          @checks[:except] = actions.flatten
          self
        end

        def matches?(subject)
          @subject = subject
          resource = find_resource(subject)
          return false unless resource

          verify_singular(resource) &&
            verify_value_checks(resource)
        end

        def description
          parts = ["have resource #{@name.inspect}"]
          parts << "under #{@parents.map(&:inspect).join(', ')}" if @parents.any?
          parts << 'that is singular' if @checks.key?(:singular)
          VALUE_CHECKS.each_key do |key|
            parts << "with #{key} #{@checks[key].inspect}" if @checks.key?(key)
          end
          parts.join(' ')
        end

        private

        def find_resource(subject)
          parent = subject.root_resource

          @parents.each do |parent_name|
            child = parent.resources[parent_name]
            unless child
              fail_with(
                "expected #{format_subject} to have resource #{@name.inspect} " \
                "under #{@parents.map(&:inspect).join(', ')}, " \
                "but #{parent_name.inspect} was not found",
              )
              return nil
            end
            parent = child
          end

          resource = parent.resources[@name]
          unless resource
            if @parents.any?
              fail_with(
                "expected #{format_subject} to have resource #{@name.inspect} " \
                "under #{@parents.map(&:inspect).join(', ')}",
              )
            else
              fail_with("expected #{format_subject} to have resource #{@name.inspect}")
            end
            return nil
          end

          resource
        end

        def verify_singular(resource)
          return true unless @checks.key?(:singular)
          return true if resource.singular

          fail_with(
            "expected #{format_subject} to have resource #{@name.inspect} that is singular, but it is not",
          )
        end

        def verify_value_checks(resource)
          VALUE_CHECKS.each do |key, method|
            next unless @checks.key?(key)

            actual = resource.public_send(method)
            next if actual == @checks[key]

            return fail_with(
              "expected #{format_subject} to have resource #{@name.inspect} " \
              "with #{key} #{@checks[key].inspect}, but got #{actual.inspect}",
            )
          end
          true
        end
      end
    end
  end
end
