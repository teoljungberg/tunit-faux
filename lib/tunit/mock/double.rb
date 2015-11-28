require "tunit/mock/base"

module Tunit
  module Mock
    class Double < Base
      UnexpectedMethod = Class.new(Exception)

      attr_reader :expected_methods

      def initialize(*stubs)
        stubs = stubs.flatten
        name = calculate_name(stubs)
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
        stubs = stubs.detect { |element| element.is_a? Hash }
        if stubs
          @expected_methods = stubs
        else
          @expected_methods = {}
        end
      end
    end
  end
end
