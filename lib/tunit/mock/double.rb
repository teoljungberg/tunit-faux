require "tunit/mock/base"

module Tunit
  module Mock
    class Double < Base
      UnexpectedMethod = Class.new(Exception)

      attr_reader :expected_methods

      def initialize(*stubs)
        name = stubs.shift if stubs.first.is_a? String
        super(name)
        assign_stubs(stubs)
      end

      def method_missing(method_name, *args, &block)
        if expected_methods.has_key?(method_name)
          super
          expected_methods[method_name]
        else
          raise UnexpectedMethod, "`#{method_name}' was not expected to be called"
        end
      end

      private

      def assign_stubs(stubs)
        if stubs.first.is_a? Hash
          @expected_methods = stubs.shift
        else
          @expected_methods = {}
        end
      end
    end
  end
end
