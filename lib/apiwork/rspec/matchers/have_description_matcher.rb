# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying a subject has the expected description.
      class HaveDescriptionMatcher < BaseMatcher
        def initialize(text)
          super()
          @text = text
        end

        def matches?(subject)
          @subject = subject
          actual = subject.description
          return true if actual == @text

          fail_with(
            "expected #{format_subject} to have description #{@text.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have description #{@text.inspect}"
        end
      end
    end
  end
end
