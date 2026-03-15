# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an action has the expected tags.
      class HaveTagsMatcher < BaseMatcher
        def initialize(tags)
          super()
          @tags = tags
        end

        def matches?(subject)
          @subject = subject
          actual = subject.tags
          return true if actual == @tags

          fail_with(
            "expected #{format_subject} to have tags #{@tags.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have tags #{@tags.inspect}"
        end
      end
    end
  end
end
