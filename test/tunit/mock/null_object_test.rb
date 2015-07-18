require "test_helper"
require "tunit/mock/null_object"

module Tunit::Mock
  module ActsLikeANullObject
    def test_method_missing_gathers_all_calls
      mock = klass.new

      mock.foo.bar.baz

      assert_equal [:foo, :bar, :baz], mock.calls.map(&:method_name)
    end

    def test_method_missing_acts_as_a_null_object
      mock = klass.new

      assert_equal mock, mock.whatever
    end
  end

  class NullObjectTest < Minitest::Test
    include ActsLikeANullObject

    def klass
      NullObject
    end
  end

  class SpyTest < Minitest::Test
    include ActsLikeANullObject

    def klass
      Spy
    end
  end
end
