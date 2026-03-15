# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an API info defines a server.
      class DefineServerMatcher < BaseMatcher
        def initialize(url)
          super()
          @url = url
          @checks = {}
        end

        # @api public
        # Requires the server to have the expected description.
        #
        # @param text [String]
        #   The description.
        # @return [self]
        def with_description(text)
          @checks[:description] = text
          self
        end

        def matches?(subject)
          @subject = subject
          server = subject.servers.find { |s| s.url == @url }
          return fail_with("expected #{format_subject} to define server #{@url.inspect}") unless server

          return true unless @checks.key?(:description)

          actual = server.description
          return true if actual == @checks[:description]

          fail_with(
            "expected #{format_subject} to define server #{@url.inspect} " \
            "with description #{@checks[:description].inspect}, but got #{actual.inspect}",
          )
        end

        def description
          parts = ["define server #{@url.inspect}"]
          parts << "with description #{@checks[:description].inspect}" if @checks.key?(:description)
          parts.join(' ')
        end
      end
    end
  end
end
