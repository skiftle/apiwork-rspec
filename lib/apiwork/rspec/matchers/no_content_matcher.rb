# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an action has no response content.
      class NoContentMatcher < BaseMatcher
        def matches?(subject)
          @subject = subject
          return true if subject.response.no_content?

          fail_with("expected #{format_subject} to be no content, but it has content")
        end

        def description
          'be no content'
        end
      end
    end
  end
end
