# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying a representation has the expected model.
      class HaveModelMatcher < BaseMatcher
        def initialize(klass)
          super()
          @klass = klass
        end

        def matches?(subject)
          @subject = subject
          actual = subject.model_class
          return true if actual == @klass

          fail_with(
            "expected #{format_subject} to have model #{@klass.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have model #{@klass.inspect}"
        end
      end
    end
  end
end
