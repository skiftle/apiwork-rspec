# frozen_string_literal: true

module Apiwork
  module RSpec
    module Matchers
      class ParamWrapper
        attr_reader :name,
                    :params

        def initialize(name, param)
          @name = name
          @params = param[:params] || {}
        end
      end
    end
  end
end
