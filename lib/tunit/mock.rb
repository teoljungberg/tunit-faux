require "tunit/mock/double"
require "tunit/mock/null_object"

module Tunit
  module Mock
    TYPE_LOOKUP = {
      null_object: NullObject,
      spy: Spy,
    }
    TYPE_LOOKUP.default = Double

    def self.new(type = nil)
      TYPE_LOOKUP[type].new
    end
  end
end
