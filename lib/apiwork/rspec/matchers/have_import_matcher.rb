# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying a contract imports another contract.
      class HaveImportMatcher < BaseMatcher
        def initialize(klass, as:)
          super()
          @klass = klass
          @alias = as
        end

        def matches?(subject)
          @subject = subject
          actual = subject.imports[@alias]

          return fail_with("expected #{format_subject} to have import #{@alias.inspect}") unless actual
          return true if actual == @klass

          fail_with(
            "expected #{format_subject} to have import #{@alias.inspect} " \
            "of #{@klass.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have import #{@klass.inspect} as #{@alias.inspect}"
        end
      end
    end
  end
end
