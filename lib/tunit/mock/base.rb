module Tunit
  module Mock
    class Base
      attr_reader :calls

      def initialize
        @calls = []
      end

      def method_missing(method_name, *args, &block)
        calls << MetohodCall.new(
          method_name: method_name,
          arguments: args,
          block: block,
        )
        method_name
      end

      class MetohodCall
        attr_reader :method_name, :arguments, :block

        def initialize(method_name:, arguments:, block:)
          @method_name = method_name
          @arguments = Array(arguments)
          @block = block || -> {}
        end
      end
    end
  end
end
