# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an API has a specific export enabled.
      class HaveExportMatcher < BaseMatcher
        def initialize(name)
          super()
          @name = name
        end

        def matches?(subject)
          @subject = subject
          return true if subject.export_configs.key?(@name)

          fail_with(
            "expected #{format_subject} to have export #{@name.inspect}",
          )
        end

        def description
          "have export #{@name.inspect}"
        end
      end
    end
  end
end
