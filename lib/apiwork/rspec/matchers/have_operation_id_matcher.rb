# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an action has the expected operation ID.
      class HaveOperationIdMatcher < BaseMatcher
        def initialize(id)
          super()
          @id = id
        end

        def matches?(subject)
          @subject = subject
          actual = subject.operation_id
          return true if actual == @id

          fail_with(
            "expected #{format_subject} to have operation ID #{@id.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have operation ID #{@id.inspect}"
        end
      end
    end
  end
end
