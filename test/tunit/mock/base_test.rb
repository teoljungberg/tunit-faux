require "test_helper"
require "tunit/mock/base"

module Tunit::Mock
  class BaseTest < Minitest::Test
    def test_calls
      mock = Base.new

      assert_instance_of Array, mock.calls
      assert_empty mock.calls
    end

    def test_method_missing_gathers_calls
      mock = Base.new

      mock.foo(1)
      mock.foo(2)

      assert_equal 2, mock.calls.size
    end

    def test_method_missing_wraps_calls_as_an_object
      mock = Base.new

      mock.foo(1)
      method_call = mock.calls.first

      assert_equal :foo, method_call.method_name
      assert_equal [1], method_call.arguments
      assert_instance_of Proc, method_call.block
    end

    def test_method_missing_hides_its_implementation
      mock = Base.new

      assert_equal :foo, mock.foo(1)
    end
  end
end
