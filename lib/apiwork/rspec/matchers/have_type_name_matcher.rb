# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying a representation has the expected type name.
      class HaveTypeNameMatcher < BaseMatcher
        def initialize(value)
          super()
          @value = value
        end

        def matches?(subject)
          @subject = subject
          actual = subject.type_name
          return true if actual == @value

          fail_with(
            "expected #{format_subject} to have type name #{@value.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have type name #{@value.inspect}"
        end
      end
    end
  end
end
