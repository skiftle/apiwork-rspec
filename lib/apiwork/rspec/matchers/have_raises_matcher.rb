# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an action has the expected raises.
      class HaveRaisesMatcher < BaseMatcher
        def initialize(codes)
          super()
          @codes = codes
        end

        def matches?(subject)
          @subject = subject
          actual = subject.raises
          return true if actual == @codes

          fail_with(
            "expected #{format_subject} to have raises #{@codes.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have raises #{@codes.inspect}"
        end
      end
    end
  end
end
