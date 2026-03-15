# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying a representation has the expected root key.
      class HaveRootMatcher < BaseMatcher
        def initialize(singular, plural)
          super()
          @singular = singular
          @plural = plural
        end

        def matches?(subject)
          @subject = subject
          root = subject.root_key
          actual_singular = root.singular
          actual_plural = root.plural

          return true if actual_singular == @singular && actual_plural == @plural

          fail_with(
            "expected #{format_subject} to have root #{@singular.inspect}, #{@plural.inspect}, " \
            "but got #{actual_singular.inspect}, #{actual_plural.inspect}",
          )
        end

        def description
          "have root #{@singular.inspect}, #{@plural.inspect}"
        end
      end
    end
  end
end
