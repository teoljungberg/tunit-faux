module Tunit
  class Mock
    attr_reader :name, :calls

    def initialize(name: :mock)
      @name = name
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

      def initialize(method_name: nil, arguments: [], block: nil)
        @method_name = method_name
        @arguments = arguments
        @block ||= -> {}
      end

      alias_method :args, :arguments
    end
  end
end
