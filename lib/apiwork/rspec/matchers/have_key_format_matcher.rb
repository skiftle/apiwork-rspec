# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an API has the expected key format.
      class HaveKeyFormatMatcher < BaseMatcher
        def initialize(format)
          super()
          @format = format
        end

        def matches?(subject)
          @subject = subject
          actual = subject.key_format
          return true if actual == @format

          fail_with(
            "expected #{format_subject} to have key format #{@format.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have key format #{@format.inspect}"
        end
      end
    end
  end
end
