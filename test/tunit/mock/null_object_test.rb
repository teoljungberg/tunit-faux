require "test_helper"
require "tunit/mock/null_object"

module Tunit::Mock
  class NullObjectTest < Minitest::Test
    def test_method_missing_gathers_all_calls
      mock = NullObject.new

      mock.foo.bar.baz

      assert_equal [:foo, :bar, :baz], mock.calls.map(&:method_name)
    end

    def test_method_missing_acts_as_a_null_object
      mock = NullObject.new

      assert_equal mock, mock.whatever
    end
  end

  class SpyTest < Minitest::Test
    def test_works_as_a_null_object
      assert Spy < NullObject
    end
  end
end
