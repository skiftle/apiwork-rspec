# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying a contract has the expected representation.
      class HaveRepresentationMatcher < BaseMatcher
        def initialize(klass)
          super()
          @klass = klass
        end

        def matches?(subject)
          @subject = subject
          actual = subject.representation_class
          return true if actual == @klass

          fail_with(
            "expected #{format_subject} to have representation #{@klass.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have representation #{@klass.inspect}"
        end
      end
    end
  end
end
