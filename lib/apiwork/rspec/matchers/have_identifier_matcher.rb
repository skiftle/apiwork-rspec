# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying a contract has the expected identifier.
      class HaveIdentifierMatcher < BaseMatcher
        def initialize(value)
          super()
          @value = value
        end

        def matches?(subject)
          @subject = subject
          actual = subject.identifier
          return true if actual == @value

          fail_with(
            "expected #{format_subject} to have identifier #{@value.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have identifier #{@value.inspect}"
        end
      end
    end
  end
end
