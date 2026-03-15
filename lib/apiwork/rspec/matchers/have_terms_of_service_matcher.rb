# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an API info has the expected terms of service.
      class HaveTermsOfServiceMatcher < BaseMatcher
        def initialize(url)
          super()
          @url = url
        end

        def matches?(subject)
          @subject = subject
          actual = subject.terms_of_service
          return true if actual == @url

          fail_with(
            "expected #{format_subject} to have terms of service #{@url.inspect}, but got #{actual.inspect}",
          )
        end

        def description
          "have terms of service #{@url.inspect}"
        end
      end
    end
  end
end
