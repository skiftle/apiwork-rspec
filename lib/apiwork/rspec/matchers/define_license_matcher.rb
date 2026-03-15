# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an API info defines a license.
      class DefineLicenseMatcher < BaseMatcher
        def initialize(name)
          super()
          @name = name
          @checks = {}
        end

        # @api public
        # Requires the license to have the expected URL.
        #
        # @param url [String]
        #   The URL.
        # @return [self]
        def with_url(url)
          @checks[:url] = url
          self
        end

        def matches?(subject)
          @subject = subject
          license = subject.license
          return fail_with("expected #{format_subject} to define license #{@name.inspect}") unless license
          unless license.name == @name
            return fail_with("expected #{format_subject} to define license #{@name.inspect}, but got #{license.name.inspect}")
          end

          return true unless @checks.key?(:url)

          actual = license.url
          return true if actual == @checks[:url]

          fail_with(
            "expected #{format_subject} to define license #{@name.inspect} " \
            "with url #{@checks[:url].inspect}, but got #{actual.inspect}",
          )
        end

        def description
          parts = ["define license #{@name.inspect}"]
          parts << "with url #{@checks[:url].inspect}" if @checks.key?(:url)
          parts.join(' ')
        end
      end
    end
  end
end
