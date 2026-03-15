# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying a union has the expected discriminator.
      class HaveDiscriminatorMatcher < BaseMatcher
        def initialize(field)
          super()
          @field = field
        end

        def matches?(subject)
          @subject = subject
          actual = subject.discriminator
          return true if actual == @field

          fail_with(
            "expected #{format_subject} to have discriminator #{@field.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have discriminator #{@field.inspect}"
        end
      end
    end
  end
end
