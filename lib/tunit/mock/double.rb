require "tunit/mock/base"

module Tunit
  module Mock
    class Double < Base
      UnexpectedMethod = Class.new(Exception)

      attr_reader :expected_methods

      def initialize(**methods)
        super()
        @expected_methods = methods
      end

      def method_missing(method_name, *args, &block)
        if expected_methods.has_key?(method_name)
          super
          expected_methods[method_name]
        else
          raise UnexpectedMethod, "`#{method_name}' was not expected to be called"
        end
      end
    end
  end
end
