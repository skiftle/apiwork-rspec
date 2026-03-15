# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying a subject has the expected example.
      class HaveExampleMatcher < BaseMatcher
        def initialize(value)
          super()
          @value = value
        end

        def matches?(subject)
          @subject = subject
          actual = subject.example
          return true if actual == @value

          fail_with(
            "expected #{format_subject} to have example #{@value.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have example #{@value.inspect}"
        end
      end
    end
  end
end
