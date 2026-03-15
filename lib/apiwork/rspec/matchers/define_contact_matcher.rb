# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      # @api public
      # Matcher for verifying an API info defines a contact.
      class DefineContactMatcher < BaseMatcher
        VALUE_CHECKS = {
          email: :email,
          url: :url,
        }.freeze

        def initialize(name)
          super()
          @name = name
          @checks = {}
        end

        # @api public
        # Requires the contact to have the expected email.
        #
        # @param email [String]
        #   The email.
        # @return [self]
        def with_email(email)
          @checks[:email] = email
          self
        end

        # @api public
        # Requires the contact to have the expected URL.
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
          contact = subject.contact
          return fail_with("expected #{format_subject} to define contact #{@name.inspect}") unless contact
          unless contact.name == @name
            return fail_with("expected #{format_subject} to define contact #{@name.inspect}, but got #{contact.name.inspect}")
          end

          verify_value_checks(contact)
        end

        def description
          parts = ["define contact #{@name.inspect}"]
          VALUE_CHECKS.each_key do |key|
            parts << "with #{key} #{@checks[key].inspect}" if @checks.key?(key)
          end
          parts.join(' ')
        end

        private

        def verify_value_checks(contact)
          VALUE_CHECKS.each do |key, method|
            next unless @checks.key?(key)

            actual = contact.public_send(method)
            next if actual == @checks[key]

            return fail_with(
              "expected #{format_subject} to define contact #{@name.inspect} " \
              "with #{key} #{@checks[key].inspect}, but got #{actual.inspect}",
            )
          end
          true
        end
      end
    end
  end
end
