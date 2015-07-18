require "tunit/mock/base"

module Tunit
  module Mock
    class NullObject < Base
      def method_missing(method_name, *args, &block)
        super
        self
      end
    end

    class Spy < NullObject
    end
  end
end
