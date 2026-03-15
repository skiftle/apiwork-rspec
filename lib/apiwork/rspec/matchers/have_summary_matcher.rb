# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an action has the expected summary.
      class HaveSummaryMatcher < BaseMatcher
        def initialize(text)
          super()
          @text = text
        end

        def matches?(subject)
          @subject = subject
          actual = subject.summary
          return true if actual == @text

          fail_with(
            "expected #{format_subject} to have summary #{@text.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have summary #{@text.inspect}"
        end
      end
    end
  end
end
