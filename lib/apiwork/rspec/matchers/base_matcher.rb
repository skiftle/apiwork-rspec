# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Base class for matchers.
      class BaseMatcher
        include ::RSpec::Matchers::Composable

        attr_reader :failure_message

        def initialize
          @failure_message = nil
        end

        def does_not_match?(subject)
          !matches?(subject)
        end

        def failure_message_when_negated
          "expected #{format_subject} not to #{description}"
        end

        private

        def format_subject
          @subject.respond_to?(:name) ? @subject.name : @subject.to_s
        end

        def fail_with(message)
          @failure_message = message
          false
        end

        def join_sentence(words)
          return words.join(' and ') if words.size <= 2

          "#{words[0..-2].join(', ')}, and #{words[-1]}"
        end
      end
    end
  end
end
