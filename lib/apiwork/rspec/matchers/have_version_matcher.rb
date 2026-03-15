# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an API info has the expected version.
      class HaveVersionMatcher < BaseMatcher
        def initialize(text)
          super()
          @text = text
        end

        def matches?(subject)
          @subject = subject
          actual = subject.version
          return true if actual == @text

          fail_with(
            "expected #{format_subject} to have version #{@text.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have version #{@text.inspect}"
        end
      end
    end
  end
end
