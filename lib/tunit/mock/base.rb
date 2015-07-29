module Tunit
  module Mock
    class Base
      attr_reader :name, :calls

      def initialize(name = nil)
        @name = name || DEFAULT_NAME
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

      def inspect
        "#<%{class} (%{name})>" % {
          class: normaized_class_name,
          name: name,
        }
      end

      private

      DEFAULT_NAME = "anonymous"
      private_constant :DEFAULT_NAME

      def normaized_class_name
        self.class.to_s.sub("Tunit::Mock::", "")
      end

      class MetohodCall
        attr_reader :method_name, :arguments, :block

        def initialize(method_name:, arguments:, block:)
          @method_name = method_name
          @arguments = Array(arguments)
          @block = block || -> {}
        end
      end
      private_constant :MetohodCall
    end
  end
end
